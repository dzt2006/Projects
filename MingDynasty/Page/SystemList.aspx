<%@ Page Title="" Language="C#" MasterPageFile="~/Page/Site.master" AutoEventWireup="true" CodeFile="SystemList.aspx.cs" Inherits="Page_SystemList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="container py-5">
        
        <!-- 1. 顶部：古风标题区 -->
        <div class="text-center mb-5 position-relative">

            <h2 class="fw-bold mb-2" style="font-family: 'LiSu'; font-size: 2.5rem; color: var(--dark-wood);">
                大明会典
            </h2>
            <p class="text-muted" style="font-family: 'KaiTi';">— 垂范后世，昭昭如日月 —</p>
            
            <!-- 装饰线 -->
            <div class="mx-auto mt-4" style="width: 100px; height: 3px; background: linear-gradient(90deg, transparent, var(--ming-red), transparent);"></div>
        </div>

        <!-- 2. 分类导航：云纹标签 -->
        <div class="d-flex flex-wrap justify-content-center gap-3 mb-5">
            <!-- 全部按钮 -->
            <a href="SystemList.aspx" class="btn px-4 py-2 rounded-pill cat-btn <%= string.IsNullOrEmpty(Request.QueryString["cat"]) ? "active" : "" %>">
                全部典籍
            </a>
            <!-- 动态分类 -->
            <asp:Repeater ID="rptCategories" runat="server">
                <ItemTemplate>
                    <a href='SystemList.aspx?cat=<%# Container.DataItem %>' 
                       class="btn px-4 py-2 rounded-pill cat-btn <%# Request.QueryString["cat"] == Container.DataItem.ToString() ? "active" : "" %>">
                        <%# Container.DataItem %>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- 3. 文章列表：奏折卡片 -->
        <div class="row g-4">
            <asp:Repeater ID="rptArticles" runat="server">
                <ItemTemplate>
                    <div class="col-lg-4 col-md-6">
                        <div class="memorial-card h-100">
                            <!-- 卡片头部：印章/置顶 -->
                            <div class="memorial-header">
                                <span class="memorial-cat"><%# Eval("Category") %></span>
                                <asp:PlaceHolder runat="server" Visible='<%# Convert.ToBoolean(Eval("IsTop")) %>'>
                                    <span class="stamp-badge">敕</span>
                                </asp:PlaceHolder>
                            </div>

                            <!-- 卡片内容 -->
                            <div class="memorial-body">
                                <h5 class="memorial-title" style="font-family: 'KaiTi';">
                                    <%# Eval("Title") %>
                                </h5>
                                <p class="memorial-desc">
                                    <%# GetSummary(Eval("Content")) %>
                                </p>
                            </div>

                            <!-- 卡片底部 -->
                            <div class="memorial-footer">
                                <span class="text-muted small">
                                    <%# Eval("CreateTime", "{0:yyyy年MM月}") %>
                                </span>
                                <a href='SystemDetail.aspx?id=<%# Eval("ID") %>' class="read-more">
                                    展卷
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

    </div>

    <!-- ========== 【核心修复】强制预留滚动条位置，彻底解决偏移 ========== -->
    <style>
        html {
            overflow-y: scroll;
        }
    </style>
    <!-- ================================================================ -->

    <!-- 奏折专属动画样式 -->
    <style>
        :root {
            --ming-red: #C41E3A;
            --ming-gold: #D4AF37;
            --dark-wood: #5D4037;
        }

        /* 分类按钮 */
        .cat-btn {
            border: 1px solid var(--dark-wood);
            color: var(--dark-wood);
            background: transparent;
            transition: all 0.3s;
            font-family: 'KaiTi';
        }
        .cat-btn:hover, .cat-btn.active {
            background-color: var(--dark-wood);
            color: #fff;
            border-color: var(--dark-wood);
            box-shadow: 0 4px 10px rgba(93, 64, 55, 0.3);
        }

        /* 奏折卡片 - 入场初始状态 */
        .memorial-card {
            background: #fff;
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 100%;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            background-image: linear-gradient(to bottom, rgba(245,240,230,0.5) 1px, transparent 1px);
            background-size: 100% 25px;
            
            opacity: 0;
            transform: translateX(60px) rotate(12deg) scale(0.92);
            transition: all 0.6s cubic-bezier(0.22, 1, 0.36, 1);
        }

        /* 入场动画执行 */
        .memorial-card.show-in {
            opacity: 1;
            transform: translateX(0) rotate(0deg) scale(1);
        }

        /* 悬停：奏折拿起效果 */
        .memorial-card:hover {
            transform: translateY(-10px) rotate(-2deg);
            box-shadow: 0 22px 40px rgba(93, 64, 55, 0.2);
            border-color: var(--ming-gold);
        }

        /* 左侧书脊 */
        .memorial-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 8px;
            background: linear-gradient(180deg, var(--ming-red), #8B0000);
            transition: all 0.4s ease;
        }
        .memorial-card:hover::before {
            box-shadow: 4px 0 12px rgba(196, 30, 58, 0.4);
        }

        .memorial-header {
            padding: 15px 20px 10px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .memorial-cat {
            font-size: 0.85rem;
            color: #666;
            background: #f0f0f0;
            padding: 2px 8px;
            border-radius: 4px;
            transition: all 0.3s;
        }
        .memorial-card:hover .memorial-cat {
            background: var(--ming-gold);
            color: #fff;
        }

        /* 印章动画 */
        .stamp-badge {
            display: inline-block;
            width: 35px;
            height: 35px;
            line-height: 35px;
            text-align: center;
            background: #C41E3A;
            color: #FFE4B5;
            font-family: 'LiSu';
            font-size: 1.2rem;
            border-radius: 50%;
            transform: rotate(-15deg);
            box-shadow: 0 2px 4px rgba(196, 30, 58, 0.3);
            border: 2px solid #8B0000;
            transition: all 0.4s ease;
        }
        .memorial-card:hover .stamp-badge {
            transform: rotate(0deg) scale(1.1);
            box-shadow: 0 4px 10px rgba(196, 30, 58, 0.4);
        }

        .memorial-body {
            padding: 10px 20px 20px 30px;
            flex-grow: 1;
        }

        .memorial-title {
            font-size: 1.3rem;
            color: var(--dark-wood);
            margin-bottom: 10px;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        .memorial-card:hover .memorial-title {
            color: var(--ming-red);
            transform: translateX(4px);
        }

        .memorial-desc {
            color: #666;
            font-size: 0.95rem;
            line-height: 1.6;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .memorial-footer {
            padding: 15px 20px 20px 30px;
            border-top: 1px dashed #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .read-more {
            color: var(--ming-red);
            text-decoration: none;
            font-weight: bold;
            font-family: 'KaiTi';
            transition: all 0.3s;
        }
        .read-more:hover {
            color: #8B0000;
            letter-spacing: 1px;
        }
    </style>

    <!-- 卡片错落入场脚本 -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const cards = document.querySelectorAll('.memorial-card');
            cards.forEach((card, i) => {
                setTimeout(() => card.classList.add('show-in'), i * 130);
            });
        });
    </script>

</asp:Content>