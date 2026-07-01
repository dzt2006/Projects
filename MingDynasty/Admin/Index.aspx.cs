using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;

public partial class Admin_Index : System.Web.UI.Page
{
    // 数据库上下文
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();

    // 公开属性供前端使用
    public int EmperorCount { get; set; }
    public int EventCount { get; set; }
    public int FigureCount { get; set; }
    public int MessageCount { get; set; }
    public int SystemArticleCount { get; set; }
    public int CultureCount { get; set; }

    // 图表数据JSON
    public string ReignChartData { get; set; }
    public string PeriodChartData { get; set; }
    public string ContentChartData { get; set; }
    public string MessageTrendData { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDashboardData();
        }
    }

    private void LoadDashboardData()
    {
        // 1. 基础数据统计
        EmperorCount = _db.MingEmperor.Count();
        EventCount = _db.MingEvent.Count();
        FigureCount = _db.MingFigure.Count();
        MessageCount = _db.MingMessage.Count();
        SystemArticleCount = _db.MingSystemArticle.Count();
        CultureCount = _db.MingCulture.Count();

        // 2. 皇帝在位时长排行数据
        var emperorsRaw = _db.MingEmperor
            .OrderBy(e => e.Sort)
            .Select(e => new
            {
                name = e.TempleName ?? e.EmpName,
                reignYears = e.ReignYears
            })
            .ToList();

        var emperors = emperorsRaw
            .Select(e => new
            {
                name = e.name,
                years = ParseReignYears(e.reignYears)
            })
            .OrderByDescending(e => e.years)
            .ToList();

        ReignChartData = new JavaScriptSerializer().Serialize(emperors);

        // 3. 历史事件时期分布数据
        var periodData = _db.MingEvent
            .Where(e => !string.IsNullOrEmpty(e.Period))
            .GroupBy(e => e.Period)
            .Select(g => new { name = g.Key, value = g.Count() })
            .ToList();

        PeriodChartData = new JavaScriptSerializer().Serialize(periodData);

        // 4. 内容类型数量统计
        var contentData = new[]
        {
            new { name = "帝王", value = EmperorCount },
            new { name = "事件", value = EventCount },
            new { name = "名臣", value = FigureCount },
            new { name = "典章", value = SystemArticleCount },
            new { name = "文化", value = CultureCount }
        };

        ContentChartData = new JavaScriptSerializer().Serialize(contentData);

        // 5. 近7天留言趋势
        var messagesRaw = _db.MingMessage
            .Select(m => m.CreateTime)
            .ToList();

        var messageTrend = new[]
        {
            new { date = "周一", count = messagesRaw.Count(m => m.HasValue && m.Value.DayOfWeek == DayOfWeek.Monday) },
            new { date = "周二", count = messagesRaw.Count(m => m.HasValue && m.Value.DayOfWeek == DayOfWeek.Tuesday) },
            new { date = "周三", count = messagesRaw.Count(m => m.HasValue && m.Value.DayOfWeek == DayOfWeek.Wednesday) },
            new { date = "周四", count = messagesRaw.Count(m => m.HasValue && m.Value.DayOfWeek == DayOfWeek.Thursday) },
            new { date = "周五", count = messagesRaw.Count(m => m.HasValue && m.Value.DayOfWeek == DayOfWeek.Friday) },
            new { date = "周六", count = messagesRaw.Count(m => m.HasValue && m.Value.DayOfWeek == DayOfWeek.Saturday) },
            new { date = "周日", count = messagesRaw.Count(m => m.HasValue && m.Value.DayOfWeek == DayOfWeek.Sunday) }
        };

        MessageTrendData = new JavaScriptSerializer().Serialize(messageTrend);
    }

    // 辅助方法：解析在位年数字符串
    private int ParseReignYears(string reignYears)
    {
        if (string.IsNullOrEmpty(reignYears)) return 0;
        try
        {
            var parts = reignYears.Split('-');
            if (parts.Length == 2 && int.TryParse(parts[0], out int start) && int.TryParse(parts[1], out int end))
            {
                return end - start;
            }
        }
        catch { }
        return 0;
    }

}