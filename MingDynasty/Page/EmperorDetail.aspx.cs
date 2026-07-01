using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Page_EmperorDetail : System.Web.UI.Page
{
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();

    // 详情页数据模型
    public class EmperorDetailVM
    {
        public int ID { get; set; }
        public string TempleName { get; set; }
        public string ReignTitle { get; set; }
        public string EmpName { get; set; }
        public string ReignYears { get; set; }
        public string Intro { get; set; }
        public string Period { get; set; } // 时期
        public string Avatar { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadEmperorDetail();
        }
    }

    private void LoadEmperorDetail()
    {
        // 1. 获取 URL 参数 id
        int id = 0;
        if (int.TryParse(Request.QueryString["id"], out id))
        {
            // 2. 查数据库
            var emperor = _db.MingEmperor.FirstOrDefault(e => e.ID == id);

            if (emperor != null)
            {
                // 3. 组装数据
                var vm = new EmperorDetailVM
                {
                    ID = emperor.ID,
                    TempleName = emperor.TempleName,
                    ReignTitle = emperor.ReignTitle,
                    EmpName = emperor.EmpName,
                    ReignYears = emperor.ReignYears,
                    Intro = emperor.Intro ?? "暂无详细记载",
                    Period = emperor.Period ?? "明朝",
                    Avatar = string.IsNullOrEmpty(emperor.Avatar) ? "" : ResolveUrl(emperor.Avatar)
                };

                // 4. 转 JSON 注入前端
                string json = JsonConvert.SerializeObject(vm);
                string script = $"<script>var emperorDetail = {json};</script>";
                ClientScript.RegisterStartupScript(this.GetType(), "data", script);
            }
            else
            {
                // 找不到数据，跳转回列表页
                Response.Redirect("EmperorList.aspx");
            }
        }
        else
        {
            // 没有 ID 参数，跳转回列表页
            Response.Redirect("EmperorList.aspx");
        }
    }
}