using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class Admin_FigureManage : System.Web.UI.Page
{
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();
    private const string UploadPath = "~/upload/";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Directory.CreateDirectory(Server.MapPath(UploadPath));
            BindGrid();
            pnlEdit.Visible = false;
            pnlMsg.Visible = false;
        }
    }

    protected void cvAvatar_ServerValidate(object source, ServerValidateEventArgs args)
    {
        int? editId = ViewState["EditId"] as int?;
        bool hasExistingAvatar = !string.IsNullOrEmpty(imgCurrentAvatar.ImageUrl);

        if (editId.HasValue && hasExistingAvatar && !fuAvatar.HasFile) { args.IsValid = true; return; }
        if (!fuAvatar.HasFile) { args.IsValid = false; cvAvatar.ErrorMessage = "* 请上传头像"; return; }

        string ext = Path.GetExtension(fuAvatar.FileName).ToLower();
        string[] allow = { ".jpg", ".jpeg", ".png", ".gif" };
        if (!allow.Contains(ext)) { args.IsValid = false; cvAvatar.ErrorMessage = "* 仅支持图片"; return; }
        if (fuAvatar.PostedFile.ContentLength > 2 * 1024 * 1024) { args.IsValid = false; cvAvatar.ErrorMessage = "* 最大2MB"; return; }

        args.IsValid = true;
    }

    private void ShowMessage(string msg, bool isError)
    {
        lblMessage.Text = msg; pnlMsg.Visible = true;
        lblMessage.ForeColor = isError ? System.Drawing.Color.Red : System.Drawing.Color.Green;
    }

    private void HideMessage() { pnlMsg.Visible = false; lblMessage.Text = ""; }

    protected void BtnAddNew_Click(object sender, EventArgs e) { ClearForm(); HideMessage(); pnlEdit.Visible = true; litEditTitle.Text = "新增人物"; }
    protected void BtnCancel_Click(object sender, EventArgs e) { ClearForm(); pnlEdit.Visible = false; HideMessage(); }

    private IQueryable<MingFigure> GetQuery()
    {
        var q = _db.MingFigure.AsQueryable();
        if (!string.IsNullOrEmpty(txtSearchName.Text.Trim())) q = q.Where(m => m.Name.Contains(txtSearchName.Text.Trim()));
        if (!string.IsNullOrEmpty(ddlSearchCategory.SelectedValue)) q = q.Where(m => m.Category == ddlSearchCategory.SelectedValue);
        return q;
    }

    private void BindGrid()
    {
        var q = GetQuery();
        var list = q.OrderBy(m => m.Sort).ToList();
        int total = list.Count, size = gvFigure.PageSize;
        int pages = (int)Math.Ceiling(total * 1.0 / size);
        int curr = gvFigure.PageIndex + 1;

        litTotalCount.Text = total.ToString();
        litCurrentPage.Text = curr.ToString();
        litTotalPages.Text = pages.ToString();

        btnPrevPage.Enabled = curr > 1;
        btnNextPage.Enabled = curr < pages;

        gvFigure.DataSource = list;
        gvFigure.DataBind();
    }

    protected void btnPrevPage_Click(object sender, EventArgs e) { if (gvFigure.PageIndex > 0) gvFigure.PageIndex--; BindGrid(); pnlEdit.Visible = false; HideMessage(); }
    protected void btnNextPage_Click(object sender, EventArgs e)
    {
        var q = GetQuery(); int total = q.Count(); int pages = (int)Math.Ceiling(total * 1.0 / gvFigure.PageSize);
        if (gvFigure.PageIndex < pages - 1) gvFigure.PageIndex++;
        BindGrid(); pnlEdit.Visible = false; HideMessage();
    }

    protected void BtnSearch_Click(object sender, EventArgs e) { gvFigure.PageIndex = 0; BindGrid(); pnlEdit.Visible = false; ClearForm(); ShowMessage("查询完成", false); }
    protected void BtnReset_Click(object sender, EventArgs e) { txtSearchName.Text = ""; ddlSearchCategory.SelectedValue = ""; gvFigure.PageIndex = 0; BindGrid(); pnlEdit.Visible = false; ClearForm(); HideMessage(); }
    protected void GvFigure_PageIndexChanging(object sender, GridViewPageEventArgs e) { gvFigure.PageIndex = e.NewPageIndex; BindGrid(); pnlEdit.Visible = false; HideMessage(); }

    protected void GvFigure_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);
        if (e.CommandName == "EditItem") LoadData(id);
        else if (e.CommandName == "DeleteItem") DeleteData(id);
    }

    private void LoadData(int id)
    {
        var m = _db.MingFigure.Find(id);
        if (m == null) return;
        ViewState["EditId"] = id;
        txtName.Text = m.Name;
        txtCategory.Text = m.Category;
        txtBirthYear.Text = m.BirthYear.ToString();
        txtDeathYear.Text = m.DeathYear.ToString();
        txtIdentityTitle.Text = m.IdentityTitle;
        txtAchievement.Text = m.Achievement;
        txtSort.Text = m.Sort.ToString();
        txtIntro.Text = m.Intro;

        // 核心修复：使用ResolveUrl确保头像路径正确，由JS控制显示
        if (!string.IsNullOrEmpty(m.Avatar))
        {
            imgCurrentAvatar.ImageUrl = ResolveUrl(m.Avatar);
        }
        else
        {
            imgCurrentAvatar.ImageUrl = "";
        }

        pnlEdit.Visible = true; litEditTitle.Text = "编辑人物"; HideMessage();
    }

    private void DeleteData(int id)
    {
        var m = _db.MingFigure.Find(id);
        if (m == null) return;
        if (!string.IsNullOrEmpty(m.Avatar))
        {
            string p = Server.MapPath(m.Avatar);
            if (File.Exists(p)) File.Delete(p);
        }
        _db.MingFigure.Remove(m);
        _db.SaveChanges();
        BindGrid(); ShowMessage("删除成功", false);
    }

    protected void BtnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        int? editId = ViewState["EditId"] as int?;
        string imgPath = null;

        if (fuAvatar.HasFile)
        {
            try
            {
                string ext = Path.GetExtension(fuAvatar.FileName).ToLower();
                string fn = Guid.NewGuid() + ext;
                string sp = Server.MapPath(UploadPath + fn);
                fuAvatar.SaveAs(sp);

                if (editId.HasValue)
                {
                    var old = _db.MingFigure.Find(editId.Value);
                    if (old != null && !string.IsNullOrEmpty(old.Avatar))
                    {
                        string op = Server.MapPath(old.Avatar);
                        if (File.Exists(op)) File.Delete(op);
                    }
                }
                imgPath = UploadPath + fn;
            }
            catch (Exception ex) { ShowMessage("上传失败：" + ex.Message, true); return; }
        }

        try
        {
            if (editId.HasValue)
            {
                var m = _db.MingFigure.Find(editId.Value);
                UpdateModel(m, imgPath);
                _db.SaveChanges();
                ShowMessage("修改成功", false);
            }
            else
            {
                MingFigure m = new MingFigure();
                UpdateModel(m, imgPath);
                _db.MingFigure.Add(m);
                _db.SaveChanges();
                ShowMessage("新增成功", false);
            }
            BindGrid(); ClearForm(); pnlEdit.Visible = false;
        }
        catch (Exception ex) { ShowMessage("保存失败：" + ex.Message, true); }
    }

    private void UpdateModel(MingFigure m, string img)
    {
        m.Name = txtName.Text.Trim();
        m.Category = txtCategory.Text.Trim();
        m.BirthYear = string.IsNullOrEmpty(txtBirthYear.Text) ? null : (int?)int.Parse(txtBirthYear.Text);
        m.DeathYear = string.IsNullOrEmpty(txtDeathYear.Text) ? null : (int?)int.Parse(txtDeathYear.Text);
        m.IdentityTitle = txtIdentityTitle.Text.Trim();
        m.Achievement = txtAchievement.Text.Trim();
        m.Sort = int.Parse(txtSort.Text);
        m.Intro = txtIntro.Text.Trim();
        if (!string.IsNullOrEmpty(img)) m.Avatar = img;
    }

    private void ClearForm()
    {
        ViewState["EditId"] = null;
        txtName.Text = txtCategory.Text = txtBirthYear.Text = txtDeathYear.Text = txtIdentityTitle.Text = txtAchievement.Text = txtIntro.Text = "";
        txtSort.Text = "0";
        // 清空头像预览
        imgCurrentAvatar.ImageUrl = "";

        rfvName.IsValid = rfvCategory.IsValid = rfvSort.IsValid = rfvIntro.IsValid = true;
        cvBirthYear.IsValid = cvDeathYear.IsValid = cvSort.IsValid = cvAvatar.IsValid = true;
    }

    protected override void OnUnload(EventArgs e) { base.OnUnload(e); _db?.Dispose(); }
}