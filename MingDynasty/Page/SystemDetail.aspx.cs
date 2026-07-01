using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Page_SystemDetail : System.Web.UI.Page
{
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();

    // 定义全局变量供前端直接调用
    protected string ArticleTitle = "";
    protected string ArticleCategory = "";
    protected string ArticleContent = "";
    protected string ArticleTime = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDetail();
        }
    }

    private void LoadDetail()
    {
        int id = 0;
        if (int.TryParse(Request.QueryString["id"], out id))
        {
            var article = _db.MingSystemArticle.FirstOrDefault(s => s.ID == id);

            if (article != null)
            {
                // 赋值给 protected 变量，前端可以直接 <%= %> 输出
                ArticleTitle = article.Title;
                ArticleCategory = article.Category ?? "其他";
                ArticleContent = article.Content ?? "<p class='text-muted text-center'>暂无详细内容</p>";
                ArticleTime = article.CreateTime.HasValue
                    ? article.CreateTime.Value.ToString("yyyy年MM月dd日")
                    : "年代不详";
            }
            else
            {
                Response.Redirect("SystemList.aspx");
            }
        }
        else
        {
            Response.Redirect("SystemList.aspx");
        }
    }
}