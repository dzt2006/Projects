<%@ Page Title="" Language="C#" MasterPageFile="~/Page/Site.master" AutoEventWireup="true" CodeFile="SystemDetail.aspx.cs" Inherits="Page_SystemDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="container py-5">
        
        <!-- 1. 古风面包屑 -->
        <div class="ancient-breadcrumb mb-5" id="breadcrumb">
            <a href="Index.aspx">首页</a>
            <span class="separator">/</span>
            <a href="SystemList.aspx">典章制度</a>
            <span class="separator">/</span>
            <span class="current"><%= ArticleCategory %></span>
        </div>

        <!-- 2. 卷轴核心结构 -->
        <div class="scroll-wrapper" id="scrollWrapper">
            <!-- 固定上轴 -->
            <div class="scroll-rod top"></div>
            <!-- 左右侧边轴 -->
            <div class="scroll-rod left"></div>
            <div class="scroll-rod right"></div>

            <!-- 宣纸内容区 -->
            <div class="scroll-paper" id="scrollPaper">
                <!-- 卷轴头部标题 -->
                <div class="scroll-header" id="scrollHeader">
                    <span class="scroll-cat-badge"><%= ArticleCategory %></span>
                    <h1 class="scroll-title"><%= ArticleTitle %></h1>
                    <div class="scroll-meta">
                        编撰日期：<%= ArticleTime %>
                    </div>
                </div>

                <!-- 典籍正文内容 -->
                <div class="article-content" id="articleContent">
                    <%= ArticleContent %>
                </div>
            </div>

            <!-- 滚动下轴 -->
            <div class="scroll-rod bottom" id="scrollBottomRod"></div>
        </div>

        <!-- 3. 返回按钮 -->
        <div class="text-center mt-5" id="backBtn">
            <a href="SystemList.aspx" class="back-btn">
                返回典籍列表
            </a>
        </div>

    </div>

    <!-- 核心脚本 -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const scrollWrapper = document.getElementById('scrollWrapper');
            const scrollPaper = document.getElementById('scrollPaper');
            const scrollHeader = document.getElementById('scrollHeader');
            const articleContent = document.getElementById('articleContent');
            const breadcrumb = document.getElementById('breadcrumb');
            const backBtn = document.getElementById('backBtn');

            // 计算内容真实高度与动画总时长
            const contentFullHeight = scrollPaper.scrollHeight + 36;
            const animationDuration = Math.max(3, contentFullHeight / 100 * 0.3);

            // 注入CSS全局变量
            document.documentElement.style.setProperty('--scroll-full-height', `${contentFullHeight}px`);
            document.documentElement.style.setProperty('--scroll-duration', `${animationDuration}s`);

            // 处理标题区
            const headerChildren = scrollHeader.children;
            for (let i = 0; i < headerChildren.length; i++) {
                headerChildren[i].classList.add('typewriter-print');
                headerChildren[i].style.animationDelay = `${i * 0.2}s`;
            }

            // 处理正文内容
            if (articleContent) {
                const contentItems = articleContent.children;
                for (let i = 0; i < contentItems.length; i++) {
                    const item = contentItems[i];
                    item.classList.add('typewriter-print');
                    const itemOffsetTop = item.offsetTop;
                    const delayTime = (itemOffsetTop / contentFullHeight) * animationDuration;
                    item.style.animationDelay = `${delayTime}s`;
                }
            }

            // 启动卷轴核心动画
            setTimeout(() => {
                scrollWrapper.classList.add('scroll-unfold-start');
            }, 100);

            // 动画结束后显示辅助元素
            scrollWrapper.addEventListener('animationend', function (e) {
                if (e.animationName === 'scrollUnfold') {
                    breadcrumb.classList.add('fade-in-show');
                    backBtn.classList.add('fade-in-show');
                }
            });
        });
    </script>

    <!-- 核心样式 -->
    <style>
        /* ========== 【核心修复】强制预留滚动条位置，彻底解决偏移 ========== */
        html {
            overflow-y: scroll;
        }
        /* ================================================================ */

        :root {
            --ming-red: #C41E3A;
            --ming-gold: #D4AF37;
            --paper-bg: #F5F0E6;
            --ink-black: #2C2C2C;
            --dark-wood: #5D4037;
            --scroll-full-height: 0px;
            --scroll-duration: 3s;
        }

        /* --- 基础元素样式 --- */
        .ancient-breadcrumb {
            font-family: "KaiTi", "STKaiti", serif;
            font-size: 1.1rem;
            color: var(--dark-wood);
            opacity: 0;
            transform: translateY(-10px);
            transition: all 0.8s ease 0.3s;
        }
        .ancient-breadcrumb a { color: var(--dark-wood); text-decoration: none; transition: color 0.3s; }
        .ancient-breadcrumb a:hover { color: var(--ming-red); text-decoration: underline; }
        .ancient-breadcrumb .separator { margin: 0 8px; color: #888; }
        .ancient-breadcrumb .current { color: var(--ming-red); font-weight: 500; }
        .ancient-breadcrumb.fade-in-show, #backBtn.fade-in-show {
            opacity: 1;
            transform: translateY(0);
        }

        /* --- 卷轴容器核心样式 --- */
        .scroll-wrapper {
            position: relative;
            max-width: 900px;
            margin: 0 auto;
            width: 100%;
            height: 18px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            border-radius: 4px;
        }

        .scroll-wrapper.scroll-unfold-start {
            animation: scrollUnfold var(--scroll-duration) linear forwards;
        }

        @keyframes scrollUnfold {
            0% { height: 18px; }
            100% { height: var(--scroll-full-height); }
        }

        /* --- 卷轴轴装饰 --- */
        .scroll-rod {
            position: absolute;
            background: linear-gradient(90deg, #3E2A18, #6D4C41, #3E2A18);
            box-shadow: 0 2px 10px rgba(0,0,0,0.4);
            z-index: 20;
            border-radius: 6px;
        }
        .scroll-rod.top {
            width: 100%;
            height: 18px;
            top: 0;
            left: 0;
            background: linear-gradient(180deg, #3E2A18, #6D4C41, #3E2A18);
        }
        .scroll-rod.left, .scroll-rod.right {
            width: 18px;
            height: 100%;
            top: 0;
        }
        .scroll-rod.left { left: -9px; }
        .scroll-rod.right { right: -9px; }
        .scroll-rod.bottom {
            width: 100%;
            height: 18px;
            bottom: 0;
            left: 0;
            background: linear-gradient(180deg, #3E2A18, #6D4C41, #3E2A18);
        }

        /* --- 宣纸内容区 --- */
        .scroll-paper {
            width: 100%;
            padding: 40px 60px;
            padding-top: 58px;
            padding-bottom: 30px;
            background-color: #fff;
            background-image: linear-gradient(to bottom, rgba(245,240,230,0.4) 1px, transparent 1px);
            background-size: 100% 32px;
            box-sizing: border-box;
        }

        .scroll-header {
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 1px dashed #ccc;
            margin-bottom: 30px;
        }
        .scroll-cat-badge {
            display: inline-block;
            padding: 4px 16px;
            background-color: var(--ming-red);
            color: #fff;
            font-size: 0.9rem;
            border-radius: 20px;
            margin-bottom: 20px;
            font-family: "KaiTi", serif;
        }
        .scroll-title {
            font-family: 'LiSu', 'STLiti', cursive;
            font-size: 2.2rem;
            color: var(--dark-wood);
            margin-bottom: 15px;
            letter-spacing: 2px;
        }
        .scroll-meta {
            color: #777;
            font-family: 'KaiTi';
            font-size: 1rem;
            display: inline-block;
            padding: 8px 30px;
        }

        .article-content {
            font-family: "KaiTi", "STKaiti", "SimSun", sans-serif;
            font-size: 1.2rem;
            line-height: 2;
            color: #333;
        }

        /* --- 打字机同步打印动画 --- */
        .typewriter-print {
            opacity: 0;
            transform: translateY(8px);
            animation: typewriter 0.8s cubic-bezier(0.22, 1, 0.36, 1) forwards;
        }

        @keyframes typewriter {
            0% {
                opacity: 0;
                transform: translateY(8px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 内容样式兼容 */
        .article-content img { 
            max-width: 100%; 
            height: auto; 
            display: block; 
            margin: 25px auto; 
            border: 3px solid var(--ming-gold); 
            padding: 5px; 
            background: #fff; 
        }
        .article-content h1, 
        .article-content h2, 
        .article-content h3 { 
            font-family: "LiSu", "STLiti", cursive; 
            color: var(--ming-red); 
            text-align: center; 
            margin-top: 30px; 
            margin-bottom: 20px; 
        }
        .article-content p { 
            text-indent: 2em; 
            margin-bottom: 15px; 
            text-align: justify; 
        }

        /* --- 返回按钮样式 --- */
        #backBtn {
            opacity: 0;
            transform: translateY(20px);
            transition: all 0.8s ease 0.5s;
        }
        .back-btn {
            display: inline-block;
            padding: 12px 40px;
            background-color: var(--dark-wood);
            color: #fff;
            text-decoration: none;
            border-radius: 50px;
            font-family: "KaiTi", serif;
            font-size: 1.1rem;
            transition: all 0.3s;
        }
        .back-btn:hover { 
            background-color: var(--ming-red); 
            color: #fff; 
            transform: translateY(-3px); 
            box-shadow: 0 5px 15px rgba(196, 30, 58, 0.2); 
        }
    </style>

</asp:Content>