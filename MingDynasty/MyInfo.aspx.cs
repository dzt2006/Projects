using System;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MyInfo : System.Web.UI.Page
{
    private MingDynastyDBEntities _db = new MingDynastyDBEntities();
    private const string UploadPath = "~/upload/";
    // 统一默认头像常量，全局复用
    private const string DefaultAvatar = "~/upload/avatar_default.png";

    protected void Page_Load(object sender, EventArgs e)
    {
        // 未登录跳转到登录页
        if (Session["UserID"] == null)
        {
            Response.Redirect("~/Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadUserInfo();
        }
    }

    // 加载用户基本信息
    private void LoadUserInfo()
    {
        int userId = Convert.ToInt32(Session["UserID"]);
        var user = _db.MingUser.FirstOrDefault(u => u.ID == userId);

        if (user != null)
        {
            txtUserName.Text = user.UserName;
            txtNickName.Text = user.NickName;
            txtEmail.Text = user.Email;

            // 修复：可空DateTime类型格式化
            // 先判断是否有值，有值则用.Value获取非可空DateTime再格式化
            txtRegisterTime.Text = user.RegisterTime.HasValue
                ? user.RegisterTime.Value.ToString("yyyy-MM-dd")
                : "";

            // 加载头像 - 统一使用指定默认头像
            if (!string.IsNullOrEmpty(user.Avatar))
            {
                imgAvatarPreview.ImageUrl = ResolveUrl(user.Avatar);
            }
            else
            {
                imgAvatarPreview.ImageUrl = ResolveUrl(DefaultAvatar);
            }
        }
    }

    // 保存头像
    protected void btnSaveAvatar_Click(object sender, EventArgs e)
    {
        if (!fuAvatar.HasFile)
        {
            ShowGlobalMessage("请选择要上传的头像", "error");
            return;
        }

        // 验证文件格式和大小
        string ext = Path.GetExtension(fuAvatar.FileName).ToLower();
        string[] allowedExts = { ".jpg", ".jpeg", ".png" };
        if (!allowedExts.Contains(ext))
        {
            ShowGlobalMessage("只支持 JPG、PNG 格式的图片", "error");
            return;
        }

        if (fuAvatar.PostedFile.ContentLength > 2 * 1024 * 1024)
        {
            ShowGlobalMessage("头像大小不能超过 2MB", "error");
            return;
        }

        try
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            var user = _db.MingUser.FirstOrDefault(u => u.ID == userId);

            if (user != null)
            {
                // 生成唯一文件名，避免浏览器缓存旧头像
                string fileName = Guid.NewGuid().ToString() + ext;
                string savePath = Server.MapPath(UploadPath + fileName);
                fuAvatar.SaveAs(savePath);

                // 删除旧头像（不删除默认头像）
                if (!string.IsNullOrEmpty(user.Avatar) && user.Avatar != DefaultAvatar)
                {
                    string oldPath = Server.MapPath(user.Avatar);
                    if (File.Exists(oldPath))
                    {
                        File.Delete(oldPath);
                    }
                }

                // 更新数据库
                string newAvatarPath = UploadPath + fileName;
                user.Avatar = newAvatarPath;
                _db.SaveChanges();

                // 更新Session，确保跨页面同步
                Session["Avatar"] = newAvatarPath;

                // 实时更新当前页面导航栏头像
                UpdateMasterPageNavigation(newAvatarPath, null);

                // 更新个人中心预览图
                imgAvatarPreview.ImageUrl = ResolveUrl(newAvatarPath);

                ShowGlobalMessage("头像修改成功", "success");
            }
        }
        catch (Exception ex)
        {
            ShowGlobalMessage("头像上传失败：" + ex.Message, "error");
        }
    }

    // 保存基本资料
    protected void btnSaveInfo_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }

        try
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            var user = _db.MingUser.FirstOrDefault(u => u.ID == userId);

            if (user != null)
            {
                user.NickName = txtNickName.Text.Trim();
                user.Email = txtEmail.Text.Trim();
                _db.SaveChanges();

                // 更新Session，确保跨页面同步
                Session["NickName"] = user.NickName;

                // 实时更新当前页面导航栏昵称
                UpdateMasterPageNavigation(null, user.NickName);

                ShowGlobalMessage("资料修改成功", "success");
            }
        }
        catch (Exception ex)
        {
            ShowGlobalMessage("保存失败：" + ex.Message, "error");
        }
    }

    // 修改密码
    protected void btnSavePwd_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }

        try
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            var user = _db.MingUser.FirstOrDefault(u => u.ID == userId);

            if (user != null)
            {
                // 验证原密码
                if (user.Pwd != txtOldPwd.Text.Trim())
                {
                    ShowGlobalMessage("当前密码错误", "error");
                    return;
                }

                // 更新密码
                user.Pwd = txtNewPwd.Text.Trim();
                _db.SaveChanges();

                // 清除Session，强制重新登录
                Session.Clear();
                Session.Abandon();

                ShowGlobalMessage("密码修改成功，请重新登录", "success");
                Response.Redirect("~/Login.aspx");
            }
        }
        catch (Exception ex)
        {
            ShowGlobalMessage("修改失败：" + ex.Message, "error");
        }
    }

    // 核心方法：实时更新母版页导航栏
    private void UpdateMasterPageNavigation(string newAvatar, string newNickName)
    {
        // 获取母版页强类型引用
        Page_Site master = this.Master as Page_Site;
        if (master == null) return;

        // 找到母版页上的控件
        Literal litAvatar = master.FindControl("litAvatar") as Literal;
        Literal litUserName = master.FindControl("litUserName") as Literal;

        // 更新头像
        if (litAvatar != null && !string.IsNullOrEmpty(newAvatar))
        {
            litAvatar.Text = $"<div class='user-avatar'><img src='{ResolveUrl(newAvatar)}' /></div>";
        }

        // 更新昵称
        if (litUserName != null && !string.IsNullOrEmpty(newNickName))
        {
            litUserName.Text = newNickName;
        }
    }

    // 显示全局消息（复用母版页的消息机制）
    private void ShowGlobalMessage(string message, string type)
    {
        Session["GlobalMessage"] = message;
        Session["GlobalMessageType"] = type;
    }

}