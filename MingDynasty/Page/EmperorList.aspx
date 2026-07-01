<%@ Page Title="大明帝王" Language="C#" MasterPageFile="~/Page/Site.master" AutoEventWireup="true" CodeFile="EmperorList.aspx.cs" Inherits="Page_EmperorList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <!-- Vue 挂载容器 -->
    <div class="container py-5" id="vue-app">
        
        <!-- 页面标题 -->
        <div class="text-center mb-5">
            <h2 class="fw-bold" style="font-family: 'LiSu'; color: var(--ming-red);">
                <i class="ri-empress-line"></i> 大明十六帝
            </h2>
            <p class="text-muted">公元1368年 - 公元1644年</p>
        </div>

        <!-- 搜索/筛选栏 -->
        <div class="row mb-4">
            <div class="col-md-6 offset-md-3">
                <div class="input-group paper-card">
                    <span class="input-group-text bg-light"><i class="ri-search-line"></i></span>
                    <input type="text" class="form-control" v-model="searchQuery" placeholder="搜索帝王庙号、姓名...">
                </div>
            </div>
        </div>

        <!-- 帝王卡片列表 -->
        <div class="row g-4">
            <div class="col-lg-3 col-md-4 col-sm-6" v-for="(item, index) in filteredEmperors" :key="item.ID">
                <div class="card paper-card h-100 text-center animate-card">
                    <!-- 头像区域 -->
                    <div class="pt-4">
                        <div class="mx-auto rounded-circle d-flex align-items-center justify-content-center overflow-hidden" 
                             style="width: 100px; height: 100px; background: var(--paper-bg); border: 3px solid var(--ming-gold);">
                            <img v-if="item.Avatar" :src="item.Avatar" style="width: 100%; height: 100%; object-fit: cover;" />
                            <i v-else class="ri-user-3-line" style="font-size: 3rem; color: var(--dark-wood);"></i>
                        </div>
                    </div>

                    <div class="card-body">
                        <h5 class="card-title mb-1" style="color: var(--ming-red); font-family: 'KaiTi';">{{ item.TempleName }}</h5>
                        <span class="badge text-white mb-2" style="background-color: var(--dark-wood);">{{ item.ReignTitle }}</span>
                        <p class="card-text mb-1 text-muted small">姓名：{{ item.EmpName }}</p>
                        <p class="card-text text-muted small">在位：{{ item.ReignYears }}</p>
                        
                        <a :href="'EmperorDetail.aspx?id=' + item.ID" class="btn btn-sm mt-2" 
                           style="background-color: var(--ming-red); color: #fff; border-color: var(--ming-gold);">
                            查看详情 <i class="ri-arrow-right-line"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 搜索无结果提示 -->
        <div v-if="filteredEmperors.length === 0" class="text-center py-5 text-muted">
            <i class="ri-emotion-sad-line" style="font-size: 3rem;"></i>
            <p class="mt-2">未找到相关帝王</p>
        </div>

    </div>

    <!-- Vue3 脚本 -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const { createApp, ref, computed, onMounted, nextTick, watch } = Vue;

            createApp({
                setup() {
                    const allEmperors = ref(window.emperorData || []);
                    const searchQuery = ref('');

                    // 搜索过滤
                    const filteredEmperors = computed(() => {
                        if (!searchQuery.value) return allEmperors.value;
                        const q = searchQuery.value.toLowerCase();
                        return allEmperors.value.filter(item =>
                            (item.TempleName?.toLowerCase().includes(q)) ||
                            (item.EmpName?.toLowerCase().includes(q)) ||
                            (item.ReignTitle?.toLowerCase().includes(q))
                        );
                    });

                    // 卡片依次入场动画
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

                    onMounted(playAnim);
                    watch(filteredEmperors, playAnim);

                    return {
                        searchQuery,
                        filteredEmperors
                    };
                }
            }).mount('#vue-app');
        });
    </script>

    <!-- 样式：入场动画 + 舒适悬停，不花哨、质感强 -->
    <style>
        /* 卡片入场动画 */
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

        /* 悬停效果：柔和上浮 + 阴影，不夸张 */
        .paper-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            cursor: pointer;
        }

        .paper-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
        }

        /* 头像轻微放大 */
        .rounded-circle {
            transition: transform 0.3s ease;
        }

        .paper-card:hover .rounded-circle {
            transform: scale(1.07);
        }

        /* 按钮微动 */
        .paper-card .btn {
            transition: transform 0.2s ease;
        }

        .paper-card:hover .btn {
            transform: translateY(-2px);
        }
    </style>

</asp:Content>