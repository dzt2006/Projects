using System;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_EventManage : System.Web.UI.Page
{
    public MingDynastyDBEntities _db = new MingDynastyDBEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindEmpDropdown();
            BindGrid();
            pnlEdit.Visible = false;
            pnlMsg.Visible = false;
        }
    }

    // ✅ 关键修复：直接生成JavaScript代码，避免JSON序列化问题
    public string GetEmpYearScript()
    {
        StringBuilder sb = new StringBuilder();
        sb.AppendLine("empYearData = {");

        var empList = _db.MingEmperor
            .Where(m => !string.IsNullOrEmpty(m.ReignYears))
            .Select(m => new { m.ID, m.ReignYears })
            .ToList();

        foreach (var emp in empList)
        {
            var parts = emp.ReignYears.Split('-');
            string start = parts.Length > 0 ? parts[0].Trim() : "";
            string full = emp.ReignYears.Trim();

            sb.AppendLine($"    '{emp.ID}': {{ start: '{start}', full: '{full}' }},");
        }

        sb.AppendLine("};");
        return sb.ToString();
    }

    // 绑定关联帝王下拉框
    private void BindEmpDropdown()
    {
        var empList = _db.MingEmperor.OrderBy(m => m.Sort).ToList();
        ddlEmpID.DataSource = empList;
        ddlEmpID.DataTextField = "EmpName";
        ddlEmpID.DataValueField = "ID";
        ddlEmpID.DataBind();
    }

    #region 消息提示
    private void ShowMessage(string msg, bool isError)
    {
        lblMessage.Text = msg;
        pnlMsg.Visible = true;
        lblMessage.ForeColor = isError ? System.Drawing.Color.Red : System.Drawing.Color.Green;
    }

    private void HideMessage()
    {
        pnlMsg.Visible = false;
        lblMessage.Text = "";
    }
    #endregion

    #region 新增/取消按钮
    protected void BtnAddNew_Click(object sender, EventArgs e)
    {
        ClearForm();
        HideMessage();
        pnlEdit.Visible = true;
        litEditTitle.Text = "新增事件";
    }

    protected void BtnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
        pnlEdit.Visible = false;
        HideMessage();
    }
    #endregion

    #region 数据查询与绑定
    private IQueryable<EventViewModel> GetQuery()
    {
        var q = from e in _db.MingEvent
                join emp in _db.MingEmperor on e.EmpID equals emp.ID into empJoin
                from emp in empJoin.DefaultIfEmpty()
                select new EventViewModel
                {
                    ID = e.ID,
                    EventName = e.EventName,
                    EventYear = e.EventYear,
                    EmpName = emp.EmpName,
                    Period = e.Period,
                    Sort = e.Sort
                };

        if (!string.IsNullOrEmpty(txtSearchEventName.Text.Trim()))
            q = q.Where(m => m.EventName.Contains(txtSearchEventName.Text.Trim()));
        if (!string.IsNullOrEmpty(ddlSearchPeriod.SelectedValue))
            q = q.Where(m => m.Period == ddlSearchPeriod.SelectedValue);
        return q;
    }

    private void BindGrid()
    {
        var q = GetQuery();
        var list = q.OrderBy(m => m.Sort).ThenBy(m => m.EventYear).ToList();
        int total = list.Count;
        int size = gvEvent.PageSize;
        int pages = (int)Math.Ceiling(total * 1.0 / size);
        int curr = gvEvent.PageIndex + 1;

        litTotalCount.Text = total.ToString();
        litCurrentPage.Text = curr.ToString();
        litTotalPages.Text = pages.ToString();

        btnPrevPage.Enabled = curr > 1;
        btnNextPage.Enabled = curr < pages;

        gvEvent.DataSource = list;
        gvEvent.DataBind();
    }
    #endregion

    #region 分页
    protected void btnPrevPage_Click(object sender, EventArgs e)
    {
        if (gvEvent.PageIndex > 0)
            gvEvent.PageIndex--;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void btnNextPage_Click(object sender, EventArgs e)
    {
        var q = GetQuery();
        int total = q.Count();
        int pages = (int)Math.Ceiling(total * 1.0 / gvEvent.PageSize);
        if (gvEvent.PageIndex < pages - 1)
            gvEvent.PageIndex++;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void GvEvent_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvEvent.PageIndex = e.NewPageIndex;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }
    #endregion

    #region 搜索/重置
    protected void BtnSearch_Click(object sender, EventArgs e)
    {
        gvEvent.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        ShowMessage("查询完成", false);
    }

    protected void BtnReset_Click(object sender, EventArgs e)
    {
        txtSearchEventName.Text = "";
        ddlSearchPeriod.SelectedValue = "";
        gvEvent.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        HideMessage();
    }
    #endregion

    #region 列表操作（编辑/删除）
    protected void GvEvent_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);
        if (e.CommandName == "EditItem")
            LoadData(id);
        else if (e.CommandName == "DeleteItem")
            DeleteData(id);
    }

    private void LoadData(int id)
    {
        var m = _db.MingEvent.Find(id);
        if (m == null) return;

        ViewState["EditId"] = id;
        hfEditId.Value = id.ToString();
        txtEventName.Text = m.EventName;
        txtEventYear.Text = m.EventYear.ToString();
        ddlEmpID.SelectedValue = m.EmpID.ToString();
        ddlPeriod.SelectedValue = m.Period;
        txtSort.Text = m.Sort.ToString();
        txtContent.Text = m.Content;

        pnlEdit.Visible = true;
        litEditTitle.Text = "编辑事件";
        HideMessage();
    }

    private void DeleteData(int id)
    {
        var m = _db.MingEvent.Find(id);
        if (m == null) return;

        // 删除后自动重整排序
        int deletedSort = (int)m.Sort;
        _db.MingEvent.Remove(m);

        var toUpdate = _db.MingEvent.Where(x => x.Sort > deletedSort);
        foreach (var item in toUpdate) item.Sort -= 1;

        _db.SaveChanges();
        BindGrid();
        ShowMessage("删除成功", false);
    }
    #endregion

    #region 保存数据（含自动排序调整）
    protected void BtnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int? editId = ViewState["EditId"] as int?;
        int newSort;

        // 验证并修正排序值
        if (!int.TryParse(txtSort.Text, out newSort) || newSort < 1)
        {
            newSort = 1;
        }
        int totalCount = _db.MingEvent.Count();
        int maxAllowed = totalCount + 1;
        if (newSort > maxAllowed)
        {
            newSort = maxAllowed;
        }

        // 自动处理排序重复，使用事务确保数据一致性
        using (var transaction = _db.Database.BeginTransaction())
        {
            try
            {
                if (editId.HasValue)
                {
                    var oldModel = _db.MingEvent.Find(editId.Value);
                    if (oldModel.Sort != newSort)
                    {
                        if (newSort < oldModel.Sort)
                        {
                            // 往前挪：后面的序号+1
                            var toUpdate = _db.MingEvent.Where(x => x.Sort >= newSort && x.Sort < oldModel.Sort);
                            foreach (var item in toUpdate) item.Sort += 1;
                        }
                        else
                        {
                            // 往后挪：前面的序号-1
                            var toUpdate = _db.MingEvent.Where(x => x.Sort > oldModel.Sort && x.Sort <= newSort);
                            foreach (var item in toUpdate) item.Sort -= 1;
                        }
                    }
                }
                else
                {
                    // 新增：把 >= newSort 的序号都+1
                    var toUpdate = _db.MingEvent.Where(x => x.Sort >= newSort);
                    foreach (var item in toUpdate) item.Sort += 1;
                }
                _db.SaveChanges();
                transaction.Commit();
            }
            catch (Exception ex)
            {
                transaction.Rollback();
                ShowMessage("排序调整失败：" + ex.Message, true);
                return;
            }
        }

        try
        {
            if (editId.HasValue)
            {
                var model = _db.MingEvent.Find(editId.Value);
                UpdateModel(model);
                model.Sort = newSort;
                _db.SaveChanges();
                ShowMessage("修改成功", false);
            }
            else
            {
                MingEvent model = new MingEvent();
                UpdateModel(model);
                model.Sort = newSort;
                _db.MingEvent.Add(model);
                _db.SaveChanges();
                ShowMessage("新增成功", false);
            }

            BindGrid();
            ClearForm();
            pnlEdit.Visible = false;
        }
        catch (Exception ex)
        {
            ShowMessage("保存失败：" + ex.Message, true);
        }
    }

    private void UpdateModel(MingEvent m)
    {
        m.EventName = txtEventName.Text.Trim();
        m.EventYear = string.IsNullOrEmpty(txtEventYear.Text) ? null : (int?)int.Parse(txtEventYear.Text);
        m.EmpID = string.IsNullOrEmpty(ddlEmpID.SelectedValue) ? null : (int?)int.Parse(ddlEmpID.SelectedValue);
        m.Period = ddlPeriod.SelectedValue;
        m.Content = txtContent.Text.Trim();
    }
    #endregion

    #region 清空表单
    private void ClearForm()
    {
        ViewState["EditId"] = null;
        hfEditId.Value = "";
        // 清空输入框
        txtEventName.Text = txtEventYear.Text = txtContent.Text = "";
        // 重置下拉框
        ddlEmpID.SelectedIndex = 0;
        ddlPeriod.SelectedIndex = 0;
        // 新增默认放到最后
        int totalCount = _db.MingEvent.Count();
        txtSort.Text = (totalCount + 1).ToString();

        // 重置验证器
        rfvEventName.IsValid = rfvSort.IsValid = rfvContent.IsValid = true;
        cvEventYear.IsValid = cvSort.IsValid = true;

        // 隐藏年份提示
        ScriptManager.RegisterStartupScript(this, GetType(), "hideYearHint",
            "document.getElementById('spnYearHint').style.display='none';", true);
    }
    #endregion

    protected override void OnUnload(EventArgs e)
    {
        base.OnUnload(e);
        _db?.Dispose();
    }
}

public class EventViewModel
{
    public int ID { get; set; }
    public string EventName { get; set; }
    public int? EventYear { get; set; }
    public string EmpName { get; set; }
    public string Period { get; set; }
    public int? Sort { get; set; }
}