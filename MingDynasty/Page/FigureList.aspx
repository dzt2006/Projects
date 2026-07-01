<%@ Page Title="" Language="C#" MasterPageFile="~/Page/Site.master" AutoEventWireup="true" CodeFile="FigureList.aspx.cs" Inherits="Page_FigureList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <!-- Vue 挂载容器 -->
    <div class="container py-5" id="vue-app">
        
        <!-- 1. 顶部：国风标题区（统一配色） -->
        <div class="text-center mb-5 position-relative">

            <h2 class="fw-bold mb-2" style="font-family: 'LiSu'; font-size: 2.5rem; color: var(--dark-wood);">
                大明风云人物
            </h2>
            <p class="text-muted" style="font-family: 'KaiTi'; font-size: 1.1rem;">— 文臣武将，千古流芳 —</p>
            <div class="mx-auto mt-4" style="width: 100px; height: 3px; background: linear-gradient(90deg, transparent, var(--ming-red), transparent);"></div>
        </div>

        <!-- 2. 搜索/筛选栏（和帝王页一致的模糊查询） -->
        <div class="row mb-5">
            <div class="col-md-6 offset-md-3">
                <div class="input-group paper-card">
                    <span class="input-group-text bg-light"><i class="ri-search-line"></i></span>
                    <input type="text" class="form-control" v-model="searchQuery" placeholder="搜索人物姓名、身份...">
                </div>
            </div>
        </div>

        <!-- 3. 分类导航（统一配色风格） -->
        <div class="d-flex flex-wrap justify-content-center gap-3 mb-5">
            <!-- 全部按钮 -->
            <a href="FigureList.aspx" class="btn px-4 py-2 rounded-pill cat-btn" :class="{active: !currentCat}">
                <i class="ri-user-line"></i> 全部人物
            </a>
            <!-- 动态分类 -->
            <asp:Repeater ID="rptCategories" runat="server">
                <ItemTemplate>
                    <a href='FigureList.aspx?cat=<%# Container.DataItem %>' 
                       class="btn px-4 py-2 rounded-pill cat-btn" 
                       :class="{active: currentCat === '<%# Container.DataItem %>'}">
                        <i class="ri-user-line"></i> <%# Container.DataItem %>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- 4. 核心：人物卡片列表（Vue渲染） -->
        <div class="row g-4">
            <!-- 人物卡片 -->
            <div class="col-lg-3 col-md-4 col-sm-6" v-for="(item, index) in filteredFigures" :key="item.ID">
                <div class="card paper-card h-100 text-center animate-card">
                    <!-- 人物头像区 -->
                    <div class="pt-3 px-3">
                        <div class="avatar-wrapper mx-auto">
                            <div class="avatar-frame">
                                <img v-if="item.Avatar" :src="item.Avatar" style="width: 100%; height: 100%; object-fit: cover;" />
                                <i v-else class="ri-user-3-line" style="font-size: 3rem; color: var(--dark-wood);"></i>
                            </div>
                        </div>
                    </div>

                    <!-- 人物信息区 -->
                    <div class="card-body">
                        <h5 class="card-title mb-1" style="font-family: 'LiSu'; color: var(--ming-red);">{{ item.Name }}</h5>
                        <span class="badge mb-2" style="background-color: var(--dark-wood); color: #fff;">{{ item.Category }}</span>
                        <p class="card-text mb-1" style="font-family: 'KaiTi'; color: var(--dark-wood);">{{ item.IdentityTitle }}</p>
                        <p class="card-text text-muted small">{{ item.BirthYear }} - {{ item.DeathYear }}</p>
                        <p class="card-text small text-truncate" style="color: #666; max-width: 100%;">{{ item.Achievement }}</p>
                    </div>

                    <!-- 底部：查看详情 -->
                    <div class="card-footer bg-transparent border-0 pb-3">
                        <span class="view-detail-btn" @click="openFigureDetail(item)">
                            查看详情 <i class="ri-arrow-right-s-line"></i>
                        </span>
                    </div>
                </div>
            </div>

            <!-- 无数据提示 -->
            <div v-if="filteredFigures.length === 0" class="text-center py-5 text-muted w-100">
                <i class="ri-emotion-sad-line" style="font-size: 3rem;"></i>
                <p class="mt-2" style="font-family: 'KaiTi'; font-size: 1.1rem;">未找到相关人物</p>
            </div>
        </div>
    </div>

<!-- 第三版：国风粗卷轴详情弹窗（仅删除叉号） -->
<div class="modal fade" id="figureDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content paper-card" style="border: none;">
            <div class="modal-header text-center" style="background: linear-gradient(180deg, #f8f3e9, #fff); border-bottom: 1px dashed #ccc;">
                <div class="scroll-rod-small left"></div>
                <div class="scroll-rod-small right"></div>
                <h5 class="modal-title w-100" id="modalTitle" style="font-family: 'LiSu'; color: var(--dark-wood); font-size: 1.8rem;"></h5>
            </div>
            <div class="modal-body" id="modalBodyContainer" style="background-image: linear-gradient(to bottom, rgba(245,240,230,0.3) 1px, transparent 1px); background-size: 100% 28px;">
            </div>
            <div class="modal-footer justify-content-center" style="border-top: 1px dashed #ccc; background: #f8f3e9;">
                <button type="button" class="btn" style="background-color: var(--ming-red); color: #fff; font-family: 'LiSu';" data-bs-dismiss="modal">
                    关闭详细
                </button>
            </div>
        </div>
    </div>
