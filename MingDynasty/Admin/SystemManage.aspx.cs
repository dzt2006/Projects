using System;
using System.Linq;
using System.Web.UI.WebControls;

public partial class Admin_SystemManage : System.Web.UI.Page
{
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
            pnlEdit.Visible = false;
            pnlMsg.Visible = false;
        }
    }

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

    protected void BtnAddNew_Click(object sender, EventArgs e)
    {
        ClearForm();
        HideMessage();
        pnlEdit.Visible = true;
        litEditTitle.Text = "新增典章";
    }

    protected void BtnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
        pnlEdit.Visible = false;
        HideMessage();
    }

    private IQueryable<MingSystemArticle> GetQuery()
    {
        var query = _db.MingSystemArticle.AsQueryable();
        if (!string.IsNullOrEmpty(txtSearchTitle.Text.Trim()))
            query = query.Where(m => m.Title.Contains(txtSearchTitle.Text.Trim()));
        if (!string.IsNullOrEmpty(ddlSearchCategory.SelectedValue))
            query = query.Where(m => m.Category == ddlSearchCategory.SelectedValue);
        return query;
    }

    private void BindGrid()
    {
        var query = GetQuery();
        var dataList = query.OrderByDescending(m => m.IsTop).ThenByDescending(m => m.CreateTime).ToList();

        int totalCount = dataList.Count;
        int pageSize = gvSystem.PageSize;
        int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);
        int currentPage = gvSystem.PageIndex + 1;

        litTotalCount.Text = totalCount.ToString();
        litCurrentPage.Text = currentPage.ToString();
        litTotalPages.Text = totalPages.ToString();

        btnPrevPage.Enabled = !(currentPage <= 1);
        btnNextPage.Enabled = !(currentPage >= totalPages);

        gvSystem.DataSource = dataList;
        gvSystem.DataBind();
    }

    protected void btnPrevPage_Click(object sender, EventArgs e)
    {
        if (gvSystem.PageIndex > 0)
        {
            gvSystem.PageIndex--;
        }
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void btnNextPage_Click(object sender, EventArgs e)
    {
        var query = GetQuery();
        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / gvSystem.PageSize);

        if (gvSystem.PageIndex < totalPages - 1)
        {
            gvSystem.PageIndex++;
        }
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void BtnSearch_Click(object sender, EventArgs e)
    {
        gvSystem.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        ShowMessage("查询完成", false);
    }

    protected void BtnReset_Click(object sender, EventArgs e)
    {
        txtSearchTitle.Text = "";
        ddlSearchCategory.SelectedValue = "";
        gvSystem.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        HideMessage();
    }

    protected void GvSystem_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvSystem.PageIndex = e.NewPageIndex;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void GvSystem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);
        if (e.CommandName == "EditItem")
        {
            LoadData(id);
        }
        else if (e.CommandName == "DeleteItem")
        {
            DeleteData(id);
        }
    }

    private void LoadData(int id)
    {
        var article = _db.MingSystemArticle.FirstOrDefault(m => m.ID == id);
        if (article != null)
        {
            ViewState["EditId"] = id;
            hfEditId.Value = id.ToString();
            txtTitle.Text = article.Title;
            txtCategory.Text = article.Category;
            txtContent.Text = article.Content;
            chkIsTop.Checked = article.IsTop ?? false;
            chkIsShow.Checked = article.IsShow ?? true;

            pnlEdit.Visible = true;
            litEditTitle.Text = "编辑典章";
            HideMessage();
        }
    }

    private void DeleteData(int id)
    {
        var article = _db.MingSystemArticle.FirstOrDefault(m => m.ID == id);
        if (article != null)
        {
            _db.MingSystemArticle.Remove(article);
            _db.SaveChanges();
            BindGrid();
            ShowMessage("删除成功！", false);
        }
    }

    protected void BtnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int? editId = ViewState["EditId"] as int?;

        try
        {
            if (editId.HasValue)
            {
                var article = _db.MingSystemArticle.FirstOrDefault(m => m.ID == editId.Value);
                UpdateArticle(article);
                _db.SaveChanges();
                ShowMessage("修改成功！", false);
            }
            else
            {
                MingSystemArticle newArticle = new MingSystemArticle();
                UpdateArticle(newArticle);
                newArticle.CreateTime = DateTime.Now;
                _db.MingSystemArticle.Add(newArticle);
                _db.SaveChanges();
                ShowMessage("新增成功！", false);
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

    private void UpdateArticle(MingSystemArticle article)
    {
        article.Title = txtTitle.Text.Trim();
        article.Category = txtCategory.Text.Trim();
        article.Content = txtContent.Text.Trim();
        article.IsTop = chkIsTop.Checked;
        article.IsShow = chkIsShow.Checked;
    }

    private void ClearForm()
    {
        ViewState["EditId"] = null;
        hfEditId.Value = "";
        txtTitle.Text = txtCategory.Text = txtContent.Text = "";
        chkIsTop.Checked = false;
        chkIsShow.Checked = true;

        rfvTitle.IsValid = true;
        rfvCategory.IsValid = true;
        rfvContent.IsValid = true;
    }

    protected override void OnUnload(EventArgs e)
    {
        base.OnUnload(e);
        if (_db != null) _db.Dispose();
    }
}