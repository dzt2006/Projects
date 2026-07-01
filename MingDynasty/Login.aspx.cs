using System;
using System.Linq;

public partial class Admin_Login : System.Web.UI.Page
{
    private readonly string DefaultAvatar = "~/upload/avatar_default.png";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session.Clear();
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string username = txtUserName.Text.Trim();
        string password = txtPwd.Text.Trim();

        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            litMsg.Text = "<div class='error-msg'>请输入账号和密码</div>";
            return;
        }

        using (var db = new MingDynastyDBEntities())
        {
            var user = db.MingUser.FirstOrDefault(u => u.UserName == username);
            if (user != null && PasswordHelper.VerifyPassword(password, user.Pwd))
            {
                if ((bool)!user.Status)
                {
                    litMsg.Text = "<div class='error-msg'>账号已被禁用，请联系管理员</div>";
                    return;
                }

                Session["UserID"] = user.ID;
                Session["UserName"] = user.UserName;
                Session["NickName"] = user.NickName;
                Session["Email"] = user.Email;
                Session["Avatar"] = !string.IsNullOrEmpty(user.Avatar) ? user.Avatar : DefaultAvatar;
                Session["IsAdmin"] = false;

                user.LastLoginTime = DateTime.Now;
                db.SaveChanges();

                Response.Redirect("~/Page/Index.aspx");
                return;
            }

            var admin = db.AdminUser.FirstOrDefault(a => a.UserName == username);
            if (admin != null && PasswordHelper.VerifyPassword(password, admin.Pwd))
            {
                Session["AdminID"] = admin.ID;
                Session["AdminName"] = admin.UserName;
                Session["IsAdmin"] = true;
                Response.Redirect("~/Admin/Index.aspx");
                return;
            }

            litMsg.Text = "<div class='error-msg'>账号或密码错误</div>";
        }
    }
}