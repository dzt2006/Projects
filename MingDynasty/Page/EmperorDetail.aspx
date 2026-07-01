<%@ Page Title="" Language="C#" MasterPageFile="~/Page/Site.master" AutoEventWireup="true" CodeFile="EmperorDetail.aspx.cs" Inherits="Page_EmperorDetail" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <!-- Vue 挂载容器 -->
    <div class="container py-5" id="vue-app">
        
        <!-- 1. 返回按钮 -->
        <div class="mb-4">
            <a href="EmperorList.aspx" class="btn btn-outline-secondary" style="border-color: var(--dark-wood); color: var(--dark-wood);">
                <i class="ri-arrow-left-line"></i> 返回帝王列表
            </a>
        </div>

        <!-- 2. 主体内容：卷轴风格 -->
        <div class="row">
            <!-- 左侧：画像 & 基本信息 -->
            <div class="col-lg-4 mb-4">
                <!-- 添加了 animate-card 和 left-card 类 -->
                <div class="card paper-card shadow-lg sticky-top animate-card left-card" style="top: 100px;">
                    <!-- 画像 -->
                    <div class="text-center p-4 border-bottom" style="background: linear-gradient(180deg, #fff 0%, var(--paper-bg) 100%);">
                        <div class="mx-auto mb-3 overflow-hidden" 
                             style="width: 200px; height: 260px; border: 4px solid var(--ming-gold); background: #fff;">
                            <img v-if="detail.Avatar" :src="detail.Avatar" class="w-100 h-100" style="object-fit: cover;" />
                            <div v-else class="w-100 h-100 d-flex align-items-center justify-content-center" style="background: #eee;">
                                <i class="ri-user-3-line" style="font-size: 5rem; color: #ccc;"></i>
                            </div>
                        </div>
                        <!-- 庙号大标题 -->
                        <h2 class="fw-bold mb-0" style="font-family: 'LiSu'; color: var(--ming-red);">{{ detail.TempleName }}</h2>
                        <p class="text-muted mb-0">{{ detail.Period }}</p>
                    </div>

                    <!-- 档案信息列表 -->
                    <div class="card-body">
                        <h6 class="mb-3 pb-2 border-bottom" style="color: var(--dark-wood); font-family: 'KaiTi';">
                            <i class="ri-file-list-3-line"></i> 帝王档案
                        </h6>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item d-flex justify-content-between px-0" style="background: transparent;">
                                <span class="text-muted">年号</span>
                                <strong>{{ detail.ReignTitle }}</strong>
                            </li>
                            <li class="list-group-item d-flex justify-content-between px-0" style="background: transparent;">
                                <span class="text-muted">姓名</span>
                                <strong>{{ detail.EmpName }}</strong>
                            </li>
                            <li class="list-group-item d-flex justify-content-between px-0" style="background: transparent;">
                                <span class="text-muted">在位</span>
                                <strong>{{ detail.ReignYears }}</strong>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- 右侧：生平简介长文 -->
            <div class="col-lg-8">
                <!-- 添加了 animate-card 和 right-card 类 -->
                <div class="card paper-card shadow-lg p-5 animate-card right-card">
                    <div class="mb-4 text-center border-bottom pb-3">
                        <h4 class="fw-bold" style="font-family: 'LiSu'; color: var(--dark-wood);">
                            <i class="ri-book-2-line"></i> 生平简介
                        </h4>
                    </div>
                    
                    <!-- 简介内容：保留换行格式 -->
                    <div class="content-body" style="font-family: 'KaiTi', 'STKaiti'; font-size: 1.15rem; line-height: 2; color: #333; text-indent: 2em;">
                        <!-- Vue 渲染换行：把 \n 替换成 <br> -->
                        <div v-html="formattedIntro"></div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Vue3 脚本 -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // 引入 onMounted 和 nextTick
            const { createApp, ref, computed, onMounted, nextTick } = Vue;

            createApp({
                setup() {
                    // 1. 接收后端数据
                    const detail = ref(window.emperorDetail || {});

                    // 2. 处理简介换行
                    const formattedIntro = computed(() => {
                        if (!detail.value.Intro) return '';
                        return detail.value.Intro.replace(/\n/g, '<br/>');
                    });

                    // 3. 页面挂载后触发动画
                    onMounted(() => {
                        nextTick(() => {
                            const leftCard = document.querySelector('.left-card');
                            const rightCard = document.querySelector('.right-card');

                            // 给卡片添加 animate-in 类以启动动画
                            if (leftCard) leftCard.classList.add('animate-in');
                            if (rightCard) rightCard.classList.add('animate-in');
                        });
                    });

                    return {
                        detail,
                        formattedIntro
                    };
                }
            }).mount('#vue-app');
        });
    </script>

    <!-- 本页微调样式 + 动画样式 -->
    <style>
        /* 让简介里的内容更像古籍 */
        .content-body br {
            margin-bottom: 10px;
            content: "";
            display: block;
        }

        /* --- 卡片飞入动画核心样式 --- */
        .animate-card {
            /* 初始状态：透明 + 不可见 */
            opacity: 0;
        }

        /* 左侧卡片初始位置：在屏幕左侧外 */
        .animate-card.left-card {
            transform: translateX(-100px);
        }

        /* 右侧卡片初始位置：在屏幕右侧外 */
        .animate-card.right-card {
            transform: translateX(100px);
        }

        /* 动画启动类 */
        .animate-card.animate-in {
            animation: slideIn 0.8s cubic-bezier(0.22, 1, 0.36, 1) forwards;
        }

        /* 左侧动画 */
        .animate-card.left-card.animate-in {
            animation-name: slideInLeft;
        }

        /* 右侧动画：延迟 0.2 秒启动，产生错落感 */
        .animate-card.right-card.animate-in {
            animation-name: slideInRight;
            animation-delay: 0.2s;
        }

        /* 关键帧：从左飞入 */
        @keyframes slideInLeft {
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* 关键帧：从右飞入 */
        @keyframes slideInRight {
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
    </style>

</asp:Content>

