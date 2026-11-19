const QUOTES = [
  {
    id: 'qingmeng',
    type: 'poem',
    title: '满船清梦压星河',
    excerpt: '醉后不知天在水，满船清梦压星河。',
    lines: ['西风吹老洞庭波，', '一夜湘君白发多。', '醉后不知天在水，', '满船清梦压星河。'],
    source: '唐温如 · 题龙阳县青草湖',
    author: '唐温如',
    authorNote: '元末明初人，生平不详。一首诗，留名千年。',
    reason: '喜欢那种醉眼里的宇宙：水天不分，梦压在星河上，轻得没有重量，又重得装满一船。',
  },
  {
    id: 'nixing',
    type: 'poem',
    title: '人生如逆旅',
    excerpt: '人生如逆旅，我亦是行人。',
    lines: ['一别都门三改火，', '天涯踏尽红尘。', '依然一笑作春温。', '无波真古井，有节是秋筠。', '惆怅孤帆连夜发，', '送行淡月微云。', '尊前不用翠眉颦。', '人生如逆旅，我亦是行人。'],
    source: '苏轼 · 临江仙 · 送钱穆父',
    author: '苏轼',
    authorNote: '北宋文学家，字子瞻，号东坡居士。一生辗转，却把苦日子过成了诗。',
    reason: '送别词里最旷达的一句。把自己也放进「行人」里，离愁就淡了，天地就宽了。',
  },
  {
    id: 'qingshan',
    type: 'poem',
    title: '我见青山多妩媚',
    excerpt: '我见青山多妩媚，料青山见我应如是。',
    lines: ['甚矣吾衰矣。', '怅平生、交游零落，只今余几！', '白发空垂三千丈，一笑人间万事。', '问何物、能令公喜？', '我见青山多妩媚，料青山见我应如是。', '情与貌，略相似。'],
    source: '辛弃疾 · 贺新郎 · 甚矣吾衰矣',
    author: '辛弃疾',
    authorNote: '南宋词人，字幼安，号稼轩。把栏杆拍遍，却仍有青山作知己。',
    reason: '孤独到极处，反而生出深情：看山好看，便信山看我也好看。这是与自己和解的样子。',
  },
  {
    id: 'jushui',
    type: 'poem',
    title: '掬水月在手',
    excerpt: '掬水月在手，弄花香满衣。',
    lines: ['春山多胜事，', '赏玩夜忘归。', '掬水月在手，', '弄花香满衣。', '兴来无远近，', '欲去惜芳菲。', '南望鸣钟处，', '楼台深翠微。'],
    source: '于良史 · 春山夜月',
    author: '于良史',
    authorNote: '唐代诗人，生平记载不多，留诗数十首，清丽如其人。',
    reason: '十个字写尽春夜：月落在捧起的水里，香沾在弄花的手上。美不在远处，在手边。',
  },
  {
    id: 'xiaokan',
    type: 'poem',
    title: '晓看天色暮看云',
    excerpt: '晓看天色暮看云，行也思君，坐也思君。',
    lines: ['雨打梨花深闭门，', '孤负青春，虚负青春。', '赏心乐事共谁论？', '花下销魂，月下销魂。', '愁聚眉峰尽日颦，', '千点啼痕，万点啼痕。', '晓看天色暮看云，', '行也思君，坐也思君。'],
    source: '唐寅 · 一剪梅 · 雨打梨花深闭门',
    author: '唐寅',
    authorNote: '明代画家、文学家，字伯虎。桃花庵里种桃换酒钱的人。',
    reason: '思念不写「想」，写从早到晚看天看云。日子被一个人占满，却安静得不出声。',
  },
  {
    id: 'qinghuan',
    type: 'poem',
    title: '人间有味是清欢',
    excerpt: '人间有味是清欢。',
    lines: ['细雨斜风作晓寒，', '淡烟疏柳媚晴滩。', '入淮清洛渐漫漫。', '雪沫乳花浮午盏，', '蓼茸蒿笋试春盘。', '人间有味是清欢。'],
    source: '苏轼 · 浣溪沙 · 细雨斜风作晓寒',
    author: '苏轼',
    authorNote: '写这首词时，他正从黄州量移汝州，路上仍不忘一盏春茶。',
    reason: '雪沫乳花、蓼茸蒿笋，都是便宜东西。快乐原来不需要贵，只需要新鲜和空闲。',
  },
  {
    id: 'mingyue',
    type: 'poem',
    title: '明月松间照',
    excerpt: '明月松间照，清泉石上流。',
    lines: ['空山新雨后，', '天气晚来秋。', '明月松间照，', '清泉石上流。', '竹喧归浣女，', '莲动下渔舟。', '随意春芳歇，', '王孙自可留。'],
    source: '王维 · 山居秋暝',
    author: '王维',
    authorNote: '唐代诗人，字摩诘。诗中有画，画中有诗，晚年半官半隐，与山水同住。',
    reason: '雨后空山，明月照进松林，清泉从石上流过。最安静的一幅画，却是最干净的欢喜。',
  },
  {
    id: 'jubei',
    type: 'poem',
    title: '举杯邀明月',
    excerpt: '举杯邀明月，对影成三人。',
    lines: ['花间一壶酒，', '独酌无相亲。', '举杯邀明月，', '对影成三人。', '月既不解饮，', '影徒随我身。', '暂伴月将影，', '行乐须及春。'],
    source: '李白 · 月下独酌',
    author: '李白',
    authorNote: '唐代诗人，字太白，号青莲居士。把孤独也喝成了浪漫。',
    reason: '一个人喝酒，却邀来月亮和影子凑成三人。孤独到极处，反而不孤单了。',
  },
  {
    id: 'chunyu',
    type: 'poem',
    title: '随风潜入夜',
    excerpt: '随风潜入夜，润物细无声。',
    lines: ['好雨知时节，', '当春乃发生。', '随风潜入夜，', '润物细无声。', '野径云俱黑，', '江船火独明。', '晓看红湿处，', '花重锦官城。'],
    source: '杜甫 · 春夜喜雨',
    author: '杜甫',
    authorNote: '唐代诗人，字子美，被称「诗圣」。忧国忧民，也懂一朵花开。',
    reason: '好雨懂得挑时候，悄悄来，悄悄润。人做事，若也有这份不声张，就很好。',
  },
  {
    id: 'caiju',
    type: 'poem',
    title: '采菊东篱下',
    excerpt: '采菊东篱下，悠然见南山。',
    lines: ['结庐在人境，', '而无车马喧。', '问君何能尔？', '心远地自偏。', '采菊东篱下，', '悠然见南山。', '山气日夕佳，', '飞鸟相与还。', '此中有真意，', '欲辨已忘言。'],
    source: '陶渊明 · 饮酒·其五',
    author: '陶渊明',
    authorNote: '东晋诗人，字元亮，号五柳先生。不为五斗米折腰，回家种菊。',
    reason: '心静下来，住在闹市也是深山。采一束菊，抬头就撞见南山。',
  },
  {
    id: 'yuanfang',
    type: 'quote',
    title: '无穷的远方',
    excerpt: '无穷的远方，无数的人们，都和我有关。',
    lines: ['无穷的远方，无数的人们，都和我有关。'],
    source: '鲁迅 · 且介亭杂文末编 · 「这也是生活」',
    author: '鲁迅',
    authorNote: '周树人，字豫才。中国现代文学的起点之一，笔冷心热。',
    reason: '病中写下的句子，却比许多豪言更有力。它提醒我：别把世界关在门外。',
  },
  {
    id: 'suiyue',
    type: 'quote',
    title: '岁月不饶人',
    excerpt: '岁月不饶人，我亦未曾饶过岁月。',
    lines: ['岁月不饶人，我亦未曾饶过岁月。'],
    source: '木心 · 云雀叫了一整天',
    author: '木心',
    authorNote: '本名孙璞，画家、文学家。被囚多年，仍把日子过成了诗。',
    reason: '不抱怨时光，也不怕时光。这句里有股子不服输的劲。',
  },
  {
    id: 'huacao',
    type: 'quote',
    title: '门外的花',
    excerpt: '如果你来访我，我不在，请和我门外的花坐一会儿。',
    lines: ['如果你来访我，我不在，请和我门外的花坐一会儿。', '它们很温暖，我注视它们很多很多日子了。'],
    source: '汪曾祺 · 人间草木',
    author: '汪曾祺',
    authorNote: '现当代作家，写吃、写花、写人间烟火，被誉为「中国最后一个士大夫」。',
    reason: '把花当朋友，把客人也当朋友。慢悠悠的温情，全在这一句里。',
  },
  {
    id: 'congcong',
    type: 'prose',
    title: '日子为什么一去不复返',
    excerpt: '燕子去了，有再来的时候；杨柳枯了，有再青的时候；桃花谢了，有再开的时候。但是，聪明的，你告诉我，我们的日子为什么一去不复返呢？',
    lines: ['燕子去了，有再来的时候；杨柳枯了，有再青的时候；桃花谢了，有再开的时候。但是，聪明的，你告诉我，我们的日子为什么一去不复返呢？', '去的尽管去了，来的尽管来着；去来的中间，又怎样地匆匆呢？'],
    source: '朱自清 · 匆匆',
    author: '朱自清',
    authorNote: '现代散文家，字佩弦。文字干净，感情克制而深。',
    reason: '小时候背过，长大才读懂。排比越整齐，越衬出日子流逝的不对称。',
  },
  {
    id: 'jieri',
    type: 'prose',
    title: '必然会降临的节日',
    excerpt: '死是一件不必急于求成的事，死是一个必然会降临的节日。',
    lines: ['死是一件不必急于求成的事，死是一个必然会降临的节日。', '剩下的就是怎样活的问题了，这却不是在某一个瞬间就能完全想透的、不是一次性能够解决的事，怕是活多久就要想它多久了，就像是伴你终生的魔鬼或恋人。'],
    source: '史铁生 · 我与地坛',
    author: '史铁生',
    authorNote: '当代作家。二十一岁上瘫痪，却在地坛里把生死想了十五年。',
    reason: '把死叫作「节日」，不是轻慢，是放下。读完会长长呼出一口气，然后认真吃晚饭。',
  },
  {
    id: 'xianren',
    type: 'prose',
    title: '但少闲人',
    excerpt: '何夜无月？何处无竹柏？但少闲人如吾两人者耳。',
    lines: ['庭下如积水空明，水中藻、荇交横，盖竹柏影也。', '何夜无月？何处无竹柏？但少闲人如吾两人者耳。'],
    source: '苏轼 · 记承天寺夜游',
    author: '苏轼',
    authorNote: '北宋文学家，字子瞻，号东坡居士。被贬黄州，夜里还能拉着好友赏月。',
    reason: '月色夜夜都有，缺的是愿意半夜爬起来看月的人。闲，原来是一种心境。',
  },
  {
    id: 'huxin',
    type: 'prose',
    title: '上下一白',
    excerpt: '雾凇沆砀，天与云与山与水，上下一白。',
    lines: ['雾凇沆砀，天与云与山与水，上下一白。', '湖上影子，惟长堤一痕、湖心亭一点、与余舟一芥、舟中人两三粒而已。'],
    source: '张岱 · 湖心亭看雪',
    author: '张岱',
    authorNote: '明末清初文学家，号陶庵。爱雪、爱夜、爱独自出游。',
    reason: '把天地写得那样空，又把人和舟写得那样小。人小一点，心反而大了。',
  },
];

