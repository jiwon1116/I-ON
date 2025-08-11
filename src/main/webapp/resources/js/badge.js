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
// /resources/js/badge.js
(() => {
  // 중복 로드 가드
  if (window.__TRUST_BADGE_JS_LOADED__) return;
  window.__TRUST_BADGE_JS_LOADED__ = true;

  // --- 1) 한번만 주입할 CSS ---
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

/* 관리자 강조(닉네임 파란색) */
.is-admin{font-weight:700;color:#2563eb}

/* 관리자 칩 */
.admin-chip{
  display:inline-block;margin-left:6px;padding:2px 6px;
  font-size:11px;font-weight:600;border-radius:9999px;
  background:rgba(37,99,235,.12);color:#1e40af;border:1px solid rgba(37,99,235,.25)
}

/* 다크 모드(선택) */
@media (prefers-color-scheme: dark){
  .is-admin{color:#93c5fd}
  .admin-chip{background:rgba(147,197,253,.18);color:#bfdbfe;border-color:rgba(147,197,253,.35)}
}
    `;
    document.head.appendChild(style);
  }

  // --- 2) 유틸 ---
  const isBadge = el => el?.classList?.contains('trust-badge');
  const isAdminChip = el => el?.classList?.contains('admin-chip');
  const alreadyHasBadge = el => isBadge(el?.nextElementSibling);
  const alreadyHasAdminChip = el => isAdminChip(el?.nextElementSibling);

  // .js-user 엘리먼트에서 닉네임 추출: data-nickname 우선, 없으면 텍스트
  function pickNickname(el) {
    const d = (el.dataset.nickname || '').trim();
    if (d) return d;
    return (el.textContent || '').trim();
  }

  // el 다음에 연속된 배지/칩 중복 제거(첫 것만 유지)
  function dedupeAround(el) {
    let cur = el.nextElementSibling;
    let seenBadge = false, seenChip = false;
    while (cur && (isBadge(cur) || isAdminChip(cur))) {
      const isB = isBadge(cur), isC = isAdminChip(cur);
      const shouldRemove = (isB && seenBadge) || (isC && seenChip);
      if (shouldRemove) { const rm = cur; cur = cur.nextElementSibling; rm.remove(); continue; }
      if (isB) seenBadge = true;
      if (isC) seenChip = true;
      cur = cur.nextElementSibling;
    }
    if (seenBadge || seenChip) el.dataset.badgeAttached = '1';
  }

  // --- 3) API 호출 ---
  async function fetchBadgeMeta(names) {
    const ctx = document.querySelector('meta[name="ctx"]')?.content || '';
    const qs = encodeURIComponent(names.join(','));
    // /badges (level + admin)
    try {
      const r = await fetch(`${ctx}/api/member/badges?nicknames=${qs}`, { credentials: 'same-origin' });
      if (r.ok) return await r.json(); // { nick: {level, admin} }
    } catch {}
    // 실패 시 /levels (level만)
    try {
      const r2 = await fetch(`${ctx}/api/member/levels?nicknames=${qs}`, { credentials: 'same-origin' });
      if (!r2.ok) return {};
      const levels = await r2.json(); // { nick: level }
      const out = {};
      names.forEach(n => out[n] = { level: levels[n] ?? 1, admin: false });
      return out;
    } catch { return {}; }
  }

  // --- 4) 메인 ---
  let inflight = false;
  async function attachBadges() {
    if (inflight) return;
    inflight = true;
    try {
      injectStyleOnce();

      const all = Array.from(document.querySelectorAll('.js-user'))
        .filter(n => pickNickname(n).length > 0);

      // 기존 붙은 것/중복 정리
      all.forEach(dedupeAround);

      // 아직 안 붙은 대상
      const targets = all.filter(n => n.dataset.badgeAttached !== '1' && !alreadyHasBadge(n) && !alreadyHasAdminChip(n));
      const names = [...new Set(targets.map(pickNickname))];
      if (names.length === 0) return;

      const metaMap = await fetchBadgeMeta(names); // { nick: {level, admin} }

      targets.forEach(n => {
        // 직전 재검사
        if (n.dataset.badgeAttached === '1' || alreadyHasBadge(n) || alreadyHasAdminChip(n)) {
          dedupeAround(n);
          return;
        }

        const nick = pickNickname(n);
        const meta = metaMap[nick] || { level: 1, admin: false };

        if (meta.admin === true || meta.admin === 1 || meta.admin === '1' || meta.admin === 'Y') {
          // 관리자: 배지 제거, 닉네임 파란색 + '관리자' 칩
          if (isBadge(n.nextElementSibling)) n.nextElementSibling.remove();
          n.classList.add('is-admin');
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

        // 일반 회원
        if (isAdminChip(n.nextElementSibling)) n.nextElementSibling.remove(); // 권한 변경 대응
        const lv = Number(meta.level ?? 1);
        const emoji = lv === 3 ? '👑' : (lv === 2 ? '🥜' : '🌱');

        const badge = document.createElement('span');
        badge.className = 'trust-badge badge-l' + (lv || 1);
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

  // (옵션) SPA나 동적 렌더 대응용 공개 함수
  window.attachBadges = attachBadges;
})();
