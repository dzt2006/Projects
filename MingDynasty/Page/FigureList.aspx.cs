using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

public partial class Page_FigureList : System.Web.UI.Page
{
    // 数据库实体
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            // 获取URL分类参数
            string category = Request.QueryString["cat"];
            // 绑定顶部分类按钮（Repeater）
            BindCategories();
            // 绑定人物数据 → 转为JSON注入前端，供Vue使用
            BindFigureDataToVue(category);
        }
    }

    /// <summary>
    /// 绑定顶部分类导航（保留原Repeater逻辑）
    /// </summary>
    private void BindCategories()
    {
        var cats = _db.MingFigure
                     .Where(f => !string.IsNullOrEmpty(f.Category))
                     .Select(f => f.Category)
                     .Distinct()
                     .OrderBy(f => f)
                     .ToList();

        rptCategories.DataSource = cats;
        rptCategories.DataBind();
    }

    /// <summary>
    /// 查询人物数据，转为JSON注入前端，供Vue渲染
    /// </summary>
    private void BindFigureDataToVue(string category = null)
    {
        // 基础查询
        var query = _db.MingFigure.AsQueryable();

        // URL分类筛选
        if (!string.IsNullOrEmpty(category))
        {
            query = query.Where(f => f.Category == category);
        }

        // 排序
        var list = query.OrderBy(f => f.Sort)
                       .ThenBy(f => f.ID)
                       .ToList();

        // 处理头像路径（适配网站根目录）
        var result = list.Select(f => new
        {
            f.ID,
            f.Name,
            f.Category,
            f.BirthYear,
            f.DeathYear,
            f.IdentityTitle,
            f.Achievement,
            // 自动解析头像正确路径
            Avatar = string.IsNullOrEmpty(f.Avatar) ? "" : ResolveUrl(f.Avatar),
            Intro = f.Intro ?? "暂无详细介绍"
        }).ToList();

        // 序列化为JSON，注入到window.figureData
        string jsonData = JsonConvert.SerializeObject(result);
        string script = $"<script>window.figureData = {jsonData};</script>";
        ClientScript.RegisterStartupScript(this.GetType(), "figureData", script);
    }

    /// <summary>
    /// 分类按钮激活状态（适配前端）
    /// </summary>
    protected string GetActiveClass(object catObj)
    {
        string currentCat = Request.QueryString["cat"];
        string thisCat = catObj?.ToString() ?? "";
        return currentCat == thisCat ? "active" : "";
    }

}