</div>

    <!-- Vue3 脚本（集成模糊查询+分类+弹窗） -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const { createApp, ref, computed, onMounted, nextTick, watch } = Vue;

            createApp({
                setup() {
                    // 1. 初始化数据
                    const allFigures = ref(window.figureData || []);
                    const searchQuery = ref('');
                    const currentCat = ref('<%= Request.QueryString["cat"] ?? "" %>');

                    // 2. 组合筛选：分类 + 模糊搜索
                    const filteredFigures = computed(() => {
                        let result = [...allFigures.value];

                        if (currentCat.value) {
                            result = result.filter(item => item.Category === currentCat.value);
                        }

                        if (searchQuery.value) {
                            const q = searchQuery.value.toLowerCase();
                            result = result.filter(item =>
                                (item.Name?.toLowerCase().includes(q)) ||
                                (item.IdentityTitle?.toLowerCase().includes(q)) ||
                                (item.Achievement?.toLowerCase().includes(q))
                            );
                        }

                        return result;
                    });

                    // 3. 卡片入场动画
                    const playAnim = () => {
                        nextTick(() => {
                            const cards = document.querySelectorAll('.animate-card');
                            cards.forEach((card, i) => {
                                card.classList.remove('animate-in');
                                void card.offsetWidth;
                                setTimeout(() => {
                                    card.classList.add('animate-in');
                                }, i * 100);
                            });
                        });
                    };

                    // 4. 打开详情弹窗
                    const openFigureDetail = (data) => {
                        document.getElementById('modalTitle').innerText = data.Name;
                        const htmlContent = `
                            <div class="mb-3 text-center">
                                <span class="badge" style="font-family: 'KaiTi'; background-color: var(--dark-wood); color: #fff;">${data.Category}</span>
                                <p class="text-muted mt-2 mb-0">${data.BirthYear || '?'} 年 - ${data.DeathYear || '?'} 年</p>
                                <p class="fw-bold" style="font-family: 'KaiTi'; color: var(--dark-wood);">${data.IdentityTitle || '暂无记载'}</p>
                            </div>
                            <div class="mb-3">
                                <h6 style="font-family: 'LiSu'; color: var(--ming-red);"><i class="ri-medal-line"></i> 主要成就</h6>
                                <p style="font-family: 'KaiTi'; font-size: 1.1rem;">${data.Achievement || '暂无记载'}</p>
                            </div>
                            <div>
                                <h6 style="font-family: 'LiSu'; color: var(--ming-red);"><i class="ri-book-2-line"></i> 人物生平</h6>
                                <p style="font-family: 'KaiTi'; font-size: 1.1rem; line-height: 2; text-indent: 2em;">${data.Intro || '暂无详细介绍'}</p>
                            </div>
                        `;
                        document.getElementById('modalBodyContainer').innerHTML = htmlContent;
                        const modal = new bootstrap.Modal(document.getElementById('figureDetailModal'));
                        modal.show();
                    };

                    onMounted(() => {
                        playAnim();
                        const catLinks = document.querySelectorAll('.cat-btn');
                        catLinks.forEach(link => {
                            link.addEventListener('click', (e) => {
                                const href = link.getAttribute('href');
                                const catParam = new URLSearchParams(href.split('?')[1] || '').get('cat');
                                currentCat.value = catParam || '';
                            });
                        });
                    });
                    watch([filteredFigures], playAnim);

                    return {
                        searchQuery,
                        currentCat,
                        filteredFigures,
                        openFigureDetail
                    };
                }
            }).mount('#vue-app');
        });
    </script>

    <!-- 专属样式（第三版弹窗 + 加粗卷轴柱子） -->
    <style>
        :root {
            --ming-red: #8E2323;
            --dark-wood: #3E2723;
            --paper-bg: #F7F3E8;
            --paper-white: #FCF9F2;
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
        }

            .cat-btn:hover, .cat-btn.active {
                background-color: var(--dark-wood);
                color: #fff;
                border-color: var(--dark-wood);
                box-shadow: 0 4px 10px rgba(62, 39, 35, 0.2);
            }

        .paper-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
            background: var(--paper-white);
        }

            .paper-card:hover {
                transform: translateY(-6px);
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
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

        .avatar-wrapper {
            width: 100px;
            height: 100px;
            position: relative;
        }

        .avatar-frame {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            border: 3px solid var(--ming-red);
            overflow: hidden;
            background: var(--paper-bg);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .paper-card:hover .avatar-frame {
            transform: scale(1.07);
            box-shadow: 0 0 15px rgba(142, 35, 35, 0.2);
        }

        .view-detail-btn {
            font-family: 'KaiTi';
            color: var(--ming-red);
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .paper-card:hover .view-detail-btn {
            letter-spacing: 1px;
            color: #701b1b;
        }

        /* ====================== 第三版 · 加粗卷轴柱子（你要的更粗） ====================== */
        .scroll-rod-small {
            position: absolute;
            top: 0;
            width: 22px; /* 加粗到 22px，更稳重 */
            height: 100%;
            background: linear-gradient(180deg,#3E2A18,#6D4C41,#3E2A18);
            border-radius: 5px;
            z-index: 10;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
        }
            .scroll-rod-small.left {
                left: -10px;
            }
            .scroll-rod-small.right {
                right: -10px;
            }

        #figureDetailModal .modal-content {
            border-radius: 8px;
            overflow: hidden;
        }

        #figureDetailModal .modal-body {
            font-family: 'KaiTi';
            font-size: 1.1rem;
            line-height: 1.8;
            padding: 1.5rem;
        }
    </style>

</asp:Content>