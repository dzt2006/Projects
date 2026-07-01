<%@ Page Title="" Language="C#" MasterPageFile="~/Page/Site.master" AutoEventWireup="true" CodeFile="MessageBoard.aspx.cs" Inherits="Page_essageBoard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="container py-5" id="vue-app">
        
        <!-- 1. 古风标题区 -->
        <div class="text-center mb-5">
            <h2 class="fw-bold mb-2" style="font-family: 'LiSu'; font-size: 2.8rem; color: var(--dark-wood);">
                <i class="ri-quill-pen-line"></i> 大明题壁
            </h2>
            <p class="text-muted" style="font-family: 'KaiTi'; font-size: 1.1rem;">— 笔落惊风雨，文成泣鬼神 —</p>
            <div class="mx-auto mt-4" style="width: 100px; height: 3px; background: linear-gradient(90deg, transparent, var(--ming-red), transparent);"></div>
        </div>

        <!-- 2. 发表留言区 -->
        <div class="row mb-5">
            <div class="col-lg-8 offset-lg-2">
                <div class="card paper-card memorial-card" style="border-radius: 8px;">
                    <div class="card-header text-center" style="background: linear-gradient(180deg, #f8f3e9, #fff); border-bottom: 1px dashed #ccc;">
                        <h5 class="mb-0" style="font-family: 'LiSu'; color: var(--dark-wood);">
                            <i class="ri-edit-box-line"></i> 留墨宝
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label" style="font-family: 'KaiTi'; color: var(--dark-wood);">留言内容</label>
                            <textarea class="form-control" 
                                      v-model="newMessage" 
                                      rows="4" 
                                      placeholder="在此留下您的高见..."></textarea>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="form-check" v-if="currentUser.IsLogin">
                                <input type="checkbox" class="form-check-input" v-model="isAnonymous" id="chkAnonymous">
                                <label class="form-check-label" for="chkAnonymous" style="font-family: 'KaiTi'; color: #666;">
                                    匿名发表
                                </label>
                            </div>
                            <div v-else class="text-muted small" style="font-family: 'KaiTi';">
                                <i class="ri-information-line"></i> 未登录将强制匿名发表
                            </div>
                            <button class="btn ancient-btn" 
                                    @click="submitMessage" 
                                    :disabled="submitting || !newMessage.trim()">
                                {{ submitting ? '提交中...' : '提交留言' }}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. 留言列表区 -->
        <div class="row g-4">
            <div class="col-lg-8 offset-lg-2" v-for="(item, index) in messageList" :key="item.ID"
                 :class="index % 2 === 0 ? 'fly-in-left' : 'fly-in-right'"
                 :style="'animation-delay: ' + (index * 0.1) + 's;'">
                <div class="card paper-card message-card h-100">
                    <!-- 卡片头部 -->
                    <div class="card-header d-flex justify-content-between align-items-start" 
                         style="background: linear-gradient(180deg, #f8f3e9, #fff); border-bottom: 1px dashed #ccc;">
                        <div class="d-flex align-items-center">
                            <div class="user-avatar me-3" 
                                 :style="item.IsAnonymous ? 'background: #888;' : 'background: var(--ming-gold);'">
                                <i :class="item.IsAnonymous ? 'ri-user-unfollow-line' : 'ri-user-3-line'" 
                                   style="font-size: 1.2rem; color: #fff;"></i>
                            </div>
                            <div>
                                <div class="d-flex align-items-center flex-wrap gap-2">
                                    <h6 class="mb-0" style="font-family: 'KaiTi'; color: var(--dark-wood);">
                                        {{ item.NickName }}
                                    </h6>
                                    <!-- 置顶标识 -->
                                    <span v-if="item.IsTop" class="badge" style="background-color: var(--ming-red);">
                                        <i class="ri-fire-line"></i> 置顶
                                    </span>
                                    <!-- 匿名标识 -->
                                    <span v-if="item.IsAnonymous" class="badge" style="background-color: #666;">
                                        <i class="ri-eye-off-line"></i> 匿名
                                    </span>
                                    <!-- 删除按钮：只有自己的留言/管理员可见 -->
                                    <button v-if="canDelete(item)" 
                                            class="btn btn-sm btn-outline-danger"
                                            @click="deleteMessage(item.ID)"
                                            :disabled="deletingId === item.ID">
                                        {{ deletingId === item.ID ? '删除中...' : '删除' }}
                                    </button>
                                </div>
                                <small class="text-muted">
                                    <i class="ri-time-line"></i> {{ formatDate(item.CreateTime) }}
                                </small>
                            </div>
                        </div>
                    </div>

                    <!-- 卡片内容 -->
                    <div class="card-body">
                        <p class="mb-0" style="font-family: 'KaiTi'; font-size: 1.1rem; line-height: 1.8; color: #333; text-indent: 2em;">
                            {{ item.Content }}
                        </p>
                    </div>

                    <!-- 管理员回复区 -->
                    <div v-if="item.ReplyContent" class="card-footer" style="background: #fff9c4; border-top: 2px solid var(--ming-gold);">
                        <div class="d-flex align-items-start">
                            <div class="me-3">
                                <div class="user-avatar" style="background: var(--ming-red); width: 32px; height: 32px;">
                                    <i class="ri-shield-keyhole-line" style="font-size: 1rem; color: #fff;"></i>
                                </div>
                            </div>
                            <div class="flex-grow-1 w-100">
                                <div class="d-flex justify-content-between align-items-center mb-1 flex-wrap gap-2">
                                    <span class="fw-bold" style="font-family: 'LiSu'; color: var(--ming-red);">
                                        <i class="ri-empress-line"></i> 管理员回复
                                    </span>
                                    <div class="d-flex align-items-center gap-2">
                                        <small class="text-muted">
                                            <i class="ri-time-line"></i> {{ formatDate(item.ReplyTime) }}
                                        </small>
                                        <!-- 管理员删除回复按钮 -->
                                        <button v-if="currentUser.IsAdmin" 
                                                class="btn btn-sm btn-outline-danger"
                                                @click="deleteReply(item.ID)">
                                            删除回复
                                        </button>
                                    </div>
                                </div>
                                <p class="mb-0" style="font-family: 'KaiTi'; color: #333;">
                                    {{ item.ReplyContent }}
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- 管理员回复输入框：只有管理员可见 -->
                    <div v-if="currentUser.IsAdmin" class="card-footer" style="background: #f8f9fa; border-top: 1px dashed #ccc;">
                        <div class="mb-2">
                            <label class="form-label" style="font-family: 'LiSu'; color: var(--dark-wood);">
                                <i class="ri-reply-line"></i> 回复此留言
                            </label>
                            <textarea class="form-control" 
                                      v-model="replyMap[item.ID]" 
                                      rows="2" 
                                      :placeholder="item.ReplyContent ? '编辑回复内容...' : '输入回复内容...'"></textarea>
                        </div>
                        <div class="d-flex justify-content-end">
                            <button class="btn btn-sm ancient-btn" 
                                    @click="submitReply(item.ID)"
                                    :disabled="!replyMap[item.ID].trim()">
                                {{ item.ReplyContent ? '更新回复' : '提交回复' }}
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 加载中提示 -->
        <div v-if="loading" class="text-center py-5">
            <div class="spinner-border" style="color: var(--ming-red);" role="status">
                <span class="visually-hidden">加载中...</span>
            </div>
            <p class="mt-2 text-muted" style="font-family: 'KaiTi';">正在加载留言...</p>
        </div>

        <!-- 无数据提示 -->
        <div v-if="!loading && messageList.length === 0" class="text-center py-5 text-muted">
            <i class="ri-inbox-line" style="font-size: 3rem;"></i>
            <p class="mt-2" style="font-family: 'KaiTi';">暂无留言，快来抢沙发吧！</p>
        </div>

    </div>

    <!-- Vue3 逻辑脚本 -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const { createApp, ref, reactive, onMounted } = Vue;

            createApp({
                setup() {
                    // 核心数据
                    const messageList = ref([]);
                    const newMessage = ref('');
                    const isAnonymous = ref(false);
                    const replyMap = reactive({}); // 存储每个留言的回复内容

                    // 状态控制
                    const loading = ref(true);
                    const submitting = ref(false);
                    const deletingId = ref(0);

                    // 当前用户信息（权限判断用）
                    const currentUser = ref({
                        UserID: 0,
                        NickName: '',
                        IsAdmin: false,
                        IsLogin: false
                    });

                    // 格式化时间
                    const formatDate = (dateStr) => {
                        if (!dateStr) return '';
                        const d = new Date(dateStr);
                        return d.getFullYear() + '年' + (d.getMonth() + 1) + '月' + d.getDate() + '日 ' +
                            d.getHours().toString().padStart(2, '0') + ':' +
                            d.getMinutes().toString().padStart(2, '0');
                    };

                    // 权限判断：是否可以删除此留言
                    const canDelete = (item) => {
                        if (!currentUser.value.IsLogin) return false;
                        // 管理员可以删所有
                        if (currentUser.value.IsAdmin) return true;
                        // 普通用户只能删自己的非匿名留言
                        return item.UserID === currentUser.value.UserID && !item.IsAnonymous;
                    };

                    // ==========================================
                    // API 调用方法
                    // ==========================================
                    // 1. 获取当前用户信息
                    const loadUserInfo = async () => {
                        try {
                            const res = await fetch('MessageBoard.aspx/GetCurrentUserInfo', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json; charset=utf-8' }
                            });
                            const data = await res.json();
                            if (data.d) {
                                currentUser.value = JSON.parse(data.d);
                            }
                        } catch (err) {
                            console.error('获取用户信息失败', err);
                        }
                    };

                    // 2. 加载留言列表
                    const loadMessages = async () => {
                        loading.value = true;
                        try {
                            const res = await fetch('MessageBoard.aspx/GetMessages', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json; charset=utf-8' }
                            });
                            const data = await res.json();
                            if (data.d) {
                                messageList.value = JSON.parse(data.d);
                                // 初始化回复输入框的内容
                                messageList.value.forEach(item => {
                                    replyMap[item.ID] = item.ReplyContent || '';
                                });
                            }
                        } catch (err) {
                            console.error('加载留言失败', err);
                            alert('加载留言失败，请刷新页面重试');
                        } finally {
                            loading.value = false;
                        }
                    };

                    // 3. 提交留言
                    const submitMessage = async () => {
                        if (!newMessage.value.trim()) return;
                        submitting.value = true;
                        try {
                            const res = await fetch('MessageBoard.aspx/SubmitMessage', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                                body: JSON.stringify({
                                    content: newMessage.value,
                                    isAnonymous: isAnonymous.value
                                })
                            });
                            const data = await res.json();
                            if (data.d === 'success') {
                                newMessage.value = '';
                                isAnonymous.value = false;
                                alert('留言发表成功！');
                                await loadMessages();
                            } else {
                                alert(data.d.replace('error:', ''));
                            }
                        } catch (err) {
                            console.error('提交失败', err);
                            alert('网络错误，请重试');
                        } finally {
                            submitting.value = false;
                        }
                    };

                    // 4. 删除留言
                    const deleteMessage = async (messageId) => {
                        if (!confirm('确定要删除此留言吗？此操作不可恢复！')) return;
                        deletingId.value = messageId;
                        try {
                            const res = await fetch('MessageBoard.aspx/DeleteMessage', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                                body: JSON.stringify({ messageId })
                            });
                            const data = await res.json();
                            if (data.d === 'success') {
                                alert('删除成功！');
                                await loadMessages();
                            } else {
                                alert(data.d.replace('error:', ''));
                            }
                        } catch (err) {
                            console.error('删除失败', err);
                            alert('网络错误，请重试');
                        } finally {
                            deletingId.value = 0;
                        }
                    };

                    // 5. 提交回复
                    const submitReply = async (messageId) => {
                        const content = replyMap[messageId]?.trim();
                        if (!content) return;
                        try {
                            const res = await fetch('MessageBoard.aspx/ReplyMessage', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                                body: JSON.stringify({ messageId, replyContent: content })
                            });
                            const data = await res.json();
                            if (data.d === 'success') {
                                alert('回复成功！');
                                await loadMessages();
                            } else {
                                alert(data.d.replace('error:', ''));
                            }
                        } catch (err) {
                            console.error('回复失败', err);
                            alert('网络错误，请重试');
                        }
                    };

                    // 6. 删除回复
                    const deleteReply = async (messageId) => {
                        if (!confirm('确定要删除此回复吗？')) return;
                        try {
                            const res = await fetch('MessageBoard.aspx/DeleteReply', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                                body: JSON.stringify({ messageId })
                            });
                            const data = await res.json();
                            if (data.d === 'success') {
                                alert('回复已删除！');
                                await loadMessages();
                            } else {
                                alert(data.d.replace('error:', ''));
                            }
                        } catch (err) {
                            console.error('删除回复失败', err);
                            alert('网络错误，请重试');
                        }
                    };

                    // 页面加载时执行
                    onMounted(async () => {
                        await loadUserInfo();
                        await loadMessages();
                    });

                    return {
                        messageList,
                        newMessage,
                        isAnonymous,
                        replyMap,
                        loading,
                        submitting,
                        deletingId,
                        currentUser,
                        formatDate,
                        canDelete,
                        submitMessage,
                        deleteMessage,
                        submitReply,
                        deleteReply
                    };
                }
            }).mount('#vue-app');
        });
    </script>

    <!-- 样式 -->
    <style>
        :root {
            --ming-red: #C41E3A;
            --ming-gold: #D4AF37;
            --paper-bg: #F5F0E6;
            --ink-black: #2C2C2C;
            --dark-wood: #5D4037;
        }

        .ancient-btn {
            background-color: var(--ming-red);
            color: #fff;
            border: 2px solid var(--ming-gold);
            border-radius: 4px;
            font-family: 'KaiTi';
            padding: 8px 25px;
            transition: all 0.3s;
        }
        .ancient-btn:hover:not(:disabled) {
            background-color: var(--dark-wood);
            color: var(--ming-gold);
            border-color: var(--dark-wood);
            letter-spacing: 2px;
        }
        .ancient-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .memorial-card, .message-card {
            background: #fff;
            border: 1px solid #e0d8c8;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            position: relative;
            overflow: hidden;
        }
        .memorial-card::before, .message-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 6px;
            background: linear-gradient(180deg, var(--ming-red), #8B0000);
        }
        .message-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(93, 64, 55, 0.15);
            border-color: var(--ming-gold);
            transition: all 0.3s;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: #fff;
            border: 2px solid #fff;
            overflow: hidden;
            flex-shrink: 0;
        }

        .form-control {
            border: 1px solid #ccc;
            border-radius: 4px;
            font-family: "KaiTi", "STKaiti", sans-serif;
            font-size: 1.05rem;
        }
        .form-control:focus {
            border-color: var(--ming-gold);
            box-shadow: 0 0 0 0.2rem rgba(212, 175, 55, 0.25);
        }

        /* 卡片飞入动画 */
        .fly-in-left {
            opacity: 0;
            transform: translateX(-50px);
            animation: flyFromLeft 0.6s ease-out forwards;
        }
        .fly-in-right {
            opacity: 0;
            transform: translateX(50px);
            animation: flyFromRight 0.6s ease-out forwards;
        }
        @keyframes flyFromLeft {
            to { opacity: 1; transform: translateX(0); }
        }
        @keyframes flyFromRight {
            to { opacity: 1; transform: translateX(0); }
        }
    </style>

</asp:Content>

