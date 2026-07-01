<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>用户注册 - 大明纪事历史</title>
    <link rel="icon" type="image/x-icon" href="<%= ResolveUrl("~/favicon.ico") %>">
    <link href="<%= ResolveUrl("~/css/remixicon/remixicon.css") %>" rel="stylesheet">
    <style>
        :root {
            --paper: #FAF7F2;
            --wood: #D7CCC8;
            --cinnabar: #C41E3A; 
            --cinnabar-light: #E57373;
            --ink: #333;
            --ink-light: #666;
        }

        body {
            font-family: "KaiTi", "Microsoft YaHei", sans-serif;
            background-color: var(--paper);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .register-card {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            padding: 2rem 3rem;
            width: 400px;
            border: 1px solid var(--wood);
            border-top: 4px solid var(--cinnabar);
        }
        .card-title {
            font-family: "LiSu", "KaiTi", cursive;
            font-size: 1.8rem;
            color: var(--cinnabar);
            text-align: center;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        .form-group {
            margin-bottom: 1.2rem;
        }
        .form-label {
            font-weight: 500;
            color: var(--ink);
            margin-bottom: 0.3rem;
            display: block;
        }
        .form-control {
            width: 100%;
            padding: 0.6rem 0.8rem;
            border: 1px solid var(--wood);
            border-radius: 12px;
            font-size: 1rem;
            font-family: inherit;
            box-sizing: border-box;
            transition: all 0.2s ease;
            background: #fff;
        }
        .form-control:focus {
            outline: none;
            border-color: var(--cinnabar);
            box-shadow: 0 0 0 3px rgba(196, 30, 58, 0.1);
        }
        .validator-error {
            color: var(--cinnabar);
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: block;
        }
        .btn-register {
            width: 100%;
            background: var(--cinnabar);
            color: #fff;
            border: none;
            border-radius: 20px;
            padding: 0.7rem;
            font-size: 1.1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 0.5rem;
            font-family: inherit;
        }
        .btn-register:hover {
            background: var(--cinnabar-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(196, 30, 58, 0.2);
        }
        .login-link {
            text-align: center;
            margin-top: 1.2rem;
            color: var(--ink-light);
            font-size: 0.95rem;
        }
        .login-link a {
            color: var(--cinnabar);
            text-decoration: none;
            font-weight: 500;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
        .msg-panel {
            padding: 0.8rem 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .msg-error {
            background: rgba(196, 30, 58, 0.1);
            color: var(--cinnabar);
            border: 1px solid var(--cinnabar);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-card">
            <h2 class="card-title">
                <i class="ri-user-add-line"></i>
                用户注册
            </h2>

            <asp:Panel ID="pnlMsg" runat="server" CssClass="msg-panel msg-error" Visible="False">
                <asp:Label ID="lblMessage" runat="server" />
            </asp:Panel>

            <div class="form-group">
                <label class="form-label">用户名 <span style="color:var(--cinnabar);">*</span></label>
                <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" placeholder="请输入登录用户名" />
                <asp:RequiredFieldValidator ID="rfvUserName" runat="server" 
                    ControlToValidate="txtUserName" 
                    ErrorMessage="* 请输入用户名" 
                    CssClass="validator-error" 
                    Display="Dynamic" />
            </div>

            <div class="form-group">
                <label class="form-label">用户昵称</label>
                <asp:TextBox ID="txtNickName" runat="server" CssClass="form-control" placeholder="请输入昵称（不填默认与用户名一致）" />
            </div>

            <div class="form-group">
                <label class="form-label">登录密码 <span style="color:var(--cinnabar);">*</span></label>
                <asp:TextBox ID="txtPwd" runat="server" CssClass="form-control" TextMode="Password" placeholder="请输入登录密码" />
                <asp:RequiredFieldValidator ID="rfvPwd" runat="server" 
                    ControlToValidate="txtPwd" 
                    ErrorMessage="* 请输入密码" 
                    CssClass="validator-error" 
                    Display="Dynamic" />
            </div>

            <div class="form-group">
                <label class="form-label">确认密码 <span style="color:var(--cinnabar);">*</span></label>
                <asp:TextBox ID="txtConfirmPwd" runat="server" CssClass="form-control" TextMode="Password" placeholder="请再次输入密码" />
                <asp:RequiredFieldValidator ID="rfvConfirmPwd" runat="server" 
                    ControlToValidate="txtConfirmPwd" 
                    ErrorMessage="* 请确认密码" 
                    CssClass="validator-error" 
                    Display="Dynamic" />
                <asp:CompareValidator ID="cvPwd" runat="server" 
                    ControlToCompare="txtPwd" 
                    ControlToValidate="txtConfirmPwd" 
                    ErrorMessage="* 两次密码输入不一致" 
                    CssClass="validator-error" 
                    Display="Dynamic" />
            </div>

            <div class="form-group">
                <label class="form-label">联系邮箱</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="请输入邮箱（可选）" />
                <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                    ControlToValidate="txtEmail" 
                    ErrorMessage="* 请输入正确的邮箱格式" 
                    CssClass="validator-error" 
                    Display="Dynamic" 
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="立即注册" CssClass="btn-register" OnClick="btnRegister_Click" />

            <div class="login-link">
                已有账号？<a href="~/Login.aspx" runat="server">立即登录</a>
            </div>
        </div>
    </form>
</body>
</html>