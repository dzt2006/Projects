# 拾光 · 云边小卖部（dztfun.cyou）

邓泽廷的个人小站：一家开在云边的小卖部，慢慢记，慢慢活。

- 线上地址：https://dztfun.cyou
- 类型：手写静态博客，无框架、无构建

## 页面

| 页面 | 说明 |
| --- | --- |
| `index.html` | 首页：门面、云边货架、四个角落、近来、今日撷句 |
| `daily.html` | 日常 · 拾光 |
| `logs.html` | 日志 · 札记 |
| `poems.html` | 撷句 · 拾遗：诗词/语录/文段，支持分类筛选、随机拈句、详情页 |
| `about.html` | 关于：个人档案、四时笺（春夏秋冬）、心愿单、实时时钟 |
| `quotes/read.html` | 撷句详情页（诗词竖排 / 文段横排） |

## 技术栈

- 纯手写 HTML + CSS + 原生 JS，零依赖、零构建
- 液态玻璃视觉：半透明渐变叠层（逐卡不用 backdrop-filter），滚动 60fps
- 字体自托管：霞鹜文楷（LXGW WenKai）、马善政（毛笔字）、Font Awesome
- 响应式：桌面三列 / 移动单列，无横向溢出；`scrollbar-gutter` 避免筛选时抖动

## 目录结构

```
dztfun/
├── index.html / daily.html / logs.html / poems.html / about.html
├── quotes/read.html
└── assets/
    ├── style.css      全站样式
    ├── main.js        入场动画、导航、滚动观察
    ├── quotes.js      撷句数据（QUOTES 数组，列表/详情/随机/今日撷句都从这生成）
    ├── days.js        首页货架、黄历、季节、心愿单
    ├── fonts/         自托管字体（霞鹜文楷、马善政）
    ├── fontawesome/   Font Awesome 图标
    └── avatar.jpg / clouds.jpg / favicon.svg
```

## 内容维护

内容目前是占位示例。加新内容只需改数据，不动逻辑：

- **撷句**：往 `assets/quotes.js` 的 `QUOTES` 数组加一条，字段：`type`（poem/quote/prose）、`title`、`excerpt`、`lines`、`source`、`author`、`authorNote`、`reason`。
- **日常 / 日志**：改 `daily.html` / `logs.html` 正文，并在 `assets/days.js` 的 `ENTRIES` 加一条（date/kind/title/href）。

## 部署

服务器 nginx + Ubuntu，站点目录 `/var/www/dztfun`（root 属主 www-data）：

```bash
scp -r dztfun/* root@<服务器>:/var/www/dztfun/
ssh root@<服务器> 'chown -R www-data:www-data /var/www/dztfun && chmod -R u+rwX,go+rX /var/www/dztfun'
```
