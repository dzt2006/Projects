<%@ Page Title="" Language="C#" MasterPageFile="~/Page/Site.master" AutoEventWireup="true" CodeFile="MyInfo.aspx.cs" Inherits="MyInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- 保存Tab状态，解决回发后Tab重置问题 -->
    <asp:HiddenField ID="hfActiveTab" runat="server" Value="info-tab" />

    <div class="container">
        <div class="row">
            <!-- 左侧：头像设置 -->
            <div class="col-md-4 mb-4">
                <div class="paper-card p-4">
                    <h4 class="mb-3" style="color: #C41E3A; border-bottom: 2px solid #D4AF37; padding-bottom: 10px;">
                        <i class="ri-user-settings-line"></i> 头像设置
                    </h4>
                    
                    <!-- 头像预览区域 -->
                    <div class="text-center mb-3">
                        <asp:Image ID="imgAvatarPreview" runat="server" 
                            CssClass="img-thumbnail" 
                            Style="width: 200px; height: 200px; object-fit: cover; border: 3px solid #D4AF37;"
                            ImageUrl="~/images/default-avatar.png" />
                    </div>

                    <!-- 头像上传控件 -->
                    <div class="mb-3">
                        <asp:FileUpload ID="fuAvatar" runat="server" CssClass="form-control" accept="image/*" />
                        <small class="text-muted">支持 JPG、PNG 格式，大小不超过 2MB</small>
                    </div>

                    <asp:Button ID="btnSaveAvatar" runat="server" Text="保存头像" 
                        CssClass="btn w-100" 
                        Style="background-color: #C41E3A; color: #fff;"
                        OnClick="btnSaveAvatar_Click" />
                </div>
            </div>

            <!-- 右侧：Tab 切换区域 -->
            <div class="col-md-8">
                <div class="paper-card p-4">
                    <!-- Tab 导航：纯白底色、黑字、无任何下划线/边框 -->
                    <ul class="nav nav-tabs mb-4" id="myTab" role="tablist" style="border-bottom: none; background:#fff;">
                        <li class="nav-item" role="presentation">
                            <!-- 默认加active类，页面加载直接激活 -->
                            <button class="nav-link active" id="info-tab" data-bs-toggle="tab" data-bs-target="#info-tab-pane" type="button" role="tab" aria-controls="info-tab-pane" aria-selected="true"
                                style="color: #000; font-size: 1.1rem; padding: 0.5rem 1rem; border: none; background: #fff;">
                                <i class="ri-edit-box-line"></i> 基本资料
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="pwd-tab" data-bs-toggle="tab" data-bs-target="#pwd-tab-pane" type="button" role="tab" aria-controls="pwd-tab-pane" aria-selected="false"
                                style="color: #000; font-size: 1.1rem; padding: 0.5rem 1rem; border: none; background: #fff;">
                                <i class="ri-lock-password-line"></i> 修改密码
                            </button>
                        </li>
                    </ul>

                    <!-- Tab 内容 -->
                    <div class="tab-content" id="myTabContent">
                        <!-- 内容 1：基本资料 默认加active show，页面加载直接显示 -->
                        <div class="tab-pane fade active show" id="info-tab-pane" role="tabpanel" aria-labelledby="info-tab" tabindex="0">
                            <!-- 基本资料专属验证提示 -->
                            <asp:ValidationSummary ID="valSummaryInfo" runat="server" 
                                ValidationGroup="InfoGroup"
                                CssClass="alert mb-3" 
                                HeaderText="请修正以下错误：" 
                                DisplayMode="BulletList"
                                style="color: #000; background: #fff; border: 1px solid #dc3545;" />

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label" style="color: #000;">用户名（不可修改）</label>
                                    <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" Enabled="false" />
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label" style="color: #000;">昵称  </label>
                                    <asp:TextBox ID="txtNickName" runat="server" CssClass="form-control" ValidationGroup="InfoGroup" />
                                    <asp:RequiredFieldValidator ID="rfvNickName" runat="server" 
                                        ControlToValidate="txtNickName" ErrorMessage="请输入昵称" 
                                        CssClass="text-danger" Display="Dynamic"
                                        ValidationGroup="InfoGroup" />
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label" style="color: #000;">邮箱</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" ValidationGroup="InfoGroup" />
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                                    ControlToValidate="txtEmail" ErrorMessage="请输入正确的邮箱格式" 
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                    CssClass="text-danger" Display="Dynamic"
                                    ValidationGroup="InfoGroup" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label" style="color: #000;">注册时间</label>
                                <asp:TextBox ID="txtRegisterTime" runat="server" CssClass="form-control" Enabled="false" />
                            </div>

                            <asp:Button ID="btnSaveInfo" runat="server" Text="保存资料" 
                                CssClass="btn" 
                                Style="background-color: #D4AF37; color: #000;"
                                OnClick="btnSaveInfo_Click"
                                ValidationGroup="InfoGroup" />
                        </div>

                        <!-- 内容 2：修改密码 -->
                        <div class="tab-pane fade" id="pwd-tab-pane" role="tabpanel" aria-labelledby="pwd-tab" tabindex="0">
                            <!-- 修改密码专属验证提示 -->
                            <asp:ValidationSummary ID="valSummaryPwd" runat="server" 
                                ValidationGroup="PwdGroup"
                                CssClass="alert mb-3" 
                                HeaderText="请修正以下错误：" 
                                DisplayMode="BulletList"
                                style="color: #000; background: #fff; border: 1px solid #dc3545;" />

                            <div class="mb-3">
                                <label class="form-label" style="color: #000;">当前密码  </label>
                                <asp:TextBox ID="txtOldPwd" runat="server" CssClass="form-control" TextMode="Password" ValidationGroup="PwdGroup" />
                                <asp:RequiredFieldValidator ID="rfvOldPwd" runat="server" 
                                    ControlToValidate="txtOldPwd" ErrorMessage="请输入当前密码" 
                                    CssClass="text-danger" Display="Dynamic"
                                    ValidationGroup="PwdGroup" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label" style="color: #000;">新密码  </label>
                                <asp:TextBox ID="txtNewPwd" runat="server" CssClass="form-control" TextMode="Password" ValidationGroup="PwdGroup" />
                                <asp:RequiredFieldValidator ID="rfvNewPwd" runat="server" 
                                    ControlToValidate="txtNewPwd" ErrorMessage="请输入新密码" 
                                    CssClass="text-danger" Display="Dynamic"
                                    ValidationGroup="PwdGroup" />
                                <asp:RegularExpressionValidator ID="revNewPwd" runat="server" 
                                    ControlToValidate="txtNewPwd" ErrorMessage="密码长度至少6位" 
                                    ValidationExpression=".{6,}"
                                    CssClass="text-danger" Display="Dynamic"
                                    ValidationGroup="PwdGroup" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label" style="color: #000;">确认新密码  </label>
                                <asp:TextBox ID="txtConfirmPwd" runat="server" CssClass="form-control" TextMode="Password" ValidationGroup="PwdGroup" />
                                <asp:RequiredFieldValidator ID="rfvConfirmPwd" runat="server" 
                                    ControlToValidate="txtConfirmPwd" ErrorMessage="请确认新密码" 
                                    CssClass="text-danger" Display="Dynamic"
                                    ValidationGroup="PwdGroup" />
                                <asp:CompareValidator ID="cvConfirmPwd" runat="server" 
                                    ControlToCompare="txtNewPwd" ControlToValidate="txtConfirmPwd" 
                                    ErrorMessage="两次密码输入不一致"
                                    CssClass="text-danger" Display="Dynamic"
                                    ValidationGroup="PwdGroup" />
                            </div>

                            <asp:Button ID="btnSavePwd" runat="server" Text="修改密码并退出" 
                                CssClass="btn" 
                                Style="background-color: #C41E3A; color: #fff;"
                                OnClick="btnSavePwd_Click"
                                ValidationGroup="PwdGroup" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 头像预览 JS 原生实现，无依赖 -->
    <script>
        document.getElementById('<%= fuAvatar.ClientID %>').addEventListener('change', function (e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (event) {
                    document.getElementById('<%= imgAvatarPreview.ClientID %>').src = event.target.result;
                };
                reader.readAsDataURL(file);
            }
        });
    </script>

    <!-- Tab 状态保持 原生JS实现，彻底移除jQuery依赖，解决$未定义报错 -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // 获取隐藏域和所有Tab按钮
            const hfActiveTab = document.getElementById('<%= hfActiveTab.ClientID %>');
            const tabButtons = document.querySelectorAll('button[data-bs-toggle="tab"]');

            // 1. 页面加载时，恢复保存的Tab状态
            const activeTabId = hfActiveTab.value;
            if (activeTabId) {
                const targetTab = document.getElementById(activeTabId);
                if (targetTab && bootstrap.Tab) {
                    new bootstrap.Tab(targetTab).show();
                }
            }

            // 2. 点击Tab时，保存状态到隐藏域
            tabButtons.forEach(function (tabBtn) {
                tabBtn.addEventListener('shown.bs.tab', function (e) {
                    hfActiveTab.value = e.target.id;
                });
            });
        });
    </script>

    <!-- 全局样式：Tab样式+输入框聚焦样式全覆盖 -->
    <style>
        /* ========== Tab强制样式：纯白、黑字、无边框、无下划线 ========== */
        .nav-tabs {
            border: none !important;
            background: #fff !important;
        }
        .nav-tabs .nav-link {
            border: none !important;
            background: #fff !important;
            color: #000 !important;
        }
        /* 悬浮、聚焦、激活 全部无线条、无变色 */
        .nav-tabs .nav-link:hover,
        .nav-tabs .nav-link:focus,
        .nav-tabs .nav-link.active {
            border: none !important;
            border-bottom: none !important;
            background: #fff !important;
            color: #000 !important;
            outline: none !important;
            box-shadow: none !important;
        }

        /* ========== 输入框聚焦样式：替换默认蓝色，适配页面主题 ========== */
        /* 核心：覆盖Bootstrap默认的蓝色聚焦边框和阴影 */
        .form-control:focus {
            /* 边框颜色：改成页面主题酒红色，可自行修改色值 */
            border-color: #C41E3A !important;
            /* 聚焦阴影：改成同色系半透明，去掉蓝色，不需要阴影直接写none */
            box-shadow: 0 0 0 0.25rem rgba(196, 30, 58, 0.25) !important;
            /* 去掉默认轮廓线 */
            outline: none !important;
        }
        /* 禁用状态的输入框保持灰色，不被覆盖 */
        .form-control:disabled:focus {
            border-color: #ced4da !important;
            box-shadow: none !important;
        }

        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
        }
    </style>
</asp:Content>