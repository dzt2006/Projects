using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_EmperorManage : System.Web.UI.Page
{
    public MingDynastyDBEntities _db = new MingDynastyDBEntities();
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

    #region 头像上传验证
    protected void cvAvatar_ServerValidate(object source, ServerValidateEventArgs args)
    {
        int? editId = ViewState["EditId"] as int?;
        // 编辑模式下如果已有头像，可不重新上传
        if (editId.HasValue && !string.IsNullOrEmpty(hfEditId.Value) && !fuAvatar.HasFile)
        {
            args.IsValid = true;
            return;
        }
        // 新增模式必须上传
        if (!fuAvatar.HasFile)
        {
            args.IsValid = false;
            cvAvatar.ErrorMessage = "* 请上传头像";
            return;
        }

        string ext = Path.GetExtension(fuAvatar.FileName).ToLower();
        string[] allow = { ".jpg", ".jpeg", ".png", ".gif" };
        if (!allow.Contains(ext))
        {
            args.IsValid = false;
            cvAvatar.ErrorMessage = "* 仅支持JPG/PNG/GIF图片";
            return;
        }
        if (fuAvatar.PostedFile.ContentLength > 2 * 1024 * 1024)
        {
            args.IsValid = false;
            cvAvatar.ErrorMessage = "* 图片大小不能超过2MB";
            return;
        }

        args.IsValid = true;
    }
    #endregion

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
        litEditTitle.Text = "新增帝王";
    }

    protected void BtnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
        pnlEdit.Visible = false;
        HideMessage();
    }
    #endregion

    #region 数据查询与绑定
    private IQueryable<MingEmperor> GetQuery()
    {
        var q = _db.MingEmperor.AsQueryable();
        if (!string.IsNullOrEmpty(txtSearchName.Text.Trim()))
            q = q.Where(m => m.EmpName.Contains(txtSearchName.Text.Trim()));
        if (!string.IsNullOrEmpty(ddlSearchPeriod.SelectedValue))
            q = q.Where(m => m.Period == ddlSearchPeriod.SelectedValue);
        return q;
    }

    private void BindGrid()
    {
        var q = GetQuery();
        var list = q.OrderBy(m => m.Sort).ToList();
        int total = list.Count;
        int size = gvEmperor.PageSize;
        int pages = (int)Math.Ceiling(total * 1.0 / size);
        int curr = gvEmperor.PageIndex + 1;

        litTotalCount.Text = total.ToString();
        litCurrentPage.Text = curr.ToString();
        litTotalPages.Text = pages.ToString();

        btnPrevPage.Enabled = curr > 1;
        btnNextPage.Enabled = curr < pages;

        gvEmperor.DataSource = list;
        gvEmperor.DataBind();
    }
    #endregion

    #region 分页
    protected void btnPrevPage_Click(object sender, EventArgs e)
    {
        if (gvEmperor.PageIndex > 0)
            gvEmperor.PageIndex--;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    protected void btnNextPage_Click(object sender, EventArgs e)
    {
        var q = GetQuery();
        int total = q.Count();
        int pages = (int)Math.Ceiling(total * 1.0 / gvEmperor.PageSize);
        if (gvEmperor.PageIndex < pages - 1)
            gvEmperor.PageIndex++;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }
    #endregion

    #region 搜索/重置
    protected void BtnSearch_Click(object sender, EventArgs e)
    {
        gvEmperor.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        ShowMessage("查询完成", false);
    }

    protected void BtnReset_Click(object sender, EventArgs e)
    {
        txtSearchName.Text = "";
        ddlSearchPeriod.SelectedValue = "";
        gvEmperor.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        HideMessage();
    }

    protected void GvEmperor_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvEmperor.PageIndex = e.NewPageIndex;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }
    #endregion

    #region 列表操作（编辑/删除）
    protected void GvEmperor_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        int id = Convert.ToInt32(e.CommandArgument);
        if (e.CommandName == "EditItem")
            LoadData(id);
        else if (e.CommandName == "DeleteItem")
            DeleteData(id);
    }

    private void LoadData(int id)
    {
        var m = _db.MingEmperor.Find(id);
        if (m == null) return;

        ViewState["EditId"] = id;
        hfEditId.Value = id.ToString(); // 标记编辑模式
        txtEmpName.Text = m.EmpName;
        txtReignTitle.Text = m.ReignTitle;
        txtTempleName.Text = m.TempleName;
        txtReignYears.Text = m.ReignYears;
        ddlPeriod.SelectedValue = m.Period;
        txtSort.Text = m.Sort.ToString();
        txtIntro.Text = m.Intro;

        // 核心修复：直接给服务器端图片控件赋值，确保编辑时显示原有头像
        if (!string.IsNullOrEmpty(m.Avatar))
        {
            imgPreview.ImageUrl = ResolveUrl(m.Avatar);
        }
        else
        {
            imgPreview.ImageUrl = "";
        }

        // 编辑时自动显示时间提示
        string tip = m.Period == "晚期" ? "1567及以后" : m.Period == "中期" ? "1436-1566" : "1368-1435";
        ScriptManager.RegisterStartupScript(this, GetType(), "showTip",
            $"document.getElementById('timeTip').innerText='该时期：{tip}';document.getElementById('timeTip').style.display='block';", true);

        pnlEdit.Visible = true;
        litEditTitle.Text = "编辑帝王";
        HideMessage();
    }

    private void DeleteData(int id)
    {
        var m = _db.MingEmperor.Find(id);
        if (m == null) return;

        // 删除本地图片
        if (!string.IsNullOrEmpty(m.Avatar))
        {
            string path = Server.MapPath(m.Avatar);
            if (File.Exists(path))
                File.Delete(path);
        }

        // 删除后自动重整排序
        int deletedSort = (int)m.Sort;
        _db.MingEmperor.Remove(m);

        var toUpdate = _db.MingEmperor.Where(x => x.Sort > deletedSort);
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
        string imgPath = null;
        int newSort;

        // 验证并修正排序值（严格限制在1~当前总数+1范围内）
        if (!int.TryParse(txtSort.Text, out newSort) || newSort < 1)
        {
            newSort = 1;
        }
        int totalCount = _db.MingEmperor.Count();
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
                    var oldModel = _db.MingEmperor.Find(editId.Value);
                    if (oldModel.Sort != newSort)
                    {
                        if (newSort < oldModel.Sort)
                        {
                            // 往前挪：后面的序号+1
                            var toUpdate = _db.MingEmperor.Where(x => x.Sort >= newSort && x.Sort < oldModel.Sort);
                            foreach (var item in toUpdate) item.Sort += 1;
                        }
                        else
                        {
                            // 往后挪：前面的序号-1
                            var toUpdate = _db.MingEmperor.Where(x => x.Sort > oldModel.Sort && x.Sort <= newSort);
                            foreach (var item in toUpdate) item.Sort -= 1;
                        }
                    }
                }
                else
                {
                    // 新增：把 >= newSort 的序号都+1
                    var toUpdate = _db.MingEmperor.Where(x => x.Sort >= newSort);
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

        // 上传头像（只有选择了新文件才处理）
        if (fuAvatar.HasFile)
        {
            try
            {
                string ext = Path.GetExtension(fuAvatar.FileName).ToLower();
                string fileName = Guid.NewGuid() + ext;
                string savePath = Server.MapPath(UploadPath + fileName);
                fuAvatar.SaveAs(savePath);

                // 编辑模式删除旧图片
                if (editId.HasValue)
                {
                    var oldModel = _db.MingEmperor.Find(editId.Value);
                    if (oldModel != null && !string.IsNullOrEmpty(oldModel.Avatar))
                    {
                        string oldPath = Server.MapPath(oldModel.Avatar);
                        if (File.Exists(oldPath))
                            File.Delete(oldPath);
                    }
                }
                imgPath = UploadPath + fileName;
            }
            catch (Exception ex)
            {
                ShowMessage("图片上传失败：" + ex.Message, true);
                return;
            }
        }

        try
        {
            if (editId.HasValue)
            {
                var model = _db.MingEmperor.Find(editId.Value);
                UpdateModel(model, imgPath);
                model.Sort = newSort;
                _db.SaveChanges();
                ShowMessage("修改成功", false);
            }
            else
            {
                MingEmperor model = new MingEmperor();
                UpdateModel(model, imgPath);
                model.Sort = newSort;
                _db.MingEmperor.Add(model);
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

    private void UpdateModel(MingEmperor m, string img)
    {
        m.EmpName = txtEmpName.Text.Trim();
        m.ReignTitle = txtReignTitle.Text.Trim();
        m.TempleName = txtTempleName.Text.Trim();
        m.ReignYears = txtReignYears.Text.Trim();
        m.Period = ddlPeriod.SelectedValue;
        m.Intro = txtIntro.Text.Trim();
        // 只有上传了新图片才更新头像
        if (!string.IsNullOrEmpty(img))
            m.Avatar = img;
    }
    #endregion

    #region 清空表单
    private void ClearForm()
    {
        ViewState["EditId"] = null;
        hfEditId.Value = "";
        // 清空输入框
        txtEmpName.Text = txtReignTitle.Text = txtTempleName.Text = txtReignYears.Text = txtIntro.Text = "";
        // 重置下拉框
        ddlPeriod.SelectedIndex = 0;
        // 新增默认放到最后
        int totalCount = _db.MingEmperor.Count();
        txtSort.Text = (totalCount + 1).ToString();
        // 清空头像预览
        imgPreview.ImageUrl = "";

        // 重置验证器
        rfvEmpName.IsValid = rfvPeriod.IsValid = rfvSort.IsValid = rfvIntro.IsValid = true;
        cvSort.IsValid = cvAvatar.IsValid = true;

        // 隐藏时间提示
        ScriptManager.RegisterStartupScript(this, GetType(), "hideTip", "document.getElementById('timeTip').style.display='none';", true);
    }
    #endregion

    protected override void OnUnload(EventArgs e)
    {
        base.OnUnload(e);
        _db?.Dispose();
    }
}