const QUOTE_TYPES = {
  poem:  { label: '诗词', icon: 'fa-solid fa-scroll',      cls: 't-poem'  },
  quote: { label: '语录', icon: 'fa-solid fa-quote-left',  cls: 't-quote' },
  prose: { label: '文段', icon: 'fa-solid fa-book-open',   cls: 't-prose' },
};

function quoteById(id) {
  return QUOTES.find(q => q.id === id);
}

function typeChip(type) {
  const t = QUOTE_TYPES[type];
  return `<span class="qtype ${t.cls}"><i class="${t.icon}"></i>${t.label}</span>`;
}

const CN_NUM = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];

function renderQuoteList(filter) {
  const box = document.getElementById('quote-list');
  if (!box) return;
  const items = filter && filter !== 'all' ? QUOTES.filter(q => q.type === filter) : QUOTES;
  box.innerHTML = items.map((q, i) => `
    <a class="qcard t-${q.type} reveal" style="--d:${(0.04 * i).toFixed(2)}s" href="quotes/read.html?id=${q.id}">
      <div class="qtop">${typeChip(q.type)}<span class="qno">其${CN_NUM[i] || i + 1}</span></div>
      <h3 class="qtitle">${q.title}</h3>
      <p class="qexcerpt">${q.excerpt}</p>
      <p class="qsource">${q.source}</p>
    </a>`).join('');
  observeReveals(box);
}

