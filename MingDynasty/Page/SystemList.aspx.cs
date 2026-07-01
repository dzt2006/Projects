using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Page_SystemList : System.Web.UI.Page
{
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 获取分类参数
            string category = Request.QueryString["cat"];
            BindCategories(); // 绑定顶部分类
            BindArticles(category); // 绑定文章列表
        }
    }

    // 绑定分类按钮
    private void BindCategories()
    {
        var cats = _db.MingSystemArticle
                     .Where(s => s.IsShow == true)
                     .Select(s => s.Category)
                     .Distinct()
                     .ToList();

        // 手动插入一个“全部”在第一位
        rptCategories.DataSource = cats;
        rptCategories.DataBind();
    }

    // 绑定文章列表
    private void BindArticles(string category = null)
    {
        var query = _db.MingSystemArticle.Where(s => s.IsShow == true);

        // 如果有分类参数，就筛选
        if (!string.IsNullOrEmpty(category))
        {
            query = query.Where(s => s.Category == category);
        }

        var list = query.OrderByDescending(s => s.IsTop)
                       .ThenByDescending(s => s.CreateTime)
                       .ToList();

        rptArticles.DataSource = list;
        rptArticles.DataBind();
    }

    // 用于截取摘要的方法
    protected string GetSummary(object contentObj)
    {
        string content = contentObj?.ToString() ?? "";
        // 简单去除HTML
        string text = System.Text.RegularExpressions.Regex.Replace(content, "<[^>]+>", "");
        if (text.Length > 120) return text.Substring(0, 120) + "...";
        return text;
    }

    // 用于高亮当前分类
    protected string IsActiveClass(object catObj)
    {
        string currentCat = Request.QueryString["cat"];
        string thisCat = catObj?.ToString() ?? "";

        // 如果当前没选分类，且是第一项（假设是第一个），或者选中的等于当前项
        if (string.IsNullOrEmpty(currentCat) && string.IsNullOrEmpty(thisCat)) return "active";
        return currentCat == thisCat ? "active" : "";
    }
}