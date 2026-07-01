using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Page_essageBoard : System.Web.UI.Page
{
    private static MingDynastyDBEntities _db = new MingDynastyDBEntities();

    protected void Page_Load(object sender, EventArgs e)
    {
        // 完全交给Vue3渲染，后端只提供API接口
    }

    #region 【核心工具方法】获取当前登录用户信息
    private static (int UserID, string NickName, bool IsAdmin, bool IsLogin) GetCurrentUser()
    {
        HttpContext context = HttpContext.Current;
        if (context.Session["UserID"] == null)
        {
            return (0, "", false, false);
        }
        return (
            UserID: Convert.ToInt32(context.Session["UserID"]),
            NickName: context.Session["NickName"]?.ToString() ?? "用户",
            IsAdmin: Convert.ToBoolean(context.Session["IsAdmin"] ?? false),
            IsLogin: true
        );
    }
    #endregion

    #region 1. 获取当前用户信息（供前端判断权限）
    [WebMethod(EnableSession = true)]
    public static string GetCurrentUserInfo()
    {
        var user = GetCurrentUser();
        return JsonConvert.SerializeObject(new
        {
            user.UserID,
            user.NickName,
            user.IsAdmin,
            user.IsLogin
        });
    }
    #endregion

    #region 2. 获取留言列表
    [WebMethod(EnableSession = true)]
    public static string GetMessages()
    {
        var list = _db.MingMessage
                      .OrderByDescending(m => m.IsTop)
                      .ThenByDescending(m => m.CreateTime)
                      .Select(m => new
                      {
                          m.ID,
                          m.UserID,
                          m.NickName,
                          m.Content,
                          m.ReplyContent,
                          m.ReplyTime,
                          m.IsTop,
                          m.IsAnonymous,
                          m.CreateTime
                      })
                      .ToList();

        return JsonConvert.SerializeObject(list);
    }
    #endregion

    #region 3. 提交新留言
    [WebMethod(EnableSession = true)]
    public static string SubmitMessage(string content, bool isAnonymous)
    {
        try
        {
            if (string.IsNullOrEmpty(content?.Trim()))
                return "error:留言内容不能为空";

            var currentUser = GetCurrentUser();
            MingMessage newMsg = new MingMessage();
            newMsg.Content = content.Trim();
            newMsg.CreateTime = DateTime.Now;
            newMsg.IsTop = false;

            // 登录用户逻辑
            if (currentUser.IsLogin)
            {
                newMsg.IsAnonymous = isAnonymous;
                newMsg.UserID = currentUser.UserID;
                newMsg.NickName = isAnonymous ? "匿名访客" : currentUser.NickName;
            }
            // 未登录强制匿名
            else
            {
                newMsg.UserID = null;
                newMsg.NickName = "匿名访客";
                newMsg.IsAnonymous = true;
            }

            _db.MingMessage.Add(newMsg);
            _db.SaveChanges();
            return "success";
        }
        catch (Exception ex)
        {
            return "error:" + ex.Message;
        }
    }
    #endregion

    #region 4. 删除留言（权限校验：自己的留言/管理员）
    [WebMethod(EnableSession = true)]
    public static string DeleteMessage(int messageId)
    {
        try
        {
            var currentUser = GetCurrentUser();
            if (!currentUser.IsLogin)
                return "error:请先登录";

            var msg = _db.MingMessage.FirstOrDefault(m => m.ID == messageId);
            if (msg == null)
                return "error:留言不存在";

            // 权限校验：只有留言作者/管理员可以删除
            bool canDelete = currentUser.IsAdmin || (msg.UserID == currentUser.UserID);
            if (!canDelete)
                return "error:您没有权限删除此留言";

            // 执行删除
            _db.MingMessage.Remove(msg);
            _db.SaveChanges();
            return "success";
        }
        catch (Exception ex)
        {
            return "error:" + ex.Message;
        }
    }
    #endregion

    #region 5. 管理员回复/编辑回复
    [WebMethod(EnableSession = true)]
    public static string ReplyMessage(int messageId, string replyContent)
    {
        try
        {
            var currentUser = GetCurrentUser();
            if (!currentUser.IsAdmin)
                return "error:只有管理员可以回复留言";

            var msg = _db.MingMessage.FirstOrDefault(m => m.ID == messageId);
            if (msg == null)
                return "error:留言不存在";

            // 更新回复内容和时间
            msg.ReplyContent = replyContent?.Trim();
            msg.ReplyTime = DateTime.Now;
            _db.SaveChanges();

            return "success";
        }
        catch (Exception ex)
        {
            return "error:" + ex.Message;
        }
    }
    #endregion

    #region 6. 管理员删除回复
    [WebMethod(EnableSession = true)]
    public static string DeleteReply(int messageId)
    {
        try
        {
            var currentUser = GetCurrentUser();
            if (!currentUser.IsAdmin)
                return "error:只有管理员可以删除回复";

            var msg = _db.MingMessage.FirstOrDefault(m => m.ID == messageId);
            if (msg == null)
                return "error:留言不存在";

            // 清空回复
            msg.ReplyContent = null;
            msg.ReplyTime = null;
            _db.SaveChanges();

            return "success";
        }
        catch (Exception ex)
        {
            return "error:" + ex.Message;
        }
    }
    #endregion
}