function renderQuoteFilters() {
  const box = document.getElementById('quote-filters');
  if (!box) return;
  const count = k => k === 'all' ? QUOTES.length : QUOTES.filter(q => q.type === k).length;
  const opts = [['all', '全部'], ...Object.entries(QUOTE_TYPES).map(([k, v]) => [k, v.label])];
  box.innerHTML = opts.map(([k, label], i) =>
    `<button type="button" data-type="${k}" class="${i === 0 ? 'active' : ''}">${label}<span class="f-count">${count(k)}</span></button>`).join('');
  box.addEventListener('click', e => {
    const btn = e.target.closest('button[data-type]');
    if (!btn) return;
    box.querySelectorAll('button').forEach(b => b.classList.toggle('active', b === btn));
    renderQuoteList(btn.dataset.type);
  });
  const stats = document.getElementById('rail-stats');
  if (stats) {
    const hue = { poem: 'amber', quote: 'violet', prose: 'teal' };
    stats.innerHTML = Object.entries(QUOTE_TYPES).map(([k, v]) =>
      `<li><i class="${v.icon}" style="color:var(--${hue[k]})"></i>${v.label}<b>${count(k)}</b></li>`).join('');
  }
  const rnd = document.getElementById('quote-random');
  if (rnd) rnd.addEventListener('click', () => {
    const q = QUOTES[Math.floor(Math.random() * QUOTES.length)];
    location.href = `quotes/read.html?id=${q.id}`;
  });
}

