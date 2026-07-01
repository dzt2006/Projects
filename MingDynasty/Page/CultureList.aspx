<%@ Page Title="" Language="C#" MasterPageFile="~/Page/Site.master" AutoEventWireup="true" CodeFile="CultureList.aspx.cs" Inherits="Page_CultureList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="container py-5" id="culture-page">
        
        <!-- 1. 卷首标题区 -->
        <div class="scroll-header-wrapper mb-5">
            <div class="scroll-rod-top">
                <div class="rod-axis left"></div>
                <div class="rod-axis right"></div>
            </div>
            <div class="scroll-header-content">
                <div class="d-flex align-items-center justify-content-center gap-3 flex-wrap">
                    <div class="seal-xianzhang">
                        <svg viewBox="0 0 80 80" class="seal-svg" xmlns="http://www.w3.org/2000/svg">
                            <rect x="5" y="5" width="70" height="70" rx="2" fill="none" stroke="currentColor" stroke-width="2"/>
                            <text x="40" y="48" text-anchor="middle" font-family="LiSu, STKaiti" font-size="22" fill="currentColor">文苑</text>
                        </svg>
                    </div>
                    <div class="text-center">
                        <h2 class="scroll-title fw-bold mb-0">大明文化科技长卷</h2>
                        <p class="scroll-subtitle text-muted mt-2 mb-0">— 笔墨载道 格物致知 —</p>
                    </div>
                    <div class="seal-xianzhang">
                        <svg viewBox="0 0 80 80" class="seal-svg" xmlns="http://www.w3.org/2000/svg">
                            <rect x="5" y="5" width="70" height="70" rx="2" fill="none" stroke="currentColor" stroke-width="2"/>
                            <text x="40" y="48" text-anchor="middle" font-family="LiSu, STKaiti" font-size="22" fill="currentColor">天工</text>
                        </svg>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. 分类导航 -->
        <div class="category-wrapper mb-5">
            <div class="d-flex flex-wrap justify-content-center gap-3">
                <a href="CultureList.aspx" class="btn px-4 py-2 rounded-pill cat-btn <%= string.IsNullOrEmpty(Request.QueryString["cat"]) ? "active" : "" %>">
                    全卷
                </a>
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <a href='<%# "CultureList.aspx?cat=" + HttpUtility.UrlEncode(Container.DataItem.ToString()) %>' 
                           class="btn px-4 py-2 rounded-pill cat-btn <%# GetActiveClass(Container.DataItem) %>">
                            <%# Container.DataItem %>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <!-- 3. 核心内容：线装册页列表 -->
        <div class="row g-4" id="book-list">
            <asp:Repeater ID="rptCultures" runat="server">
                <ItemTemplate>
                    <div class="col-lg-4 col-md-6">
                        <div class="book-card animate-card" data-id='<%# Eval("ID") %>' 
                             data-title='<%# Eval("Title") %>' 
                             data-author='<%# Eval("Author") %>' 
                             data-category='<%# Eval("Category") %>' 
                             data-content='<%# Eval("Content") %>'>
                            <div class="book-binding">
                                <div class="binding-hole"></div>
                                <div class="binding-hole"></div>
                                <div class="binding-hole"></div>
                                <div class="binding-hole"></div>
                            </div>
                            <div class="book-cover">
                                <div class="cover-img-wrapper">
                                    <img src='<%# ResolveUrl(Eval("Cover").ToString()) %>' 
                                         class="cover-img" alt='<%# Eval("Title") %>' />
                                </div>
                                <div class="book-info">
                                    <span class="book-category"><%# Eval("Category") %></span>
                                    <h4 class="book-title"><%# Eval("Title") %></h4>
                                    <p class="book-author">
                                        著者：<%# Eval("Author") %>
                                    </p>
                                    <p class="book-desc"><%# GetSummary(Eval("Content")) %></p>
                                </div>
                                <div class="book-seal">
                                    <svg viewBox="0 0 60 60" class="seal-svg" xmlns="http://www.w3.org/2000/svg">
                                        <circle cx="30" cy="30" r="25" fill="none" stroke="currentColor" stroke-width="2"/>
                                        <text x="30" y="36" text-anchor="middle" font-family="LiSu" font-size="18" fill="currentColor">藏</text>
                                    </svg>
                                </div>
                            </div>
                            <div class="book-overlay-link"></div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div class="text-center py-5" id="empty-tip" style="display: none;">
            <p class="mt-3 text-muted" style="font-family: 'KaiTi'; font-size: 1.1rem;">暂无相关典籍，敬请期待</p>
        </div>

    </div>

    <!-- 古风卷轴弹窗 -->
    <div id="cultureModal" class="culture-modal-overlay">
        <div class="culture-modal-scroll">
            <div class="modal-body">
                <span id="modalCategory" class="book-category"></span>
                <h3 id="modalTitle" class="scroll-title text-center mb-3"></h3>
                <p id="modalAuthor" class="book-author text-center mb-4"></p>
                <div id="modalFullContent" class="book-full-content" style="font-family: 'KaiTi'; font-size: 1.1rem; line-height: 2; text-indent: 2em;"></div>
                <div class="text-center mt-4">
                    <button type="button" class="btn" style="background:var(--ming-red);color:#fff;" onclick="closeCultureModal()">关闭</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 页面脚本 -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const bookCards = document.querySelectorAll('.animate-card');
            const emptyTip = document.getElementById('empty-tip');

            if (bookCards.length === 0) {
                emptyTip.style.display = 'block';
            }

            bookCards.forEach((card, index) => {
                setTimeout(() => {
                    card.classList.add('animate-in');
                }, 100 + index * 120);
            });

            // 点击卡片打开弹窗
            document.querySelectorAll('.book-card').forEach(card => {
                card.querySelector('.book-overlay-link').addEventListener('click', function () {
                    card.classList.add('modal-open');

                    document.getElementById('modalTitle').innerText = card.dataset.title;
                    document.getElementById('modalAuthor').innerText = `著者：${card.dataset.author}`;
                    document.getElementById('modalCategory').innerText = card.dataset.category;
                    document.getElementById('modalFullContent').innerText = card.dataset.content || "暂无详细内容";
                    document.getElementById('cultureModal').style.display = 'flex';

                    // 修复页面偏移
                    const scrollBarWidth = window.innerWidth - document.documentElement.clientWidth;
                    document.body.style.paddingRight = scrollBarWidth + 'px';
                    document.body.style.overflow = 'hidden';
                });
            });
        });

        function closeCultureModal() {
            document.getElementById('cultureModal').style.display = 'none';
            document.body.style.paddingRight = '0px';
            document.body.style.overflow = 'auto';

            document.querySelectorAll('.book-card').forEach(card => {
                card.classList.remove('modal-open');
            });
        }

        document.getElementById('cultureModal').addEventListener('click', function (e) {
            if (e.target === this) {
                closeCultureModal();
            }
        });
    </script>

    <!-- 样式 -->
    <style>
        :root {
            --ming-red: #8E2323;
            --ming-gold: #B8860B;
            --paper-bg: #F7F3E8;
            --paper-white: #FCF9F2;
            --ink-black: #2C2C2C;
            --dark-wood: #3E2723;
            --light-wood: #8D6E63;
        }

        .cat-btn {
            padding: 8px 22px;
            border: 1px solid var(--dark-wood);
            color: var(--dark-wood);
            background: transparent;
            border-radius: 50px;
            font-family: 'KaiTi';
            font-size: 1.05rem;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .cat-btn:hover, .cat-btn.active {
            background-color: var(--dark-wood);
            color: #fff;
            border-color: var(--dark-wood);
            box-shadow: 0 4px 10px rgba(62, 39, 35, 0.2);
        }

        .scroll-header-wrapper {
            position: relative;
            max-width: 900px;
            margin: 0 auto;
        }

        .scroll-rod-top {
            width: 100%;
            height: 18px;
            background: linear-gradient(180deg, #3E2A18, #6D4C41, #3E2A18);
            border-radius: 8px 8px 2px 2px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            position: relative;
            z-index: 10;
        }

        .rod-axis {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 24px;
            background: radial-gradient(circle, #D7CCC8, #8D6E63);
            border-radius: 4px;
            box-shadow: inset 0 0 5px rgba(0,0,0,0.2);
        }
        .rod-axis.left { left: -10px; }
        .rod-axis.right { right: -10px; }

        .scroll-header-content {
            background: var(--paper-white);
            padding: 30px 20px;
            border-radius: 0 0 4px 4px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }

        .scroll-title {
            font-family: 'LiSu', 'STLiti', cursive;
            font-size: 2.6rem;
            color: var(--dark-wood);
            letter-spacing: 4px;
        }

        .scroll-subtitle {
            font-family: 'KaiTi', 'STKaiti', serif;
            font-size: 1.1rem;
        }

        .seal-xianzhang {
            color: var(--ming-red);
            opacity: 0.8;
        }
        .seal-svg {
            width: 60px;
            height: 60px;
        }

        .book-card {
            position: relative;
            background: var(--paper-white);
            border-radius: 0 6px 6px 0;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            overflow: hidden;
            height: 100%;
            display: flex;
            transition: all 0.4s cubic-bezier(0.22, 1, 0.36, 1);
        }

        .animate-card {
            opacity: 0;
            transform: translateY(30px);
            transition: none;
        }

        .animate-card.animate-in {
            animation: fadeUp 0.6s ease forwards;
        }

        @keyframes fadeUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .book-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 30px rgba(62, 39, 35, 0.15);
        }

        .book-card:hover::after {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 15px;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(0,0,0,0.06));
            pointer-events: none;
        }

        .book-binding {
            width: 18px;
            background: linear-gradient(90deg, var(--dark-wood), #5D4037);
            display: flex;
            flex-direction: column;
            justify-content: space-evenly;
            align-items: center;
            flex-shrink: 0;
        }

        .binding-hole {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #000;
            box-shadow: inset 0 0 2px rgba(255,255,255,0.2);
        }

        .book-cover {
            flex-grow: 1;
            padding: 25px 20px;
            position: relative;
            display: flex;
            flex-direction: column;
        }

        .cover-img-wrapper {
            width: 100%;
            height: 160px;
            border-radius: 4px;
            overflow: hidden;
            border: 2px solid var(--light-wood);
            margin-bottom: 15px;
            background: var(--paper-bg);
        }

        .cover-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .book-card:hover .cover-img {
            transform: scale(1.05);
        }

        .book-category {
            display: inline-block;
            font-size: 0.8rem;
            color: #fff;
            background: var(--ming-red);
            padding: 2px 8px;
            border-radius: 2px;
            font-family: 'KaiTi';
            margin-bottom: 8px;
        }

        .book-title {
            font-family: 'LiSu', 'STKaiti', serif;
            font-size: 1.5rem;
            color: var(--ink-black);
            margin-bottom: 8px;
            letter-spacing: 1px;
            transition: color 0.3s ease;
        }

        .book-card:hover .book-title {
            color: var(--ming-red);
        }

        .book-author {
            font-family: 'KaiTi';
            font-size: 0.95rem;
            color: var(--dark-wood);
            margin-bottom: 10px;
        }

        .book-desc {
            font-size: 0.9rem;
            color: #666;
            line-height: 1.6;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            margin-bottom: 0;
            flex-grow: 1;
        }

        .book-seal {
            position: absolute;
            bottom: 15px;
            right: 15px;
            color: var(--ming-red);
            opacity: 0.2;
            transition: all 0.4s ease;
            transform: rotate(-15deg);
        }

        .book-card:hover .book-seal {
            opacity: 0.7;
            transform: rotate(-10deg) scale(1.1);
        }

        .book-card.modal-open .book-seal,
        .book-card.modal-open:hover .book-seal {
            opacity: 0.2 !important;
            transform: rotate(-15deg) !important;
        }

        .book-overlay-link {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 10;
            cursor: pointer;
        }

        .culture-modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0,0,0,0.7);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .culture-modal-scroll {
            position: relative;
            max-width: 700px;
            width: 100%;
            background: var(--paper-white);
            border-radius: 8px;
            padding: 40px 30px;
            border: 12px solid var(--dark-wood);
            box-shadow: 0 10px 50px rgba(0,0,0,0.3);
            animation: modalOpen 0.5s ease;
        }

        @keyframes modalOpen {
            from { opacity: 0; transform: translateY(-50px) scale(0.9); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .modal-body {
            font-family: 'KaiTi', serif;
            overflow: visible; 
        }

        @media (max-width: 768px) {
            .scroll-title {
                font-size: 1.8rem;
                letter-spacing: 2px;
            }
            .seal-svg {
                width: 40px;
                height: 40px;
            }
            .culture-modal-scroll {
                border-width: 8px;
                padding: 30px 20px;
            }
        }
    </style>

</asp:Content>