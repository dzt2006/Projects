using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Page_CultureList : System.Web.UI.Page
{
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCategories();
            BindCultureList();
        }
    }

    #region 绑定分类导航
    private void BindCategories()
    {
        var categories = _db.MingCulture
                            .Select(c => c.Category)
                            .Distinct()
                            .Where(c => !string.IsNullOrEmpty(c))
                            .ToList();
        rptCategories.DataSource = categories;
        rptCategories.DataBind();
    }
    #endregion

    #region 绑定文化列表数据
    private void BindCultureList()
    {
        string currentCat = Request.QueryString["cat"];
        var query = _db.MingCulture.AsQueryable();

        if (!string.IsNullOrEmpty(currentCat))
        {
            query = query.Where(c => c.Category == currentCat);
        }

        var data = query.OrderBy(c => c.Sort)
                        .ThenByDescending(c => c.CreateTime)
                        .ToList();

        rptCultures.DataSource = data;
        rptCultures.DataBind();
    }
    #endregion

    #region 截取内容摘要
    protected string GetSummary(object contentObj)
    {
        string content = contentObj?.ToString() ?? "暂无简介";
        if (content.Length > 60)
        {
            return content.Substring(0, 60) + "...";
        }
        return content;
    }
    #endregion

    #region 分类选中状态判断
    protected string GetActiveClass(object catObj)
    {
        string currentCat = Request.QueryString["cat"];
        string cat = catObj?.ToString() ?? "";
        return currentCat == cat ? "active" : "";
    }
    #endregion


}