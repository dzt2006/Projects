<%@ Page Title="" Language="C#" MasterPageFile="~/Page/Site.master" AutoEventWireup="true" CodeFile="EventTimeline.aspx.cs" Inherits="Page_EventTimeline" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="container py-4" id="vue-app">
        
        <!-- 1. 古风标题区：卷轴装饰 -->
        <div class="text-center mb-4 position-relative">
            <div class="scroll-decoration-top"></div>
            <h2 class="fw-bold mb-2" style="font-family: 'LiSu'; font-size: 2.5rem; color: var(--dark-wood);">
                <i class="ri-history-line"></i> 大明历史长卷
            </h2>
            <p class="text-muted" style="font-family: 'KaiTi'; font-size: 1.1rem;">— 276年风云变幻，尽在一卷 —</p>
            <div class="mx-auto mt-3" style="width: 120px; height: 3px; background: linear-gradient(90deg, transparent, var(--ming-red), transparent);"></div>
        </div>

        <!-- 2. 时间线操作提示 -->
        <div class="text-center mb-3 text-muted small" style="font-family: 'KaiTi';">
            <i class="ri-mouse-line"></i> 提示：可左右拖拽时间线、滚轮缩放查看更多历史事件
        </div>

        <!-- 3. 核心：Vis-Timeline 容器 -->
        <div class="timeline-wrapper paper-card">
            <div class="book-spine"></div>
            <div id="ming-timeline"></div>
        </div>

        <!-- 4. 古风弹窗：显示事件详情 -->
        <div class="modal fade" id="eventModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content memorial-card" style="border: none;">
                    <!-- 弹窗头部：卷轴风格 -->
                    <div class="modal-header text-center" style="background: linear-gradient(180deg, #f8f3e9, #fff); border-bottom: 1px dashed #ccc; position: relative;">
                        <div class="scroll-rod-small left"></div>
                        <h5 class="modal-title w-100" id="eventModalLabel" style="font-family: 'LiSu'; color: var(--dark-wood); font-size: 1.5rem;"></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="position: absolute; right: 15px; top: 15px;"></button>
                        <div class="scroll-rod-small right"></div>
                    </div>
                    <!-- 弹窗内容 -->
                    <div class="modal-body" style="background-image: linear-gradient(to bottom, rgba(245,240,230,0.3) 1px, transparent 1px); background-size: 100% 28px;">
                        <div class="mb-3 text-center">
                            <span class="badge" style="background-color: var(--ming-red); font-family: 'KaiTi';">
                                <i class="ri-calendar-event-line"></i> <span id="modalYear"></span>年
                            </span>
                        </div>
                        <div id="modalContent" style="font-family: 'KaiTi'; font-size: 1.15rem; line-height: 2; color: #333; text-indent: 2em;"></div>
                    </div>
                    <!-- 弹窗底部 -->
                    <div class="modal-footer justify-content-center" style="border-top: 1px dashed #ccc; background: #f8f3e9;">
                        <button type="button" class="btn ancient-btn" data-bs-dismiss="modal">
                            关闭长卷
                        </button>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <link href="../css/vis-timeline-graph2d.min.css" rel="stylesheet" />
    <script src="../js/moment.min.js"></script>
    <script src="../js/vis-timeline-graph2d.min.js"></script>


    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const { createApp, ref, onMounted } = Vue;

            createApp({
                setup() {
                    let timeline = null;
                    const eventsData = ref([]);

                    // 定义分组（不同时期用不同颜色）
                    const groups = new vis.DataSet([

                        { id: '开国', content: '开国', style: 'background-color: rgba(196,30,58,0.1); color: #C41E3A;' },
                        { id: '盛世', content: '盛世', style: 'background-color: rgba(212,175,55,0.1); color: #D4AF37;' },
                        { id: '转折', content: '转折', style: 'background-color: rgba(253,126,20,0.1); color: #FD7E14;' },
                        { id: '衰落', content: '衰落', style: 'background-color: rgba(108,117,125,0.1); color: #6C757D;' },
                        { id: '灭亡', content: '灭亡', style: 'background-color: rgba(52,58,64,0.1); color: #343A40;' }
                    ]);

                    // 加载数据并初始化时间线
                    const initTimeline = async () => {
                        try {
                            const response = await fetch('EventTimeline.aspx/GetEvents', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json; charset=utf-8' }
                            });
                            const data = await response.json();
                            if (data.d) {
                                eventsData.value = JSON.parse(data.d);

                                const items = new vis.DataSet(eventsData.value.map(e => ({
                                    id: e.id,
                                    content: `<span style="font-family:'KaiTi'; font-weight:bold;">${e.content}</span>`,
                                    start: e.start,
                                    group: e.group,
                                    title: e.title,
                                    fullContent: e.fullContent,
                                    eventYear: e.eventYear,
                                    eventName: e.content
                                })));

                                const container = document.getElementById('ming-timeline');

                                // 配置：严格锁定500年时间范围 + 丝滑动画
                                const options = {
                                    editable: false,
                                    selectable: true,
                                    multiselect: false,
                                    // 固定500年时间轴：1328-1828
                                    start: '1328-01-01',
                                    end: '1828-01-01',
                                    min: '1328-01-01',
                                    max: '1828-01-01',
                                    zoomMin: 1000 * 60 * 60 * 24 * 365 * 10,
                                    zoomMax: 1000 * 60 * 60 * 24 * 365 * 500,
                                    orientation: 'top',
                                    timeAxis: { scale: 'year', step: 10 },
                                    format: {
                                        minorLabels: { year: 'YYYY年' },
                                        majorLabels: { year: '' }
                                    },
                                    margin: { item: 15, axis: 30 },
                                    showCurrentTime: false,
                                    // ✅ 正确写法：sequentialSelection只接受布尔值
                                    sequentialSelection: true,
                                    // 【保留】按分组ID顺序排列（开国→盛世→转折...）
                                    groupOrder: 'id'
                                };

                                timeline = new vis.Timeline(container, items, groups, options);

                                timeline.on('select', function (properties) {
                                    if (properties.items.length > 0) {
                                        const selectedId = properties.items[0];
                                        const selectedItem = items.get(selectedId);

                                        document.getElementById('eventModalLabel').innerText = selectedItem.eventName;
                                        document.getElementById('modalYear').innerText = selectedItem.eventYear || '不详';
                                        document.getElementById('modalContent').innerHTML = selectedItem.fullContent || '暂无详细记载';

                                        const modal = new bootstrap.Modal(document.getElementById('eventModal'));
                                        modal.show();
                                    }
                                });
                            }
                        } catch (error) {
                            console.error('初始化时间线失败:', error);
                            alert('加载历史长卷失败，请刷新页面重试');
                        }
                    };

                    onMounted(() => {
                        initTimeline();
                    });

                    return {};
                }
            }).mount('#vue-app');
        });
    </script>

    <!-- 书卷风全套美化CSS -->
    <style>
        :root {
            --ming-red: #8E2323;
            --ming-gold: #B8860B;
            --paper-bg: #F7F3E8;
            --paper-dark: #EDE7D9;
            --ink-black: #2C2C2C;
            --dark-wood: #3E2723;
            --scroll-shadow: 0 10px 30px rgba(62, 39, 35, 0.15);
        }

        body {
            background-color: #f0ebe0 !important;
        }

        /* 顶部卷轴横梁 */
        .scroll-decoration-top {
            width: 100%;
            height: 16px;
            background: linear-gradient(180deg, #5D4037, #8D6E63, #5D4037);
            border-radius: 8px 8px 2px 2px;
            margin-bottom: 0;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            position: relative;
            z-index: 20;
        }
        .scroll-decoration-top::before,
        .scroll-decoration-top::after {
            content: '';
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 24px;
            background: radial-gradient(circle, #D7CCC8, #8D6E63);
            border-radius: 4px;
            box-shadow: inset 0 0 5px rgba(0,0,0,0.2);
        }
        .scroll-decoration-top::before { left: -10px; }
        .scroll-decoration-top::after { right: -10px; }

        /* 古籍书卷容器 */
        .timeline-wrapper {
            background: var(--paper-bg);
            border: none;
            border-radius: 0 0 4px 4px;
            padding: 40px 30px;
            position: relative;
            overflow: hidden;
            box-shadow: var(--scroll-shadow);
            background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.05'/%3E%3C/svg%3E");
            border-top: 2px solid #d7ccc8;
        }

        /* 古籍包角 */
        .timeline-wrapper::before,
        .timeline-wrapper::after {
            content: '';
            position: absolute;
            width: 60px;
            height: 60px;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Cpath d='M0 0 L100 0 L100 10 L10 10 L10 100 L0 100 Z' fill='%235D4037' opacity='0.2'/%3E%3C/svg%3E");
            background-size: contain;
            pointer-events: none;
            z-index: 10;
        }
        .timeline-wrapper::before { top: 0; left: 0; }
        .timeline-wrapper::after { bottom: 0; right: 0; transform: rotate(180deg); }

        /* 线装书书脊 */
        .book-spine {
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 15px;
            background: linear-gradient(90deg, #3E2723, #5D4037, #4E342E);
            z-index: 15;
            box-shadow: 2px 0 5px rgba(0,0,0,0.2);
        }

        /* Vis Timeline 古风重绘 */
        .vis-timeline {
            background-color: transparent;
            font-family: "KaiTi", "STKaiti", sans-serif;
            margin-left: 10px;
        }
        .vis-time-axis .vis-grid {
            border-color: #E0D8C8;
            border-style: dashed;
        }
        .vis-time-axis .vis-text {
            color: var(--dark-wood);
            font-family: "LiSu", cursive;
            font-size: 1.1rem;
            font-weight: bold;
            padding-top: 5px;
        }
        .vis-label {
            font-family: "LiSu", cursive;
            font-size: 1.1rem;
            border: none !important;
            background: rgba(255,255,255,0.8) !important;
            color: var(--dark-wood);
            border-right: 2px solid var(--ming-gold) !important;
        }

        /* 事件点精致动画 */
        .vis-item {
            border: 2px solid var(--ming-red);
            background: #fff;
            color: var(--dark-wood) !important;
            font-family: "KaiTi", sans-serif;
            font-weight: bold;
            border-radius: 2px;
            box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
        }
        .vis-item:hover {
            transform: translateY(-5px) scale(1.08);
            box-shadow: 0 8px 20px rgba(142, 35, 35, 0.3);
            background: var(--ming-red);
            color: #fff !important;
            border-color: var(--dark-wood);
            z-index: 100;
        }
        .vis-item.vis-selected {
            background: var(--ming-gold) !important;
            color: #fff !important;
            border-color: var(--dark-wood);
        }
        .vis-item .vis-dot {
            border-color: var(--ming-red) !important;
            border-width: 3px;
            background: #fff !important;
            box-shadow: 0 0 5px rgba(142, 35, 35, 0.5);
        }

        /* 滚动条书卷风 */
        .vis-panel::-webkit-scrollbar {
            width: 10px; height: 10px;
        }
        .vis-panel::-webkit-scrollbar-thumb {
            background: var(--dark-wood);
            border-radius: 10px;
            border: 2px solid var(--paper-bg);
        }
        .vis-panel::-webkit-scrollbar-track {
            background: var(--paper-dark);
        }

        /* 弹窗卷轴展开动画 */
        @keyframes scrollOpen {
            0% { opacity: 0; transform: scaleY(0.2); }
            100% { opacity: 1; transform: scaleY(1); }
        }
        .modal.show .modal-dialog {
            animation: scrollOpen 0.5s cubic-bezier(0.22, 1, 0.36, 1);
        }
        .scroll-rod-small {
            position: absolute;
            top: 0;
            width: 14px;
            height: 100%;
            background: linear-gradient(180deg, #5D4037, #8D6E63, #5D4037);
            border-radius: 4px;
            z-index: 10;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
        }
        .scroll-rod-small.left { left: -5px; }
        .scroll-rod-small.right { right: -5px; }

        /* 古风按钮 */
        .ancient-btn {
            background-color: var(--ming-red);
            color: #fff;
            border: 2px solid var(--dark-wood);
            font-family: "LiSu", cursive;
            font-size: 1.2rem;
            padding: 0.5rem 1.5rem;
            transition: all 0.3s;
        }
        .ancient-btn:hover {
            background: #fff;
            color: var(--ming-red);
            border-color: var(--ming-red);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
    </style>

</asp:Content>

