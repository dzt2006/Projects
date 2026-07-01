using System;
using System.Web;
using System.Web.UI;

public partial class Page_Site : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CheckUserLoginStatus();
        CheckAndShowGlobalMessage();
    }

    private void CheckUserLoginStatus()
    {
        bool isLogin = (Session["UserID"] != null || Session["AdminID"] != null);

        if (isLogin)
        {
            plhAnonymous.Visible = false;
            plhUser.Visible = true;

            string nick = "用户";
            string avatar = "";
            bool isAdmin = false;

            if (Session["UserID"] != null)
            {
                nick = Session["NickName"]?.ToString() ?? "用户";
                avatar = Session["Avatar"]?.ToString();
                isAdmin = Convert.ToBoolean(Session["IsAdmin"] ?? false);
            }
            else if (Session["AdminID"] != null)
            {
                nick = Session["AdminName"]?.ToString() ?? "管理员";
                isAdmin = true;
            }

            litUserName.Text = nick;

            if (isAdmin)
            {
                litAvatar.Text = "<div class='user-avatar' style='background:#C41E3A'>管</div>";
                plhAdminMenu.Visible = true;
                plhUserMenu.Visible = false; // 管理员隐藏个人中心
            }
            else
            {
                if (!string.IsNullOrEmpty(avatar))
                    litAvatar.Text = $"<div class='user-avatar'><img src='{ResolveUrl(avatar)}' /></div>";
                else
                    // 统一使用指定默认头像，不再显示首字母
                    litAvatar.Text = $"<div class='user-avatar'><img src='{ResolveUrl("~/upload/avatar_default.png")}' /></div>";

                plhAdminMenu.Visible = false;
                plhUserMenu.Visible = true; // 普通用户显示个人中心
            }
        }
        else
        {
            plhAnonymous.Visible = true;
            plhUser.Visible = false;
        }
    }

    private void CheckAndShowGlobalMessage()
    {
        if (Session["GlobalMessage"] != null)
        {
            string msg = Session["GlobalMessage"].ToString();
            string type = Session["GlobalMessageType"]?.ToString() ?? "success";

            Session.Remove("GlobalMessage");
            Session.Remove("GlobalMessageType");

            string safeMsg = msg.Replace("'", "\\'");
            string script = $@"
                $(document).ready(function(){{
                    if(typeof Swal !== 'undefined'){{
                        Swal.fire({{icon:'{type}',title:'{safeMsg}',showConfirmButton:false,timer:1500}});
                    }}else{{
                        alert('{safeMsg}');
                    }}
                }});";

            ScriptManager.RegisterStartupScript(this, GetType(), "global_msg", script, true);
        }
    }

    protected void lbtnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1));
        Response.Cache.SetNoStore();
        Response.Redirect("~/Page/Index.aspx");
    }
}