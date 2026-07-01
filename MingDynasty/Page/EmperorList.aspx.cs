using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Page_EmperorList : System.Web.UI.Page
{

    private MingDynastyDBEntities _db = new MingDynastyDBEntities();

    // 前端数据模型
    public class EmperorViewModel
    {
        public int ID { get; set; }
        public string TempleName { get; set; } // 庙号
        public string ReignTitle { get; set; } // 年号
        public string EmpName { get; set; }    // 姓名 
        public string ReignYears { get; set; } // 在位时间
        public string Avatar { get; set; }     // 头像
        public string Intro { get; set; }      // 简介
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindEmperorDataToVue();
        }
    }

    private void BindEmperorDataToVue()
    {
        // 1. 从数据库读取数据
        var dataFromDb = _db.MingEmperor
                             .OrderBy(e => e.Sort)
                             .ToList()
                             .Select(e => new EmperorViewModel
                             {
                                 ID = e.ID,
                                 TempleName = e.TempleName,
                                 ReignTitle = e.ReignTitle,
                                 EmpName = e.EmpName,
                                 ReignYears = e.ReignYears,
                                 Avatar = string.IsNullOrEmpty(e.Avatar) ? "" : ResolveUrl(e.Avatar),
                                 Intro = e.Intro ?? "暂无简介"
                             })
                             .ToList();

        // 2. 序列化为 JSON
        string jsonStr = JsonConvert.SerializeObject(dataFromDb);

        // 3. 注入到前端
        string script = $"<script>var emperorData = {jsonStr};</script>";
        ClientScript.RegisterStartupScript(this.GetType(), "data", script);
    }
}