function quoteOfTheDay() {
  const now = new Date();
  const day = Math.floor((now - new Date(now.getFullYear(), 0, 0)) / 864e5);
  return QUOTES[day % QUOTES.length];
}

function renderRailToday() {
  const box = document.getElementById('rail-today');
  if (!box) return;
  const q = quoteOfTheDay();
  const excerpt = q.type === 'poem' ? q.excerpt.replace(/，/g, '，<br>') : q.excerpt;
  box.innerHTML = `
    <p class="rail-today-label"><i class="fa-regular fa-sun"></i>今日撷句</p>
    <a class="rail-today-body" href="quotes/read.html?id=${q.id}">
      <span class="rail-today-verse">${excerpt}</span>
      <span class="rail-today-source">${q.source}</span>
    </a>`;
}

function renderRailAuthors() {
  const box = document.getElementById('rail-authors');
  if (!box) return;
  const authors = [...new Set(QUOTES.map(q => q.author))];
  box.innerHTML = `<p class="rail-author-names">${authors.join(' · ')}</p>`;
}

function renderFeatured() {
  const box = document.getElementById('featured-quote');
  if (!box) return;
  const q = quoteOfTheDay();
  const isPoem = q.type === 'poem';
  const verse = isPoem
    ? q.lines.slice(-2).join('<br>')
    : q.excerpt;
  box.innerHTML = `
    <div class="featured reveal" style="--d:.1s">
      <div class="featured-meta">
        ${typeChip(q.type)}
        <h3>${q.title}</h3>
        <p class="featured-source">${q.source}</p>
        <p class="featured-reason">${q.reason}</p>
        <a class="btn btn-primary" href="quotes/read.html?id=${q.id}">读全文 <i class="fa-solid fa-arrow-right"></i></a>
      </div>
      <div class="featured-verse${isPoem ? '' : ' prose'}">${verse}</div>
    </div>`;
  observeReveals(box);
}

function renderQuoteDetail() {
  const box = document.getElementById('read-root');
  if (!box) return;
  const id = new URLSearchParams(location.search).get('id');
  const q = quoteById(id);
  if (!q) {
    box.innerHTML = `
      <div class="read-empty">
        <p>这一页还没有收进来。</p>
        <p style="margin-top:14px"><a class="btn btn-ghost" href="../poems.html"><i class="fa-solid fa-arrow-left"></i> 回撷句列表</a></p>
      </div>`;
    return;
  }
  const idx = QUOTES.indexOf(q);
  const prev = QUOTES[(idx - 1 + QUOTES.length) % QUOTES.length];
  const next = QUOTES[(idx + 1) % QUOTES.length];
  const isPoem = q.type === 'poem';
  const text = isPoem
    ? `<div class="read-text verse">${q.lines.join('<br>')}</div>`
    : `<div class="read-text prose">${q.lines.map(l => `<p>${l}</p>`).join('')}</div>`;
  document.title = `${q.title} · 撷句 · dztfun.cyou`;
  box.innerHTML = `
    <header class="page-head reveal" style="--d:.05s">
      ${typeChip(q.type)}
      <h1 style="margin-top:12px">${q.title}</h1>
      <p>${q.source}</p>
    </header>
    <div class="read-panel reveal" style="--d:.12s">
      ${text}
      <p class="read-source">—— ${q.source}</p>
    </div>
    <div class="read-grid">
      <div class="read-note reveal" style="--d:.2s">
        <h4><i class="fa-solid fa-user-pen"></i>其人其文</h4>
        <p><strong>${q.author}</strong>　${q.authorNote}</p>
      </div>
      <div class="read-note reveal" style="--d:.28s">
        <h4><i class="fa-regular fa-bookmark"></i>为什么收它</h4>
        <p>${q.reason}</p>
      </div>
    </div>
    <div class="read-nav reveal" style="--d:.34s">
      <a class="btn btn-ghost" href="read.html?id=${prev.id}"><i class="fa-solid fa-arrow-left"></i> ${prev.title}</a>
      <a class="btn btn-ghost" href="../poems.html"><i class="fa-solid fa-list"></i> 列表</a>
      <a class="btn btn-ghost" href="read.html?id=${next.id}">${next.title} <i class="fa-solid fa-arrow-right"></i></a>
    </div>`;
  observeReveals(box);
}

function observeReveals(root) {
  const io = new IntersectionObserver(entries => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.animationPlayState = 'running';
        io.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1 });
  (root || document).querySelectorAll('.reveal').forEach(el => io.observe(el));
}

renderQuoteFilters();
renderQuoteList('all');
renderRailToday();
renderRailAuthors();
renderFeatured();
renderQuoteDetail();