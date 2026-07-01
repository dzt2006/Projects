using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class Admin_CarouselManage : System.Web.UI.Page
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

    // 轮播图片自定义验证逻辑
    protected void cvImageUrl_ServerValidate(object source, ServerValidateEventArgs args)
    {
        int? editId = ViewState["EditId"] as int?;
        bool hasExistingImage = !string.IsNullOrEmpty(imgCurrentImage.ImageUrl);

        if (editId.HasValue && hasExistingImage && !fuImageUrl.HasFile)
        {
            args.IsValid = true;
            return;
        }

        if (!fuImageUrl.HasFile)
        {
            args.IsValid = false;
            cvImageUrl.ErrorMessage = "* 请上传轮播图片";
            return;
        }

        string ext = Path.GetExtension(fuImageUrl.FileName).ToLower();
        string[] allowedExts = { ".jpg", ".jpeg", ".png", ".gif" };
        if (!allowedExts.Contains(ext))
        {
            args.IsValid = false;
            cvImageUrl.ErrorMessage = "* 只支持 jpg, jpeg, png, gif 格式";
            return;
        }

        if (fuImageUrl.PostedFile.ContentLength > 5 * 1024 * 1024)
        {
            args.IsValid = false;
            cvImageUrl.ErrorMessage = "* 文件大小不能超过 5MB";
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
        litEditTitle.Text = "新增轮播图";
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
    private IQueryable<MingBanner> GetQuery()
    {
        var query = _db.MingBanner.AsQueryable();
        if (!string.IsNullOrEmpty(txtSearchTitle.Text.Trim()))
            query = query.Where(m => m.Title.Contains(txtSearchTitle.Text.Trim()));
        return query;
    }

    private void BindGrid()
    {
        var query = GetQuery();
        var dataList = query.OrderBy(m => m.Sort).ThenByDescending(m => m.ID).ToList();

        // 计算分页信息
        int totalCount = dataList.Count;
        int pageSize = gvBanner.PageSize;
        int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);
        int currentPage = gvBanner.PageIndex + 1;

        // 绑定底部统计文字
        litTotalCount.Text = totalCount.ToString();
        litCurrentPage.Text = currentPage.ToString();
        litTotalPages.Text = totalPages.ToString();

        // 处理上下页按钮禁用状态
        btnPrevPage.Enabled = !(currentPage <= 1);
        btnNextPage.Enabled = !(currentPage >= totalPages);

        gvBanner.DataSource = dataList;
        gvBanner.DataBind();
    }

    // 上一页 < 按钮
    protected void btnPrevPage_Click(object sender, EventArgs e)
    {
        if (gvBanner.PageIndex > 0)
        {
            gvBanner.PageIndex--;
        }
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    // 下一页 > 按钮
    protected void btnNextPage_Click(object sender, EventArgs e)
    {
        var query = GetQuery();
        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / gvBanner.PageSize);

        if (gvBanner.PageIndex < totalPages - 1)
        {
            gvBanner.PageIndex++;
        }
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void BtnSearch_Click(object sender, EventArgs e)
    {
        gvBanner.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        ShowMessage("查询完成", false);
    }

    protected void BtnReset_Click(object sender, EventArgs e)
    {
        txtSearchTitle.Text = "";
        gvBanner.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        HideMessage();
    }

    protected void GvBanner_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvBanner.PageIndex = e.NewPageIndex;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void GvBanner_RowCommand(object sender, GridViewCommandEventArgs e)
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
        var banner = _db.MingBanner.FirstOrDefault(m => m.ID == id);
        if (banner != null)
        {
            ViewState["EditId"] = id;
            hfEditId.Value = id.ToString();
            txtTitle.Text = banner.Title;
            txtLinkUrl.Text = banner.LinkUrl;
            txtSort.Text = banner.Sort.HasValue ? banner.Sort.ToString() : "0";

            // 核心修复：使用ResolveUrl确保图片路径正确，由JS控制显示
            if (!string.IsNullOrEmpty(banner.ImageUrl))
            {
                imgCurrentImage.ImageUrl = ResolveUrl(banner.ImageUrl);
            }
            else
            {
                imgCurrentImage.ImageUrl = "";
            }

            btnCancel.Visible = true;
            pnlEdit.Visible = true;
            litEditTitle.Text = "编辑轮播图";
            HideMessage();
        }
    }

    private void DeleteData(int id)
    {
        var banner = _db.MingBanner.FirstOrDefault(m => m.ID == id);
        if (banner != null)
        {
            if (!string.IsNullOrEmpty(banner.ImageUrl))
            {
                string oldPath = Server.MapPath(banner.ImageUrl);
                if (File.Exists(oldPath)) File.Delete(oldPath);
            }
            _db.MingBanner.Remove(banner);
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
        string imagePath = null;

        if (fuImageUrl.HasFile)
        {
            try
            {
                string ext = Path.GetExtension(fuImageUrl.FileName).ToLower();
                string fileName = Guid.NewGuid().ToString() + ext;
                string savePath = Server.MapPath(UploadPath + fileName);
                fuImageUrl.SaveAs(savePath);

                if (editId.HasValue)
                {
                    var old = _db.MingBanner.FirstOrDefault(m => m.ID == editId.Value);
                    if (old != null && !string.IsNullOrEmpty(old.ImageUrl))
                    {
                        string oldPath = Server.MapPath(old.ImageUrl);
                        if (File.Exists(oldPath)) File.Delete(oldPath);
                    }
                }
                imagePath = UploadPath + fileName;
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
                var banner = _db.MingBanner.FirstOrDefault(m => m.ID == editId.Value);
                if (banner != null)
                {
                    UpdateBanner(banner, imagePath);
                    _db.SaveChanges();
                    ShowMessage("修改成功！", false);
                }
            }
            else
            {
                MingBanner newBanner = new MingBanner();
                UpdateBanner(newBanner, imagePath);
                _db.MingBanner.Add(newBanner);
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

    private void UpdateBanner(MingBanner banner, string imagePath)
    {
        banner.Title = txtTitle.Text.Trim();
        banner.LinkUrl = txtLinkUrl.Text.Trim();
        banner.Sort = int.Parse(txtSort.Text);
        if (!string.IsNullOrEmpty(imagePath)) banner.ImageUrl = imagePath;
    }

    private void ClearForm()
    {
        ViewState["EditId"] = null;
        hfEditId.Value = "";
        txtTitle.Text = txtLinkUrl.Text = "";
        txtSort.Text = "0";
        // 清空图片预览
        imgCurrentImage.ImageUrl = "";
        btnCancel.Visible = false;

        // 重置所有验证
        rfvTitle.IsValid = true;
        rfvSort.IsValid = true;
        cvSort.IsValid = true;
        cvImageUrl.IsValid = true;
    }

    protected override void OnUnload(EventArgs e)
    {
        base.OnUnload(e);
        if (_db != null) _db.Dispose();
    }
}