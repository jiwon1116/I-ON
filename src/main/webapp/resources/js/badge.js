// /resources/js/badge.js
(() => {
  if (window.__TRUST_BADGE_JS_LOADED__) return;
  window.__TRUST_BADGE_JS_LOADED__ = true;

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

/* 관리자 강조: 링크까지 확실히 파랗게 */
.is-admin, .is-admin a{font-weight:700;color:#2563eb !important}

.admin-chip{
  display:inline-block;margin-left:6px;padding:2px 6px;
  font-size:11px;font-weight:600;border-radius:9999px;
  background:rgba(37,99,235,.12);color:#1e40af;border:1px solid rgba(37,99,235,.25)
}
@media (prefers-color-scheme: dark){
  .is-admin, .is-admin a{color:#93c5fd !important}
  .admin-chip{background:rgba(147,197,253,.18);color:#bfdbfe;border-color:rgba(147,197,253,.35)}
}
    `;
    document.head.appendChild(style);
  }

  const isBadge = el => el?.classList?.contains('trust-badge');
  const isAdminChip = el => el?.classList?.contains('admin-chip');
  const alreadyHasBadge = el => isBadge(el?.nextElementSibling);
  const alreadyHasAdminChip = el => isAdminChip(el?.nextElementSibling);

  function pickNickname(el) {
    const d = (el.dataset.nickname || '').trim();
    if (d) return d;
    return (el.textContent || '').trim();
  }

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

  async function fetchBadgeMeta(names) {
    const ctx = document.querySelector('meta[name="ctx"]')?.content || '';
    const qs = encodeURIComponent(names.join(','));
    try {
      const r = await fetch(`${ctx}/api/member/badges?nicknames=${qs}`, { credentials: 'same-origin' });
      if (r.ok) return await r.json(); // { nick: {level, admin} }
    } catch {}
    // 백업: level만 (관리자 미표시)
    try {
      const r2 = await fetch(`${ctx}/api/member/levels?nicknames=${qs}`, { credentials: 'same-origin' });
      if (!r2.ok) return {};
      const levels = await r2.json(); // { nick: level }
      const out = {};
      names.forEach(n => out[n] = { level: levels[n] ?? 1, admin: false });
      return out;
    } catch { return {}; }
  }

  let inflight = false;
  async function attachBadges() {
    if (inflight) return;
    inflight = true;
    try {
      injectStyleOnce();

      const all = Array.from(document.querySelectorAll('.js-user'))
        .filter(n => pickNickname(n).length > 0);

      all.forEach(dedupeAround);

      const targets = all.filter(n => n.dataset.badgeAttached !== '1' && !alreadyHasBadge(n) && !alreadyHasAdminChip(n));
      const names = [...new Set(targets.map(pickNickname))];
      if (names.length === 0) return;

      const metaMap = await fetchBadgeMeta(names);

      targets.forEach(n => {
        if (n.dataset.badgeAttached === '1' || alreadyHasBadge(n) || alreadyHasAdminChip(n)) {
          dedupeAround(n);
          return;
        }

        const nick = pickNickname(n);
        const meta = metaMap[nick] || { level: 1, admin: false };

        // 관리자면 칩 + 파란색, 이모지 배지는 제거
        if (meta.admin === true || meta.admin === 1 || meta.admin === '1' || meta.admin === 'Y') {
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

        // 일반 회원: 이모지 배지
        if (isAdminChip(n.nextElementSibling)) n.nextElementSibling.remove();
        const lv = Number(meta.level ?? 1);
        const emoji = lv === 3 ? '🏆' : (lv === 2 ? '🏠' : '🌱');

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
  window.attachBadges = attachBadges;
})();
