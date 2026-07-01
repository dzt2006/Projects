<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Admin_Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - 大明纪事历史</title>
    <link rel="icon" type="image/x-icon" href="<%= ResolveUrl("~/favicon.ico") %>">
    <link href="<%= ResolveUrl("~/css/bootstrap.min.css") %>" rel="stylesheet">
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
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        .login-box {
            background: #fff;
            width: 100%;
            max-width: 400px;
            padding: 2rem 3rem;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            border: 1px solid var(--wood);
            border-top: 4px solid var(--cinnabar);
        }

        .login-title {
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

        .form-control {
            height: 50px;
            border-radius: 12px;
            border: 1px solid var(--wood);
            padding-left: 2.8rem;
            font-family: inherit;
            font-size: 1rem;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--cinnabar);
            box-shadow: 0 0 0 3px rgba(196, 30, 58, 0.1);
        }

        .input-group-text {
            background: transparent;
            border: none;
            color: var(--cinnabar);
            position: absolute;
            left: 0.8rem;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            font-size: 1.1rem;
        }

        .btn-login {
            width: 100%;
            height: 50px;
            background: var(--cinnabar);
            color: #fff;
            border: none;
            border-radius: 20px;
            font-size: 1.1rem;
            font-family: "KaiTi", "Microsoft YaHei", sans-serif;
            letter-spacing: 2px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .btn-login:hover {
            background: var(--cinnabar-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(196, 30, 58, 0.2);
        }

        .links {
            text-align: center;
            margin-top: 1.2rem;
            color: var(--ink-light);
            font-size: 0.95rem;
        }

        .links a {
            color: var(--cinnabar);
            text-decoration: none;
            font-weight: 500;
        }

        .links a:hover {
            text-decoration: underline;
        }

        .error-msg {
            color: var(--cinnabar);
            text-align: center;
            margin-top: 1rem;
            font-size: 0.95rem;
            padding: 0.8rem 1rem;
            border-radius: 12px;
            background: rgba(196, 30, 58, 0.1);
            border: 1px solid var(--cinnabar);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-box">
            <div class="login-title">
                <i class="ri-empress-line"></i> 大明登录
            </div>

            <div class="form-group mb-3 position-relative">
                <span class="input-group-text"><i class="ri-user-line"></i></span>
                <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" placeholder="请输入账号"></asp:TextBox>
            </div>

            <div class="form-group mb-4 position-relative">
                <span class="input-group-text"><i class="ri-lock-line"></i></span>
                <asp:TextBox ID="txtPwd" runat="server" CssClass="form-control" placeholder="请输入密码" TextMode="Password"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="登 录" CssClass="btn-login" OnClick="btnLogin_Click" />
            
            <div class="links">
                还没有账号？<a href="<%= ResolveUrl("~/Register.aspx") %>">立即注册</a>
            </div>

            <asp:Literal ID="litMsg" runat="server"></asp:Literal>
        </div>
    </form>
</body>
</html>