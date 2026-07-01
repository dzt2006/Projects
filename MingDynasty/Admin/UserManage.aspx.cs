using System;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

public partial class Admin_UserManage : System.Web.UI.Page
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

    // 头像验证
    protected void cvAvatar_ServerValidate(object source, ServerValidateEventArgs args)
    {
        int? editId = ViewState["EditId"] as int?;
        bool hasExistingAvatar = !string.IsNullOrEmpty(imgCurrentAvatar.ImageUrl);

        // 编辑模式下已有头像，可不传新图
        if (editId.HasValue && hasExistingAvatar && !fuAvatar.HasFile)
        {
            args.IsValid = true;
            return;
        }

        // 新增必须传
        if (!fuAvatar.HasFile)
        {
            args.IsValid = false;
            cvAvatar.ErrorMessage = "* 请上传用户头像";
            return;
        }

        string ext = Path.GetExtension(fuAvatar.FileName).ToLower();
        string[] allowedExts = { ".jpg", ".jpeg", ".png", ".gif" };
        if (!allowedExts.Contains(ext))
        {
            args.IsValid = false;
            cvAvatar.ErrorMessage = "* 只支持 jpg, jpeg, png, gif 格式";
            return;
        }

        if (fuAvatar.PostedFile.ContentLength > 2 * 1024 * 1024)
        {
            args.IsValid = false;
            cvAvatar.ErrorMessage = "* 文件大小不能超过 2MB";
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

    // 新增
    protected void BtnAddNew_Click(object sender, EventArgs e)
    {
        ClearForm();
        HideMessage();
        // 新增模式下启用密码必填验证
        rfvPwd.Enabled = true;
        pnlEdit.Visible = true;
        litEditTitle.Text = "新增用户";
    }

    // 取消
    protected void BtnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
        pnlEdit.Visible = false;
        HideMessage();
    }

    // 查询条件
    private IQueryable<MingUser> GetQuery()
    {
        var query = _db.MingUser.AsQueryable();
        if (!string.IsNullOrEmpty(txtSearchUserName.Text.Trim()))
            query = query.Where(m => m.UserName.Contains(txtSearchUserName.Text.Trim()));
        if (!string.IsNullOrEmpty(txtSearchNickName.Text.Trim()))
            query = query.Where(m => m.NickName.Contains(txtSearchNickName.Text.Trim()));
        return query;
    }

    // 绑定列表
    private void BindGrid()
    {
        var query = GetQuery();
        var dataList = query.OrderByDescending(m => m.RegisterTime).ToList();

        int totalCount = dataList.Count;
        int pageSize = gvUser.PageSize;
        int totalPages = (int)Math.Ceiling((double)totalCount / pageSize);
        int currentPage = gvUser.PageIndex + 1;

        litTotalCount.Text = totalCount.ToString();
        litCurrentPage.Text = currentPage.ToString();
        litTotalPages.Text = totalPages.ToString();

        btnPrevPage.Enabled = !(currentPage <= 1);
        btnNextPage.Enabled = !(currentPage >= totalPages);

        gvUser.DataSource = dataList;
        gvUser.DataBind();
    }

    // 上一页
    protected void btnPrevPage_Click(object sender, EventArgs e)
    {
        if (gvUser.PageIndex > 0)
        {
            gvUser.PageIndex--;
        }
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    // 下一页
    protected void btnNextPage_Click(object sender, EventArgs e)
    {
        var query = GetQuery();
        int totalCount = query.Count();
        int totalPages = (int)Math.Ceiling((double)totalCount / gvUser.PageSize);

        if (gvUser.PageIndex < totalPages - 1)
        {
            gvUser.PageIndex++;
        }
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    // 搜索
    protected void BtnSearch_Click(object sender, EventArgs e)
    {
        gvUser.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        ShowMessage("查询完成", false);
    }

    // 重置
    protected void BtnReset_Click(object sender, EventArgs e)
    {
        txtSearchUserName.Text = "";
        txtSearchNickName.Text = "";
        gvUser.PageIndex = 0;
        BindGrid();
        pnlEdit.Visible = false;
        ClearForm();
        HideMessage();
    }

    // 分页切换
    protected void GvUser_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvUser.PageIndex = e.NewPageIndex;
        BindGrid();
        pnlEdit.Visible = false;
        HideMessage();
    }

    // 行操作：编辑/删除
    protected void GvUser_RowCommand(object sender, GridViewCommandEventArgs e)
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

    // 加载编辑数据
    private void LoadData(int id)
    {
        var user = _db.MingUser.FirstOrDefault(m => m.ID == id);
        if (user != null)
        {
            ViewState["EditId"] = id;
            hfEditId.Value = id.ToString();
            txtUserName.Text = user.UserName;
            txtNickName.Text = user.NickName;
            // 修复：编辑时不加载明文密码
            txtPwd.Text = "";
            txtEmail.Text = user.Email;
            chkStatus.Checked = user.Status ?? true;

            // 核心修复：使用ResolveUrl确保头像路径正确
            if (!string.IsNullOrEmpty(user.Avatar))
            {
                imgCurrentAvatar.ImageUrl = ResolveUrl(user.Avatar);
            }
            else
            {
                imgCurrentAvatar.ImageUrl = "";
            }

            // 修复：编辑模式下禁用密码必填验证
            rfvPwd.Enabled = false;

            pnlEdit.Visible = true;
            litEditTitle.Text = "编辑用户";
            HideMessage();
        }
    }

    // 删除用户
    private void DeleteData(int id)
    {
        var user = _db.MingUser.FirstOrDefault(m => m.ID == id);
        if (user != null)
        {
            // 删除头像文件
            if (!string.IsNullOrEmpty(user.Avatar))
            {
                string oldPath = Server.MapPath(user.Avatar);
                if (File.Exists(oldPath)) File.Delete(oldPath);
            }
            _db.MingUser.Remove(user);
            _db.SaveChanges();
            BindGrid();
            ShowMessage("删除成功！", false);
        }
    }

    // 保存
    protected void BtnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }

        int? editId = ViewState["EditId"] as int?;
        string avatarPath = null;

        // 头像上传
        if (fuAvatar.HasFile)
        {
            try
            {
                string ext = Path.GetExtension(fuAvatar.FileName).ToLower();
                string fileName = Guid.NewGuid().ToString() + ext;
                string savePath = Server.MapPath(UploadPath + fileName);
                fuAvatar.SaveAs(savePath);

                // 编辑模式删除旧头像
                if (editId.HasValue)
                {
                    var oldUser = _db.MingUser.FirstOrDefault(m => m.ID == editId.Value);
                    if (oldUser != null && !string.IsNullOrEmpty(oldUser.Avatar))
                    {
                        string oldFilePath = Server.MapPath(oldUser.Avatar);
                        if (File.Exists(oldFilePath)) File.Delete(oldFilePath);
                    }
                }
                avatarPath = UploadPath + fileName;
            }
            catch (Exception ex)
            {
                ShowMessage("头像上传出错：" + ex.Message, true);
                return;
            }
        }

        try
        {
            if (editId.HasValue)
            {
                // 编辑
                var user = _db.MingUser.FirstOrDefault(m => m.ID == editId.Value);
                UpdateUser(user, avatarPath);
                _db.SaveChanges();
                ShowMessage("用户修改成功！", false);
            }
            else
            {
                // 新增
                MingUser newUser = new MingUser();
                UpdateUser(newUser, avatarPath);
                newUser.RegisterTime = DateTime.Now;
                newUser.LastLoginTime = null;
                _db.MingUser.Add(newUser);
                _db.SaveChanges();
                ShowMessage("用户新增成功！", false);
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

    // 更新用户实体
    private void UpdateUser(MingUser user, string avatarPath)
    {
        user.UserName = txtUserName.Text.Trim();
        user.NickName = txtNickName.Text.Trim();
        // 修复：只有密码不为空时才更新
        if (!string.IsNullOrEmpty(txtPwd.Text.Trim()))
        {
            user.Pwd = txtPwd.Text.Trim();
        }
        user.Email = txtEmail.Text.Trim();
        user.Status = chkStatus.Checked;
        if (!string.IsNullOrEmpty(avatarPath))
        {
            user.Avatar = avatarPath;
        }
    }

    // 清空表单
    private void ClearForm()
    {
        ViewState["EditId"] = null;
        hfEditId.Value = "";
        txtUserName.Text = "";
        txtNickName.Text = "";
        txtPwd.Text = "";
        txtEmail.Text = "";
        chkStatus.Checked = true;
        // 清空头像预览
        imgCurrentAvatar.ImageUrl = "";

        // 重置验证
        rfvUserName.IsValid = true;
        rfvPwd.IsValid = true;
        cvAvatar.IsValid = true;
        // 重置密码验证器状态
        rfvPwd.Enabled = true;
    }

    // 释放EF
    protected override void OnUnload(EventArgs e)
    {
        base.OnUnload(e);
        if (_db != null) _db.Dispose();
    }
}