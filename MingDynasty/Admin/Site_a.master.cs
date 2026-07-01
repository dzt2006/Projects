using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Admin_Site : System.Web.UI.MasterPage
{

    protected MingDynastyDBEntities db = new MingDynastyDBEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 1. 检查登录状态
            CheckLogin();
            // 2. 显示管理员名称（修复：展示Session信息）
            ShowAdminInfo();
        }
    }

    /// <summary>
    /// 检查用户是否已登录，未登录则跳转回登录页
    /// </summary>
    private void CheckLogin()
    {
        if (Session["AdminID"] == null)
        {
            Response.Redirect("~/Login.aspx");
        }
    }

    /// <summary>
    /// 【新增】显示管理员名称（从Session读取）
    /// </summary>
    private void ShowAdminInfo()
    {
        if (Session["AdminName"] != null)
        {
            // 你可以在前台加一个控件显示，这里先保证Session读取正常
            // litAdminName.Text = Session["AdminName"].ToString();
        }
    }

    /// <summary>
    /// 【修复】退出登录：必须清空Session！
    /// </summary>
    protected void lbtnLogout_Click(object sender, EventArgs e)
    {
        // 1. 清空所有Session（关键！）
        Session.Clear();
        Session.Abandon();

        // 2. 禁用浏览器缓存（防止回退）
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1));
        Response.Cache.SetNoStore();

        // 3. 跳转到首页
        Response.Redirect("~/Page/Index.aspx");
    }
}
