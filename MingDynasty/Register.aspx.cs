using System;
using System.Linq;

public partial class Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        string userName = txtUserName.Text.Trim();
        string pwd = txtPwd.Text.Trim();
        string nickName = txtNickName.Text.Trim();
        string email = txtEmail.Text.Trim();

        using (var db = new MingDynastyDBEntities())
        {
            if (db.MingUser.Any(u => u.UserName == userName))
            {
                ShowError("用户名已存在");
                return;
            }

            MingUser newUser = new MingUser
            {
                UserName = userName,
                NickName = string.IsNullOrEmpty(nickName) ? userName : nickName,
                Pwd = PasswordHelper.HashPassword(pwd),
                Email = string.IsNullOrEmpty(email) ? null : email,
                Avatar = "~/upload/avatar_default.png",
                RegisterTime = DateTime.Now,
                LastLoginTime = null,
                Status = true
            };

            db.MingUser.Add(newUser);
            db.SaveChanges();

            Response.Redirect("Login.aspx");
        }
    }

    private void ShowError(string msg)
    {
        pnlMsg.Visible = true;
        lblMessage.Text = msg;
    }
}