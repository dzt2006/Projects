const ENTRIES = [
  { date: '2026-11-18', kind: 'log',   title: '小站改版记',       href: 'logs.html#e-1118' },
  { date: '2026-11-16', kind: 'daily', title: '楼下桂花开得正好', href: 'daily.html#e-1116' },
  { date: '2026-11-10', kind: 'log',   title: '初识 nginx',       href: 'logs.html#e-1110' },
  { date: '2026-11-09', kind: 'daily', title: '煮了一壶茶',       href: 'daily.html#e-1109' },
  { date: '2026-11-02', kind: 'daily', title: '夜跑三公里',       href: 'daily.html#e-1102' },
];

const KIND_LABEL = { daily: '日常', log: '日志' };

const YI = ['煮茶', '记录', '看云', '慢走', '读旧诗', '浇花', '睡午觉', '听雨'];
const JI = ['赶时间', '追热点', '熬夜', '想太多', '辜负饭菜'];

function renderStats() {
  const box = document.getElementById('profile-stats');
  if (!box) return;
  const daily = ENTRIES.filter(e => e.kind === 'daily').length;
  const log = ENTRIES.filter(e => e.kind === 'log').length;
  const quotes = typeof QUOTES !== 'undefined' ? QUOTES.length : 0;
  box.innerHTML = `
    <a href="daily.html"><b>${daily}</b><span>日常</span></a>
    <a href="logs.html"><b>${log}</b><span>日志</span></a>
    <a href="poems.html"><b>${quotes}</b><span>撷句</span></a>`;
}

function renderShelf() {
  const box = document.getElementById('shelf');
  if (!box) return;
  const tilts = [-1.6, 1.2, -0.8, 1.8, -1.2];
  box.innerHTML = ENTRIES.map((e, i) => {
    const [, m, d] = e.date.split('-');
    return `
    <a class="shelf-good" style="--tilt:${tilts[i % tilts.length]}deg" href="${e.href}">
      <span class="good-meta"><i class="d-swatch d-${e.kind}"></i>${m}-${d} · ${KIND_LABEL[e.kind]}</span>
      <b class="good-title">${e.title}</b>
    </a>`;
  }).join('');
  const count = document.getElementById('shelf-count');
  if (count) count.textContent = `架上 ${ENTRIES.length} 件 · 慢慢补货`;
}

function renderAlmanac() {
  const box = document.getElementById('hero-almanac');
  if (!box) return;
  const now = new Date();
  const week = ['日', '一', '二', '三', '四', '五', '六'][now.getDay()];
  const day = Math.floor((now - new Date(now.getFullYear(), 0, 0)) / 864e5);
  const pick = (arr, n, off) => Array.from({ length: n }, (_, i) => arr[(day + off + i * 3) % arr.length]);
  box.innerHTML = `
    <p class="almanac-date"><b>${now.getMonth() + 1}月${now.getDate()}日</b><span>周${week} · 今年第 ${day} 天</span></p>
    <ul>
      <li><i class="al-yi">宜</i>${pick(YI, 3, 0).join(' · ')}</li>
      <li><i class="al-ji">忌</i>${pick(JI, 2, 1).join(' · ')}</li>
    </ul>`;
}

function renderNow() {
  const box = document.getElementById('profile-now');
  if (!box) return;
  const now = new Date();
  const week = ['日', '一', '二', '三', '四', '五', '六'][now.getDay()];
  const day = Math.floor((now - new Date(now.getFullYear(), 0, 0)) / 864e5);
  box.innerHTML = `
    <p class="now-time"><b>--:--</b><span>:--</span></p>
    <p class="now-date">${now.getMonth() + 1}月${now.getDate()}日 · 周${week} · 长沙</p>
    <p class="now-yi"><i class="al-yi">宜</i>${YI[day % YI.length]}</p>`;
  const b = box.querySelector('.now-time b');
  const s = box.querySelector('.now-time span');
  const pad = n => String(n).padStart(2, '0');
  const tick = () => {
    const t = new Date();
    b.textContent = `${pad(t.getHours())}:${pad(t.getMinutes())}`;
    s.textContent = `:${pad(t.getSeconds())}`;
  };
  tick();
  setInterval(tick, 1000);
}

const SEASONS = [
  { key: 'spring', name: '春', verse: '春水碧于天，画船听雨眠。', source: '韦庄 · 菩萨蛮', months: [2, 3, 4] },
  { key: 'summer', name: '夏', verse: '荷风送香气，竹露滴清响。', source: '孟浩然 · 夏日南亭怀辛大', months: [5, 6, 7] },
  { key: 'autumn', name: '秋', verse: '桂子月中落，天香云外飘。', source: '宋之问 · 灵隐寺', months: [8, 9, 10] },
  { key: 'winter', name: '冬', verse: '晚来天欲雪，能饮一杯无。', source: '白居易 · 问刘十九', months: [11, 0, 1] },
];

function renderSeasons() {
  const box = document.getElementById('seasons');
  if (!box) return;
  const m = new Date().getMonth();
  box.innerHTML = SEASONS.map(s => {
    const now = s.months.includes(m);
    return `
    <div class="season s-${s.key}${now ? ' now' : ''}">
      ${now ? '<i class="season-now">当季</i>' : ''}
      <b>${s.name}</b>
      <p>${s.verse}</p>
      <span>${s.source}</span>
    </div>`;
  }).join('');
}

const WISHES = [
  '等桂花开满楼下，去站一会儿。',
  '挑一个落雨的晚上，煮茶读旧诗。',
  '把《云边有个小卖部》再读一遍。',
  '给很久没联系的朋友写封信。',
];
const WISH_KEY = 'dztfun-wish-v1';

function renderWishes() {
  const ul = document.getElementById('wish-list');
  if (!ul) return;
  let done = [];
  try {
    const saved = JSON.parse(localStorage.getItem(WISH_KEY) || '[]');
    if (Array.isArray(saved)) done = saved.filter(i => Number.isInteger(i) && i >= 0 && i < WISHES.length);
  } catch (e) { done = []; }
  const paint = () => {
    ul.innerHTML = WISHES.map((w, i) => {
      const on = done.includes(i);
      return `
      <li><button class="wish${on ? ' done' : ''}" data-i="${i}" aria-pressed="${on}">
        <i class="wish-box fa-${on ? 'solid fa-square-check' : 'regular fa-square'}"></i><span>${w}</span>
      </button></li>`;
    }).join('');
    const count = document.getElementById('wish-count');
    if (count) count.textContent = `已勾 ${done.length} / ${WISHES.length} · 勾不勾都行，日子不急`;
  };
  paint();
  ul.addEventListener('click', e => {
    const btn = e.target.closest('.wish');
    if (!btn) return;
    const i = +btn.dataset.i;
    const on = !done.includes(i);
    done = on ? [...done, i] : done.filter(x => x !== i);
    try { localStorage.setItem(WISH_KEY, JSON.stringify(done)); } catch (err) { /* 隐私模式下只留在本页 */ }
    paint();
    if (on) {
      const box = ul.querySelector(`.wish[data-i="${i}"] .wish-box`);
      if (box) box.classList.add('pop');
    }
  });
}

renderStats();
renderShelf();
renderAlmanac();
renderSeasons();
renderWishes();
renderNow();