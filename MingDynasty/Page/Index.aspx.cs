using System;
using System.Linq;

public partial class Page_Index : System.Web.UI.Page
{
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindHomePageData();
        }
    }

    private void BindHomePageData()
    {
        // 绑定轮播图
        var banners = _db.MingBanner.OrderBy(b => b.Sort).ToList();
        rptBanners.DataSource = banners;
        rptBanners.DataBind();
        rptBannerIndicators.DataSource = banners;
        rptBannerIndicators.DataBind();

        // 绑定最新更新
        var articles = _db.MingSystemArticle
                          .Where(a => a.IsShow == true)
                          .OrderByDescending(a => a.CreateTime)
                          .Take(5)
                          .ToList();
        rptLatestArticles.DataSource = articles;
        rptLatestArticles.DataBind();

        // 绑定热门帝王
        var emperors = _db.MingEmperor.OrderBy(e => e.Sort).Take(6).ToList();
        rptHotEmperors.DataSource = emperors;
        rptHotEmperors.DataBind();
    }
}