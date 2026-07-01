using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Page_EventTimeline : System.Web.UI.Page
{
    private static MingDynastyDBEntities _db = new MingDynastyDBEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
        // 完全交给前端渲染
    }
    // EventTimeline.aspx.cs
    [WebMethod]
    public static string GetEvents()
    {
        // 直接查询，不需要复杂映射
        var rawData = _db.MingEvent
                         .OrderBy(e => e.Sort)
                         .ThenBy(e => e.EventYear)
                         .ToList();

        var list = rawData.Select(e => new
        {
            id = e.ID,
            content = e.EventName,
            start = e.EventYear.HasValue ? e.EventYear.Value.ToString() + "-01-01" : "1368-01-01",
            // 【关键】直接用数据库里的 Period，因为你的数据本身就是对的！
            group = e.Period ?? "其他",
            title = GetSafeTitle(e.Content),
            fullContent = e.Content ?? "暂无详细记载",
            eventYear = e.EventYear
        }).ToList();

        return JsonConvert.SerializeObject(list);
    }

    // 辅助方法：安全截取标题
    private static string GetSafeTitle(string content)
    {
        if (string.IsNullOrEmpty(content)) return "点击查看详情...";
        if (content.Length <= 50) return content;
        return content.Substring(0, 50) + "...";
    }
}