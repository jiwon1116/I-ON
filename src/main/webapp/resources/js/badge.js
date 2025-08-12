// badge.js
document.addEventListener('DOMContentLoaded', async () => {
  const nodes = Array.from(document.querySelectorAll('.js-user[data-nickname]'));
  const names = [...new Set(nodes.map(n => n.dataset.nickname).filter(Boolean))];
  if (names.length === 0) return;

  const res = await fetch('/api/member/levels?nicknames=' + encodeURIComponent(names.join(',')));
  const map = await res.json(); // { nickname: level }

  nodes.forEach(n => {
    const lv = map[n.dataset.nickname] ?? 1;
    const emoji = lv === 3 ? '👑' : (lv === 2 ? '🥜' : '🌱');
    const badge = document.createElement('span');
    badge.className = 'trust-badge badge-l' + lv;
    badge.textContent = emoji;
    n.insertAdjacentElement('afterend', badge);
  });
});
// resources/js/badge.js
(() => {
  // 0) 싱글톤 가드
  if (window.__TRUST_BADGE_JS_LOADED__) return;
  window.__TRUST_BADGE_JS_LOADED__ = true;

  // 1) CSS 1회 주입 (바로 쓰는 스타일)
  const STYLE_ID = 'trust-badge-style';
  function injectStyleOnce() {
    if (document.getElementById(STYLE_ID)) return;
    const style = document.createElement('style');
    style.id = STYLE_ID;
    style.textContent = `
.trust-badge{display:inline-flex;align-items:center;justify-content:center;width:18px;height:18px;border-radius:50%;font-size:12px;margin-left:4px}
.badge-l1{background:#e9f7ec}
.badge-l2{background:#f9efe2}
.badge-l3{background:#fff3cd}

/* 관리자 강조(굵게+파란톤) */
.is-admin{font-weight:700;}

/* 관리자 칩 */
.admin-chip{
  display:inline-block;margin-left:6px;padding:2px 6px;
  font-size:11px;font-weight:600;border-radius:9999px;
  background:rgba(37,99,235,.12);color:#1e40af;border:1px solid rgba(37,99,235,.25)
}

/* 다크 모드 보정(옵션) */
@media (prefers-color-scheme: dark){
  .is-admin{color:#93c5fd}
  .admin-chip{background:rgba(147,197,253,.18);color:#bfdbfe;border-color:rgba(147,197,253,.35)}
}
    `;
    document.head.appendChild(style);
  }

  // 2) 유틸
  const isBadge = el => !!(el && el.classList && el.classList.contains('trust-badge'));
  const isAdminChip = el => !!(el && el.classList && el.classList.contains('admin-chip'));
  const alreadyHasBadge = el => isBadge(el?.nextElementSibling);
  const alreadyHasAdminChip = el => isAdminChip(el?.nextElementSibling);

  // el 다음에 연속된 배지/칩 중복 제거(첫 것만 남김)
  function dedupeAround(el) {
    let cur = el.nextElementSibling;
    let seenBadge = false, seenChip = false;
    while (cur && (isBadge(cur) || isAdminChip(cur))) {
      const isB = isBadge(cur), isC = isAdminChip(cur);
      const shouldRemove = (isB && seenBadge) || (isC && seenChip);
      if (shouldRemove) {
        const rm = cur; cur = cur.nextElementSibling; rm.remove(); continue;
      }
      if (isB) seenBadge = true;
      if (isC) seenChip = true;
      cur = cur.nextElementSibling;
    }
    if (seenBadge || seenChip) el.dataset.badgeAttached = '1';
  }

  // 3) 동시 실행 방지
  let inflight = false;

  // 4) 데이터 가져오기: /badges(레벨+관리자) → 실패 시 /levels(레벨만)
  async function fetchBadgeMeta(names) {
    const ctx = document.querySelector('meta[name="ctx"]')?.content || '';
    const qs = encodeURIComponent(names.join(','));
    // try /badges
    try {
      const r = await fetch(`${ctx}/api/member/badges?nicknames=${qs}`, { credentials: 'same-origin' });
      if (r.ok) return await r.json(); // { nick: {level, admin} }
    } catch {}
    // fallback /levels
    try {
      const r2 = await fetch(`${ctx}/api/member/levels?nicknames=${qs}`, { credentials: 'same-origin' });
      if (!r2.ok) return {};
      const levels = await r2.json(); // { nick: level }
      const out = {};
      names.forEach(n => out[n] = { level: levels[n] ?? 1, admin: false });
      return out;
    } catch {
      return {};
    }
  }

  // 5) 메인
  async function attachBadges() {
    if (inflight) return;
    inflight = true;
    try {
      injectStyleOnce();

      const all = Array.from(document.querySelectorAll('.js-user[data-nickname]'))
        .filter(n => (n.dataset.nickname || '').trim().length > 0);

      // 기존 중복 정리
      all.forEach(dedupeAround);

      // 아직 안 붙은 대상
      const targets = all.filter(n => n.dataset.badgeAttached !== '1' && !alreadyHasBadge(n) && !alreadyHasAdminChip(n));
      const names = [...new Set(targets.map(n => n.dataset.nickname.trim()))];
      if (names.length === 0) return;

      const metaMap = await fetchBadgeMeta(names); // { nick: {level, admin} }

      targets.forEach(n => {
        // 직전 재검사
        if (n.dataset.badgeAttached === '1' || alreadyHasBadge(n) || alreadyHasAdminChip(n)) {
          dedupeAround(n);
          return;
        }

        const meta = metaMap[n.dataset.nickname] || { level:1, admin:false };

        if (meta.admin) {
          // 관리자: 배지 제거, 이름 강조 + '관리자' 칩
          n.classList.add('is-admin');
          // 혹시 붙어있던 배지/칩 정리
          if (isBadge(n.nextElementSibling)) n.nextElementSibling.remove();
          if (!alreadyHasAdminChip(n)) {
            const chip = document.createElement('span');
            chip.className = 'admin-chip';
            chip.textContent = '관리자';
            n.insertAdjacentElement('afterend', chip);
          }
          n.dataset.badgeAttached = '1';
          dedupeAround(n);
          return;
        }

        // 일반 회원: 관리자 칩이 혹시 있으면 제거(권한 변경 대응)
        if (isAdminChip(n.nextElementSibling)) n.nextElementSibling.remove();

        const lv = meta.level ?? 1;
        const emoji = lv === 3 ? '👑' : (lv === 2 ? '🥜' : '🌱');

        const badge = document.createElement('span');
        badge.className = 'trust-badge badge-l' + lv;
        badge.textContent = emoji;

        n.insertAdjacentElement('afterend', badge);
        n.dataset.badgeAttached = '1';
        dedupeAround(n);
      });
    } catch (e) {
      console.warn('attachBadges failed:', e);
    } finally {
      inflight = false;
    }
  }

  document.addEventListener('DOMContentLoaded', attachBadges);
  window.attachBadges = attachBadges; // 동적 렌더 후 수동 호출용
})();
