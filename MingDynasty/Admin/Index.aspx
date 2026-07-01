<%@ Page Title="数据大屏" Language="C#" MasterPageFile="~/Admin/Site_a.master" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Admin_Index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
        // 等整个页面（包括母版页底部的jQuery、自定义函数）全部加载完成后再执行
        window.onload = function () {
            // 从后台获取初始数据
            let emperorCount = <%= EmperorCount %>;
            let eventCount = <%= EventCount %>;
            let figureCount = <%= FigureCount %>;
            let messageCount = <%= MessageCount %>;

            let reignChartData = <%= ReignChartData %> || [];
            let periodChartData = <%= PeriodChartData %> || [];
            let contentChartData = <%= ContentChartData %> || [];
            let messageTrendData = <%= MessageTrendData %> || [];

            // ✅ 时间实时走秒
            function updateCurrentTime() {
                const now = new Date();
                const year = now.getFullYear();
                const month = String(now.getMonth() + 1).padStart(2, '0');
                const day = String(now.getDate()).padStart(2, '0');
                const hours = String(now.getHours()).padStart(2, '0');
                const minutes = String(now.getMinutes()).padStart(2, '0');
                const seconds = String(now.getSeconds()).padStart(2, '0');

                document.getElementById('current-time').textContent =
                    `公元 ${year}年${month}月${day}日 ${hours}:${minutes}:${seconds} | 大明二百七十六年`;
            }

            // 初始化时间并每秒更新
            updateCurrentTime();
            setInterval(updateCurrentTime, 1000);

            // 数字滚动动画 + 图表初始化
            $(function () {
                // 数字滚动动画
                setTimeout(() => {
                    animateNumber('#stat-emperor', emperorCount);
                    animateNumber('#stat-event', eventCount);
                    animateNumber('#stat-figure', figureCount);
                    animateNumber('#stat-message', messageCount);
                }, 500);

                // 初始化所有图表
                initCharts();
            });

            // 图表初始化函数
            function initCharts() {
                // 1. 皇帝在位时长排行
                const chartReign = echarts.init(document.getElementById('chart-reign'));
                chartReign.setOption({
                    backgroundColor: 'transparent',
                    tooltip: { trigger: 'axis' },
                    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
                    xAxis: {
                        type: 'value',
                        axisLine: { lineStyle: { color: '#D7CCC8' } },
                        axisLabel: { color: '#666' }
                    },
                    yAxis: {
                        type: 'category',
                        data: reignChartData.length > 0 ? reignChartData.map(item => item.name) : ['暂无数据'],
                        axisLine: { lineStyle: { color: '#D7CCC8' } },
                        axisLabel: { color: '#666' }
                    },
                    series: [{
                        name: '在位年数',
                        type: 'bar',
                        data: reignChartData.length > 0 ? reignChartData.map(item => item.years) : [0],
                        itemStyle: {
                            color: new echarts.graphic.LinearGradient(0, 0, 1, 0, [
                                { offset: 0, color: '#C41E3A' },
                                { offset: 1, color: '#E57373' }
                            ]),
                            borderRadius: [0, 4, 4, 0]
                        },
                        barWidth: '60%'
                    }]
                });

                // 2. 历史事件时期分布
                const chartPeriod = echarts.init(document.getElementById('chart-period'));
                const periodColors = {
                    '开国': '#C41E3A',
                    '盛世': '#D4AF37',
                    '转折': '#FD7E14',
                    '衰落': '#6C757D',
                    '灭亡': '#343A40'
                };

                chartPeriod.setOption({
                    backgroundColor: 'transparent',
                    tooltip: { trigger: 'item' },
                    legend: { bottom: '0%', left: 'center', textStyle: { color: '#666' } },
                    series: [{
                        name: '事件数量',
                        type: 'pie',
                        radius: ['40%', '70%'],
                        itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
                        label: { show: false },
                        emphasis: { label: { show: true, fontSize: 14, fontWeight: 'bold' } },
                        data: periodChartData.length > 0 ? periodChartData.map(item => ({
                            value: item.value,
                            name: item.name,
                            itemStyle: { color: periodColors[item.name] || '#666' }
                        })) : [{ value: 1, name: '暂无数据', itemStyle: { color: '#ccc' } }]
                    }]
                });

                // 3. 内容类型数量统计
                const chartContent = echarts.init(document.getElementById('chart-content'));
                chartContent.setOption({
                    backgroundColor: 'transparent',
                    tooltip: { trigger: 'axis' },
                    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
                    xAxis: {
                        type: 'category',
                        data: contentChartData.length > 0 ? contentChartData.map(item => item.name) : ['暂无数据'],
                        axisLine: { lineStyle: { color: '#D7CCC8' } },
                        axisLabel: { color: '#666' }
                    },
                    yAxis: {
                        type: 'value',
                        axisLine: { lineStyle: { color: '#D7CCC8' } },
                        axisLabel: { color: '#666' }
                    },
                    series: [{
                        name: '数量',
                        type: 'bar',
                        data: contentChartData.length > 0 ? contentChartData.map(item => item.value) : [0],
                        itemStyle: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                { offset: 0, color: '#8D6E63' },
                                { offset: 1, color: '#D7CCC8' }
                            ]),
                            borderRadius: [8, 8, 0, 0]
                        },
                        barWidth: '50%'
                    }]
                });

                // 4. 近7天留言趋势
                const chartMessage = echarts.init(document.getElementById('chart-message'));
                chartMessage.setOption({
                    backgroundColor: 'transparent',
                    tooltip: { trigger: 'axis' },
                    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
                    xAxis: {
                        type: 'category',
                        boundaryGap: false,
                        data: messageTrendData.length > 0 ? messageTrendData.map(item => item.date) : ['暂无数据'],
                        axisLine: { lineStyle: { color: '#D7CCC8' } },
                        axisLabel: { color: '#666' }
                    },
                    yAxis: {
                        type: 'value',
                        axisLine: { lineStyle: { color: '#D7CCC8' } },
                        axisLabel: { color: '#666' }
                    },
                    series: [{
                        name: '留言数',
                        type: 'line',
                        smooth: true,
                        data: messageTrendData.length > 0 ? messageTrendData.map(item => item.count) : [0],
                        itemStyle: { color: '#28A745' },
                        lineStyle: { width: 3 },
                        areaStyle: {
                            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                                { offset: 0, color: 'rgba(40,167,69,0.3)' },
                                { offset: 1, color: 'rgba(40,167,69,0.05)' }
                            ])
                        }
                    }]
                });

                // 窗口大小变化时重绘图表
                window.addEventListener('resize', function () {
                    chartReign.resize();
                    chartPeriod.resize();
                    chartContent.resize();
                    chartMessage.resize();
                });
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <!-- 欢迎区域（时间实时走秒） -->
    <div class="ming-card mb-4 animate__animated animate__fadeInDown">
        <div class="d-flex align-items-center gap-3">
            <i class="ri-book-open-line" style="font-size: 2.5rem; color: var(--cinnabar);"></i>
            <div>
                <h4 style="font-family: 'LiSu'; margin-bottom: 0.3rem;">今日文渊阁当值</h4>
                <p class="text-muted mb-0" id="current-time">公元 2026年04月21日 | 大明二百七十六年</p>
            </div>
        </div>
    </div>

    <!-- 数据统计卡片 -->
    <div class="row g-4 mb-4">
        <div class="col-lg-3 col-md-6">
            <div class="ming-card stat-card animate__animated animate__fadeInUp animate__delay-100ms">
                <div class="stat-icon">
                    <i class="ri-vip-crown-fill"></i>
                </div>
                <div class="stat-number" id="stat-emperor">0</div>
                <div class="stat-label">大明帝王</div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="ming-card stat-card animate__animated animate__fadeInUp animate__delay-200ms">
                <div class="stat-icon">
                    <i class="ri-history-fill"></i>
                </div>
                <div class="stat-number" id="stat-event">0</div>
                <div class="stat-label">历史大事件</div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="ming-card stat-card animate__animated animate__fadeInUp animate__delay-300ms">
                <div class="stat-icon">
                    <i class="ri-user-star-fill"></i>
                </div>
                <div class="stat-number" id="stat-figure">0</div>
                <div class="stat-label">名臣名将</div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6">
            <div class="ming-card stat-card animate__animated animate__fadeInUp animate__delay-400ms">
                <div class="stat-icon">
                    <i class="ri-quill-pen-fill"></i>
                </div>
                <div class="stat-number" id="stat-message">0</div>
                <div class="stat-label">用户留言</div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-lg-8">
            <div class="ming-card animate__animated animate__fadeInLeft">
                <div class="card-header">
                    <h5 class="card-title">
                        <i class="ri-bar-chart-2-line"></i>
                        大明十六帝在位时长排行
                    </h5>
                </div>
                <div id="chart-reign" class="chart-container"></div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="ming-card animate__animated animate__fadeInRight h-100">
                <div class="card-header">
                    <h5 class="card-title">
                        <i class="ri-pie-chart-line"></i>
                        历史事件时期分布
                    </h5>
                </div>
                <div id="chart-period" class="chart-container"></div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-6">
            <div class="ming-card animate__animated animate__fadeInUp animate__delay-100ms">
                <div class="card-header">
                    <h5 class="card-title">
                        <i class="ri-file-list-3-line"></i>
                        内容类型数量统计
                    </h5>
                </div>
                <div id="chart-content" class="chart-container"></div>
            </div>
        </div>
        
        <div class="col-lg-6">
            <div class="ming-card animate__animated animate__fadeInUp animate__delay-200ms">
                <div class="card-header">
                    <h5 class="card-title">
                        <i class="ri-line-chart-line"></i>
                        近7天留言趋势
                    </h5>
                </div>
                <div id="chart-message" class="chart-container"></div>
            </div>
        </div>
    </div>
</asp:Content>