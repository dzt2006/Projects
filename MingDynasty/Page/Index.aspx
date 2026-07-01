<%@ Page Title="" Language="C#" MasterPageFile="~/Page/Site.master" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Page_Index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <!-- 大明古风首页轮播Banner -->
    <div id="mingCarousel" class="carousel slide mb-5 shadow-lg" data-bs-ride="carousel" style="border-bottom: 4px solid var(--ming-gold);">
        <!-- 轮播指示器小圆点 -->
        <div class="carousel-indicators">
            <asp:Repeater ID="rptBannerIndicators" runat="server">
                <ItemTemplate>
                    <button type="button" data-bs-target="#mingCarousel"
                        data-bs-slide-to="<%# Container.ItemIndex %>"
                        class="<%# Container.ItemIndex == 0 ? "active" : "" %>"
                        aria-current="<%# Container.ItemIndex == 0 ? "true" : "false" %>">
                    </button>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <!-- 轮播图片内容区 -->
        <div class="carousel-inner" style="max-height: 500px; overflow: hidden;">
            <asp:Repeater ID="rptBanners" runat="server">
                <ItemTemplate>
                    <div class="carousel-item <%# Container.ItemIndex == 0 ? "active" : "" %>">
                        <!-- 绑定轮播图片路径 -->
                        <div class="d-block w-100 banner-placeholder"
                            style='height: 500px; background: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.3)), url("<%# ResolveUrl(Eval("ImageUrl").ToString()) %>"); background-size: cover; background-position: center;'>
                            <div class="container h-100 d-flex align-items-center justify-content-start">
                                <div class="text-white" style="text-shadow: 2px 2px 4px #000;">
                                    <!-- 绑定轮播标题 -->
                                    <h1 class="display-3 fw-bold banner-title" style="font-family: 'LiSu', cursive; color: var(--ming-gold);">
                                        <%# Eval("Title") %>
                                    </h1>
                                    <p class="lead mb-4">探索大明王朝276年的兴衰荣辱</p>
                                    <!-- 跳转：轮播图绑定跳转链接 -->
                                    <a href='<%# ResolveUrl(Eval("LinkUrl").ToString()) %>' class="btn btn-danger btn-lg" style="background-color: var(--ming-red); border-color: var(--ming-gold);">立即探索 <i class="ri-arrow-right-line"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <!-- 轮播左右切换按钮 -->
        <button class="carousel-control-prev" type="button" data-bs-target="#mingCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#mingCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>
    </div>

    <div class="container">

        <!-- 核心功能快捷入口卡片 -->
        <div class="row g-4 mb-5">
            <!-- 大明帝王入口 -->
            <div class="col-md-3 col-6">
                <!-- 跳转：帝王列表页 -->
                <a href="<%= ResolveUrl("~/Page/EmperorList.aspx") %>" class="text-decoration-none">
                    <div class="card paper-card h-100 text-center hover-lift anim-item">
                        <div class="card-body py-4">
                            <div class="mb-3 text-danger" style="font-size: 3rem;">
                                <i class="ri-vip-crown-line"></i>
                            </div>
                            <h5 class="card-title" style="color: var(--dark-wood);">大明帝王</h5>
                            <p class="card-text text-muted small">十六帝风云录</p>
                        </div>
                    </div>
                </a>
            </div>

            <!-- 历史大事件入口 -->
            <div class="col-md-3 col-6">
                <!-- 跳转：历史事件时间线页 -->
                <a href="<%= ResolveUrl("~/Page/EventTimeline.aspx") %>" class="text-decoration-none">
                    <div class="card paper-card h-100 text-center hover-lift anim-item">
                        <div class="card-body py-4">
                            <div class="mb-3 text-primary" style="font-size: 3rem;">
                                <i class="ri-file-history-line"></i>
                            </div>
                            <h5 class="card-title" style="color: var(--dark-wood);">历史大事件</h5>
                            <p class="card-text text-muted small">时间轴上的兴衰</p>
                        </div>
                    </div>
                </a>
            </div>

            <!-- 典章制度入口 -->
            <div class="col-md-3 col-6">
                <!-- 跳转：典章制度列表页 -->
                <a href="<%= ResolveUrl("~/Page/SystemList.aspx") %>" class="text-decoration-none">
                    <div class="card paper-card h-100 text-center hover-lift anim-item">
                        <div class="card-body py-4">
                            <div class="mb-3 text-success" style="font-size: 3rem;">
                                <i class="ri-government-line"></i>
                            </div>
                            <h5 class="card-title" style="color: var(--dark-wood);">典章制度</h5>
                            <p class="card-text text-muted small">国家运作基石</p>
                        </div>
                    </div>
                </a>
            </div>

            <!-- 名臣名将入口 -->
            <div class="col-md-3 col-6">
                <!-- 跳转：名臣名将列表页 -->
                <a href="<%= ResolveUrl("~/Page/FigureList.aspx") %>" class="text-decoration-none">
                    <div class="card paper-card h-100 text-center hover-lift anim-item">
                        <div class="card-body py-4">
                            <div class="mb-3 text-warning" style="font-size: 3rem;">
                                <i class="ri-user-5-line"></i>
                            </div>
                            <h5 class="card-title" style="color: var(--dark-wood);">名臣名将</h5>
                            <p class="card-text text-muted small">璀璨人物群星</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>

        <!-- 最新更新+热门推荐内容区 -->
        <div class="row">
            <!-- 左侧最新科普文章 -->
            <div class="col-lg-8 mb-4">
                <div class="d-flex align-items-center mb-3 border-bottom pb-2" style="border-color: var(--ming-red) !important;">
                    <h4 class="me-2 mb-0" style="color: var(--ming-red);"><i class="ri-newspaper-line"></i>最新更新</h4>
                    <span class="text-muted small">The Latest</span>
                </div>

                <div class="row g-3">
                    <asp:Repeater ID="rptLatestArticles" runat="server">
                        <ItemTemplate>
                            <div class="col-12 anim-item">
                                <div class="card paper-card flex-row hover-lift">
                                    <div style="width: 120px; min-height: 100px; background: #eee; display: flex; align-items: center; justify-content: center; color: #ccc;">
                                        <i class="ri-file-text-line" style="font-size: 2rem;"></i>
                                    </div>
                                    <div class="card-body d-flex flex-column justify-content-between py-2">
                                        <div>
                                            <!-- 跳转：制度/文章详情页，带ID参数 -->
                                            <h6 class="card-title mb-1">
                                                <a href='<%# ResolveUrl($"~/Page/SystemDetail.aspx?id={Eval("ID")}") %>' class="text-decoration-none" style="color: var(--ink-black);">
                                                    <%# Eval("Title") %>
                                                </a>
                                            </h6>
                                            <span class="badge bg-secondary mb-2"><%# Eval("Category") %></span>
                                        </div>
                                        <!-- 绑定创建时间 -->
                                        <small class="text-muted"><i class="ri-time-line"></i><%# Eval("CreateTime", "{0:yyyy-MM-dd}") %></small>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- 右侧热门帝王+留言板 -->
            <div class="col-lg-4 mb-4">
                <div class="d-flex align-items-center mb-3 border-bottom pb-2" style="border-color: var(--ming-gold) !important;">
                    <h4 class="me-2 mb-0" style="color: var(--dark-wood);"><i class="ri-fire-line" style="color: var(--ming-red);"></i>热门帝王</h4>
                </div>

                <div class="card paper-card">
                    <div class="list-group list-group-flush">
                        <asp:Repeater ID="rptHotEmperors" runat="server">
                            <ItemTemplate>
                                <!-- 跳转：帝王详情页，带ID参数 -->
                                <a href='<%# ResolveUrl($"~/Page/EmperorDetail.aspx?id={Eval("ID")}") %>' class="list-group-item list-group-item-action d-flex align-items-center anim-item" style="background: transparent; border-left: 3px solid transparent;">
                                    <div class="flex-shrink-0">
                                        <div class="rounded-circle bg-light d-flex align-items-center justify-content-center" style="width: 40px; height: 40px; border: 1px solid #ddd; color: var(--ming-red);">
                                            <i class="ri-user-3-line"></i>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <!-- 绑定帝王庙号、年号、在位时间 -->
                                        <h6 class="mb-0"><%# Eval("TempleName") %></h6>
                                        <small class="text-muted"><%# Eval("ReignTitle") %> · <%# Eval("ReignYears") %></small>
                                    </div>
                                    <div class="flex-shrink-0">
                                        <i class="ri-arrow-right-s-line text-muted"></i>
                                    </div>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- 访古留言引导卡片 -->
                <div class="card mt-4 border-0 anim-item" style="background: linear-gradient(135deg, #f5f0e6, #fff); border: 1px solid var(--ming-gold);">
                    <div class="card-body text-center">
                        <i class="ri-quill-pen-line" style="font-size: 2rem; color: var(--ming-red);"></i>
                        <h6 class="mt-2" style="color: var(--dark-wood);">访古留言</h6>
                        <p class="small text-muted mb-2">评说千古风云，留下您的独到见解。</p>
                        <!-- 跳转：留言板页面 -->
                        <a href="<%= ResolveUrl("~/Page/MessageBoard.aspx") %>" class="btn btn-sm" style="background-color: var(--ming-red); color: white;">前往留言</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 首页专属页脚 -->
    <footer class="site-footer mt-5">
        <div class="container">
            <div class="footer-seal">明史博览</div>
            <p class="mb-0" style="font-family: 'SimSun', serif;">
                Copyright © 2025 大明纪事历史. All Rights Reserved.
            </p>
        </div>
    </footer>

    <!-- 首页动画样式 -->
    <style>
        /* 悬浮上移效果 */
        .hover-lift {
            transition: transform .3s ease-in-out, box-shadow .3s ease-in-out;
        }
        .hover-lift:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.12);
            border-color: var(--ming-gold);
        }
        /* 图标旋转放大 */
        .hover-lift i {
            transition: transform 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .hover-lift:hover i {
            transform: scale(1.25) rotate(5deg);
        }
        /* 轮播标题呼吸发光 */
        .banner-title {
            animation: titleGlow 2.5s infinite alternate ease-in-out;
        }
        @keyframes titleGlow {
            0% {
                text-shadow: 2px 2px 4px #000, 0 0 10px rgba(212,175,55,0.3);
            }
            100% {
                text-shadow: 2px 2px 4px #000, 0 0 25px rgba(212,175,55,0.8);
            }
        }
        /* 元素入场动画初始状态 */
        .anim-item {
            opacity: 0;
            transform: translateY(30px);
            transition: all 0.7s cubic-bezier(0.22, 1, 0.36, 1);
        }
        .anim-item.show {
            opacity: 1;
            transform: translateY(0);
        }
        /* 热门帝王列表悬浮效果 */
        .list-group-item-action {
            transition: all 0.3s ease !important;
        }
        .list-group-item-action:hover {
            background-color: #fffbf5 !important;
            border-left-color: var(--ming-red) !important;
            padding-left: 18px !important;
        }
        /* 移动端适配 */
        @media (max-width: 768px) {
            .banner-placeholder h1 {
                font-size: 2rem !important;
            }
        }
    </style>

    <!-- 元素顺序入场执行脚本 -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const items = document.querySelectorAll('.anim-item');
            items.forEach((item, index) => {
                setTimeout(() => {
                    item.classList.add('show');
                }, 200 + index * 120);
            });
        });
    </script>

</asp:Content>