<%@ Page Title="留言管理" Language="C#" MasterPageFile="~/Admin/Site_a.master" AutoEventWireup="true" CodeFile="MessageManage.aspx.cs" Inherits="Admin_MessageManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .search-row {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .search-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .search-item label {
            font-weight: 500;
            color: var(--ink);
            margin-bottom: 0;
            white-space: nowrap;
        }

        .validator-error {
            color: var(--cinnabar);
            font-size: 0.875rem;
            margin-left: 0.5rem;
            display: block;
            margin-top: 0.25rem;
        }

        .action-btns {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
        }

        .action-btn {
            padding: 0.4rem 1.1rem;
            border-radius: 8px;
            border: none;
            font-size: 0.85rem;
            font-weight: 500;
            transition: all 0.2s ease;
            cursor: pointer;
            text-decoration: none;
            min-width: 70px;
        }

        .action-btn.edit {
            background: rgba(59, 130, 246, 0.1);
            color: #3B82F6;
        }

        .action-btn.delete {
            background: rgba(196, 30, 58, 0.1);
            color: var(--cinnabar);
        }

        .action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .pagination-area {
            margin-top: 1.5rem;
            padding-top: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-count-text {
            color: var(--ink-light);
            font-size: 0.9rem;
        }

        .page-btn-group {
            display: flex;
            gap: 0.8rem;
        }

        .page-arrow-btn {
            padding: 0.4rem 0.9rem;
            border-radius: 8px;
            border: 1px solid var(--wood);
            background: #fff;
            color: var(--ink-light);
            text-decoration: none;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .page-arrow-btn:hover {
            background: rgba(196, 30, 58, 0.05);
            border-color: var(--cinnabar);
            color: var(--cinnabar);
        }

        .page-arrow-btn.disabled {
            opacity: 0.4;
            cursor: not-allowed;
            pointer-events: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Panel ID="pnlMsg" runat="server" CssClass="mb-3" Visible="False">
        <asp:Label ID="lblMessage" runat="server" />
    </asp:Panel>

    <div class="ming-card mb-4 animate__animated animate__fadeInDown">
        <div class="card-header">
            <h5 class="card-title">
                <i class="ri-search-line"></i>搜索筛选
            </h5>
        </div>
        <div class="search-row">
            <div class="search-item">
                <label for="txtSearchNickName">昵称：</label>
                <asp:TextBox ID="txtSearchNickName" runat="server" CssClass="form-control form-control-ming" style="width: 200px;" />
            </div>
            <div class="search-item">
                <label for="txtSearchContent">留言内容：</label>
                <asp:TextBox ID="txtSearchContent" runat="server" CssClass="form-control form-control-ming" style="width: 200px;" />
            </div>
            <div class="ms-auto">
                <asp:Button ID="btnReset" runat="server" Text="重置" CssClass="btn btn-outline-ming me-2" OnClick="BtnReset_Click" CausesValidation="False" />
                <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-ming" OnClick="BtnSearch_Click" CausesValidation="False">
                    <i class="ri-search-2-line"></i> 查询
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <asp:Panel ID="pnlEdit" runat="server" CssClass="mb-4" Visible="False">
        <div class="ming-card animate__animated animate__zoomIn">
            <div class="card-header">
                <h5 class="card-title">
                    <i class="ri-reply-line"></i>
                    留言回复
                </h5>
            </div>
            
            <asp:HiddenField ID="hfEditId" runat="server" />
            
            <div class="row g-4">
                <div class="col-lg-12">
                    <div class="mb-3">
                        <label class="form-label fw-bold">用户昵称</label>
                        <asp:TextBox ID="txtNickName" runat="server" CssClass="form-control form-control-ming" ReadOnly="true" BackColor="#f8f9fa" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">留言内容</label>
                        <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control form-control-ming" ReadOnly="true" BackColor="#f8f9fa" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">管理员回复</label>
                        <asp:TextBox ID="txtReplyContent" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control form-control-ming" />
                    </div>

                    <div class="mb-3">
                        <asp:CheckBox ID="chkIsTop" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label fw-bold" for="chkIsTop">置顶该留言</label>
                    </div>
                </div>
            </div>

            <div class="form-toolbar">
                <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn btn-outline-ming" OnClick="BtnCancel_Click" CausesValidation="False" />
                <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btn-ming" OnClick="BtnSave_Click">
                    <i class="ri-save-line"></i> 保存回复
                </asp:LinkButton>
            </div>
        </div>
    </asp:Panel>

    <div class="ming-card animate__animated animate__fadeInUp">
        <div class="card-header">
            <h5 class="card-title">
                <i class="ri-chat-3-line"></i>
                留言列表
            </h5>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvMessage" runat="server" 
                AutoGenerateColumns="False" 
                AllowPaging="True" 
                PageSize="5" 
                DataKeyNames="ID"
                CssClass="table ming-table align-middle"
                GridLines="None"
                OnPageIndexChanging="GvMessage_PageIndexChanging" 
                OnRowCommand="GvMessage_RowCommand"
                PagerStyle-CssClass="d-none">
                
                <HeaderStyle CssClass="table-light" />
                <RowStyle CssClass="align-middle" />
                
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" ItemStyle-Width="60" />
                    <asp:BoundField DataField="NickName" HeaderText="昵称" />
                    <asp:BoundField DataField="Content" HeaderText="留言内容" />
                    <asp:BoundField DataField="ReplyContent" HeaderText="回复内容" />
                    <asp:BoundField DataField="CreateTime" HeaderText="留言时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" HtmlEncode="False" />
                    <asp:TemplateField HeaderText="操作" ItemStyle-Width="180">
                        <ItemTemplate>
                            <div class="action-btns">
                                <asp:Button ID="btnEditRow" runat="server" Text="回复" CommandName="EditItem" CommandArgument='<%# Eval("ID") %>' CausesValidation="False" CssClass="action-btn edit" />
                                <asp:Button ID="btnDeleteRow" runat="server" Text="删除" CommandName="DeleteItem" CommandArgument='<%# Eval("ID") %>' CausesValidation="False" OnClientClick="return confirm('确定要删除吗？');" CssClass="action-btn delete" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        
        <div class="pagination-area">
            <div class="page-count-text">
                共 <asp:Literal ID="litTotalCount" runat="server" Text="0" /> 条记录，第 <asp:Literal ID="litCurrentPage" runat="server" Text="1" /> / <asp:Literal ID="litTotalPages" runat="server" Text="1" /> 页
            </div>

            <div class="page-btn-group">
                <asp:LinkButton ID="btnPrevPage" runat="server" 
                    CssClass="page-arrow-btn" 
                    OnClick="btnPrevPage_Click"
                    Text="&lt;">
                </asp:LinkButton>

                <asp:LinkButton ID="btnNextPage" runat="server" 
                    CssClass="page-arrow-btn" 
                    OnClick="btnNextPage_Click"
                    Text="&gt;">
                </asp:LinkButton>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsPlaceHolder" Runat="Server">
    <script>
        $(function () {
            var $msgPanel = $('#<%= pnlMsg.ClientID %>');
            var $msg = $('#<%= lblMessage.ClientID %>');
            
            if($msgPanel.length > 0 && $msg.text() !== ''){
                $msgPanel.show();
                var isError = $msg.text().indexOf('出错') > -1 || $msg.text().indexOf('失败') > -1;
                var icon = isError ? 'ri-error-warning-line' : 'ri-checkbox-circle-line';
                var color = isError ? '#C41E3A' : '#28A745';
                
                $msg.css({
                    'padding': '1rem 1.5rem',
                    'border-radius': '12px',
                    'background': isError ? 'rgba(196, 30, 58, 0.1)' : 'rgba(40, 167, 69, 0.1)',
                    'color': color,
                    'border': '1px solid ' + color,
                    'display': 'flex',
                    'align-items': 'center',
                    'gap': '0.5rem'
                }).prepend('<i class="' + icon + '" style="font-size: 1.2rem;"></i>');
            }
        });
    </script>
</asp:Content>