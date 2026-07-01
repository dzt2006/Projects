using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class Admin_CultureManage : System.Web.UI.Page
{
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();
    private const string UploadPath = "~/upload/";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string dir = Server.MapPath(UploadPath);
            if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);
            BindGrid();
            pnlEdit.Visible = false;
            pnlMsg.Visible = false;
        }
    }

    // 封面图片自定义验证逻辑
    protected void cvCover_ServerValidate(object source, ServerValidateEventArgs args)
    {
        int? editId = ViewState["EditId"] as int?;
        bool hasExistingCover = !string.IsNullOrEmpty(imgCurrentCover.ImageUrl);

        if (editId.HasValue && hasExistingCover && !fuCover.HasFile)
        {
            args.IsValid = true;
            return;
        }

        if (!fuCover.HasFile)
        {
            args.IsValid = false;
            cvCover.ErrorMessage = "* 请上传封面图片";
            return;
        }

        string ext = Path.GetExtension(fuCover.FileName).ToLower();
        string[] allowedExts = { ".jpg", ".jpeg", ".png", ".gif" };
        if (!allowedExts.Contains(ext))
        {
            args.IsValid = false;
            cvCover.ErrorMessage = "* 只支持 jpg, jpeg, png, gif 格式";
            return;
        }

        if (fuCover.PostedFile.ContentLength > 2 * 1024 * 1024)
        {
            args.IsValid = false;
            cvCover.ErrorMessage = "* 文件大小不能超过 2MB";
            return;
        }

        args.IsValid = true;
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

    // 新增按钮
    protected void BtnAddNew_Click(object sender, EventArgs e)
    {
        ClearForm();
        HideMessage();
        pnlEdit.Visible = true;
        litEditTitle.Text = "新增典籍";
        btnCancel.Visible = true;
    }

    // 取消按钮：隐藏表单
    protected void BtnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
        pnlEdit.Visible = false;
        HideMessage();
    }

    // 【抽取公共方法】获取查询数据
    private IQueryable<MingCulture> GetQuery()
    {
        var query = _db.MingCulture.AsQueryable();
        if (!string.IsNullOrEmpty(txtSearchTitle.Text.Trim()))
            query = query.Where(m => m.Title.Contains(txtSearchTitle.Text.Trim()));
        if (!string.IsNullOrEmpty(ddlSearchCategory.SelectedValue))
            query = query.Where(m => m.Category == ddlSearchCategory.SelectedValue);
        return query;
    }

    private void BindGrid()
    {
        var query = GetQuery();
        var dataList = query.OrderBy(m => m.Sort).ThenByDescending(m => m.CreateTime).ToList();

        // 计算分页信息
        int totalCount = dataList.Count;
        int pageSize = gvCulture.PageSize;
        int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);
        int currentPage = gvCulture.PageIndex + 1;

        // 绑定底部统计文字
        litTotalCount.Text = totalCount.ToString();
        litCurrentPage.Text = currentPage.ToString();
        litTotalPages.Text = totalPages.ToString();

        // 处理上下页按钮禁用状态
        // 第一页 禁用上一页
        btnPrevPage.Enabled = !(currentPage <= 1);
        // 最后一页 禁用下一页
        btnNextPage.Enabled = !(currentPage >= totalPages);

        gvCulture.DataSource = dataList;
        gvCulture.DataBind();
    }

    // 上一页 < 按钮
    protected void btnPrevPage_Click(object sender, EventArgs e)
    {
        if (gvCulture.PageIndex > 0)
        {
            gvCulture.PageIndex--;
        }
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    // 下一页 > 按钮 (已优化：修复搜索后下一页逻辑)
    protected void btnNextPage_Click(object sender, EventArgs e)
    {
        // 使用公共方法 GetQuery 获取筛选后的数据计算总页数
        var query = GetQuery();
        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / gvCulture.PageSize);

        if (gvCulture.PageIndex < totalPages - 1)
        {
            gvCulture.PageIndex++;
        }
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void BtnSearch_Click(object sender, EventArgs e)
    {
        gvCulture.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        ShowMessage("查询完成", false);
    }

    protected void BtnReset_Click(object sender, EventArgs e)
    {
        txtSearchTitle.Text = "";
        ddlSearchCategory.SelectedValue = "";
        gvCulture.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        HideMessage();
    }

    protected void GvCulture_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvCulture.PageIndex = e.NewPageIndex;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void GvCulture_RowCommand(object sender, GridViewCommandEventArgs e)
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
        var culture = _db.MingCulture.FirstOrDefault(m => m.ID == id);
        if (culture != null)
        {
            ViewState["EditId"] = id;
            hfEditId.Value = id.ToString();
            txtTitle.Text = culture.Title;
            txtCategory.Text = culture.Category;
            txtAuthor.Text = culture.Author;
            txtContent.Text = culture.Content;
            txtSort.Text = culture.Sort.ToString();

            // 核心修复：使用ResolveUrl确保封面路径正确，由JS控制显示
            if (!string.IsNullOrEmpty(culture.Cover))
            {
                imgCurrentCover.ImageUrl = ResolveUrl(culture.Cover);
            }
            else
            {
                imgCurrentCover.ImageUrl = "";
            }

            btnCancel.Visible = true;
            pnlEdit.Visible = true;
            litEditTitle.Text = "编辑典籍";
            HideMessage();
        }
    }

    private void DeleteData(int id)
    {
        var culture = _db.MingCulture.FirstOrDefault(m => m.ID == id);
        if (culture != null)
        {
            if (!string.IsNullOrEmpty(culture.Cover))
            {
                string oldPath = Server.MapPath(culture.Cover);
                if (File.Exists(oldPath)) File.Delete(oldPath);
            }
            _db.MingCulture.Remove(culture);
            _db.SaveChanges();
            BindGrid();
            pnlEdit.Visible = false;
            ShowMessage("删除成功！", false);
        }
    }

    protected void BtnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }

        int? editId = ViewState["EditId"] as int?;
        string coverPath = null;

        if (fuCover.HasFile)
        {
            try
            {
                string ext = Path.GetExtension(fuCover.FileName).ToLower();
                string fileName = Guid.NewGuid().ToString() + ext;
                string savePath = Server.MapPath(UploadPath + fileName);
                fuCover.SaveAs(savePath);

                if (editId.HasValue)
                {
                    var old = _db.MingCulture.FirstOrDefault(m => m.ID == editId.Value);
                    if (old != null && !string.IsNullOrEmpty(old.Cover))
                    {
                        string oldPath = Server.MapPath(old.Cover);
                        if (File.Exists(oldPath)) File.Delete(oldPath);
                    }
                }
                coverPath = UploadPath + fileName;
            }
            catch (Exception ex)
            {
                ShowMessage("上传出错：" + ex.Message, true);
                return;
            }
        }

        try
        {
            if (editId.HasValue)
            {
                var culture = _db.MingCulture.FirstOrDefault(m => m.ID == editId.Value);
                if (culture != null)
                {
                    UpdateCulture(culture, coverPath);
                    _db.SaveChanges();
                    ShowMessage("修改成功！", false);
                }
            }
            else
            {
                MingCulture newCulture = new MingCulture();
                UpdateCulture(newCulture, coverPath);
                newCulture.CreateTime = DateTime.Now;
                _db.MingCulture.Add(newCulture);
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

    private void UpdateCulture(MingCulture culture, string coverPath)
    {
        culture.Title = txtTitle.Text.Trim();
        culture.Category = txtCategory.Text.Trim();
        culture.Author = txtAuthor.Text.Trim();
        culture.Content = txtContent.Text.Trim();
        culture.Sort = int.Parse(txtSort.Text);
        if (!string.IsNullOrEmpty(coverPath)) culture.Cover = coverPath;
    }

    private void ClearForm()
    {
        ViewState["EditId"] = null;
        hfEditId.Value = "";
        txtTitle.Text = txtCategory.Text = txtAuthor.Text = txtContent.Text = "";
        txtSort.Text = "0";
        // 清空封面预览
        imgCurrentCover.ImageUrl = "";
        btnCancel.Visible = false;

        // 重置所有验证
        rfvTitle.IsValid = true;
        rfvCategory.IsValid = true;
        rfvAuthor.IsValid = true;
        rfvSort.IsValid = true;
        cvSort.IsValid = true;
        rfvContent.IsValid = true;
        cvCover.IsValid = true;
    }

    protected override void OnUnload(EventArgs e)
    {
        base.OnUnload(e);
        if (_db != null) _db.Dispose();
    }
}