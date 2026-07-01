using System;
using System.Linq;
using System.Web.UI.WebControls;

public partial class Admin_MessageManage : System.Web.UI.Page
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

    protected void BtnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
        pnlEdit.Visible = false;
        HideMessage();
    }

    private IQueryable<MingMessage> GetQuery()
    {
        var query = _db.MingMessage.AsQueryable();
        if (!string.IsNullOrEmpty(txtSearchNickName.Text.Trim()))
            query = query.Where(m => m.NickName.Contains(txtSearchNickName.Text.Trim()));
        if (!string.IsNullOrEmpty(txtSearchContent.Text.Trim()))
            query = query.Where(m => m.Content.Contains(txtSearchContent.Text.Trim()));
        return query;
    }

    private void BindGrid()
    {
        var query = GetQuery();
        var dataList = query.OrderByDescending(m => m.CreateTime).ToList();

        int totalCount = dataList.Count;
        int pageSize = gvMessage.PageSize;
        int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);
        int currentPage = gvMessage.PageIndex + 1;

        litTotalCount.Text = totalCount.ToString();
        litCurrentPage.Text = currentPage.ToString();
        litTotalPages.Text = totalPages.ToString();

        btnPrevPage.Enabled = !(currentPage <= 1);
        btnNextPage.Enabled = !(currentPage >= totalPages);

        gvMessage.DataSource = dataList;
        gvMessage.DataBind();
    }

    protected void btnPrevPage_Click(object sender, EventArgs e)
    {
        if (gvMessage.PageIndex > 0)
        {
            gvMessage.PageIndex--;
        }
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void btnNextPage_Click(object sender, EventArgs e)
    {
        var query = GetQuery();
        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / gvMessage.PageSize);

        if (gvMessage.PageIndex < totalPages - 1)
        {
            gvMessage.PageIndex++;
        }
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void BtnSearch_Click(object sender, EventArgs e)
    {
        gvMessage.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        ShowMessage("查询完成", false);
    }

    protected void BtnReset_Click(object sender, EventArgs e)
    {
        txtSearchNickName.Text = "";
        txtSearchContent.Text = "";
        gvMessage.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        HideMessage();
    }

    protected void GvMessage_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvMessage.PageIndex = e.NewPageIndex;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void GvMessage_RowCommand(object sender, GridViewCommandEventArgs e)
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
        var msg = _db.MingMessage.FirstOrDefault(m => m.ID == id);
        if (msg != null)
        {
            ViewState["EditId"] = id;
            hfEditId.Value = id.ToString();
            txtNickName.Text = msg.NickName;
            txtContent.Text = msg.Content;
            txtReplyContent.Text = msg.ReplyContent;
            chkIsTop.Checked = msg.IsTop ?? false;

            pnlEdit.Visible = true;
            HideMessage();
        }
    }

    private void DeleteData(int id)
    {
        var msg = _db.MingMessage.FirstOrDefault(m => m.ID == id);
        if (msg != null)
        {
            _db.MingMessage.Remove(msg);
            _db.SaveChanges();
            BindGrid();
            ShowMessage("删除成功！", false);
        }
    }

    protected void BtnSave_Click(object sender, EventArgs e)
    {
        int? editId = ViewState["EditId"] as int?;
        if (!editId.HasValue) return;

        try
        {
            var msg = _db.MingMessage.FirstOrDefault(m => m.ID == editId.Value);
            if (msg != null)
            {
                msg.ReplyContent = txtReplyContent.Text.Trim();
                msg.IsTop = chkIsTop.Checked;
                msg.ReplyTime = DateTime.Now;
                _db.SaveChanges();
                ShowMessage("回复保存成功！", false);
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

    private void ClearForm()
    {
        ViewState["EditId"] = null;
        hfEditId.Value = "";
        txtNickName.Text = "";
        txtContent.Text = "";
        txtReplyContent.Text = "";
        chkIsTop.Checked = false;
    }

    protected override void OnUnload(EventArgs e)
    {
        base.OnUnload(e);
        if (_db != null) _db.Dispose();
    }
}