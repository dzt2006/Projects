<%@ Page Title="典章制度管理" Language="C#" MasterPageFile="~/Admin/Site_a.master" AutoEventWireup="true" CodeFile="SystemManage.aspx.cs" Inherits="Admin_SystemManage" %>

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
                <label for="txtSearchTitle">标题：</label>
                <asp:TextBox ID="txtSearchTitle" runat="server" CssClass="form-control form-control-ming" style="width: 200px;" />
            </div>
            <div class="search-item">
                <label for="ddlSearchCategory">分类：</label>
                <asp:DropDownList ID="ddlSearchCategory" runat="server" CssClass="form-select form-control-ming" AppendDataBoundItems="True" style="width: 150px;">
                    <asp:ListItem Text="全部" Value="" />
                    <asp:ListItem Text="内阁" Value="内阁" />
                    <asp:ListItem Text="厂卫" Value="厂卫" />
                    <asp:ListItem Text="科举" Value="科举" />
                    <asp:ListItem Text="赋役" Value="赋役" />
                    <asp:ListItem Text="军事" Value="军事" />
                </asp:DropDownList>
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
                    <i class="ri-edit-box-line"></i>
                    <asp:Literal ID="litEditTitle" runat="server" Text="新增典章"></asp:Literal>
                </h5>
            </div>
            
            <asp:HiddenField ID="hfEditId" runat="server" />
            
            <div class="row g-4">
                <div class="col-lg-12">
                    <div class="mb-3">
                        <label for="txtTitle" class="form-label fw-bold">文章标题 </label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control form-control-ming" />
                        <asp:RequiredFieldValidator ID="rfvTitle" runat="server" 
                            ControlToValidate="txtTitle" 
                            ErrorMessage="* 请输入标题" 
                            CssClass="validator-error" 
                            Display="Dynamic" />
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="txtCategory" class="form-label fw-bold">分类 </label>
                            <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control form-control-ming" />
                            <asp:RequiredFieldValidator ID="rfvCategory" runat="server" 
                                ControlToValidate="txtCategory" 
                                ErrorMessage="* 请输入分类" 
                                CssClass="validator-error" 
                                Display="Dynamic" />
                        </div>
                        <div class="col-md-3 mb-3">
                            <asp:CheckBox ID="chkIsTop" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label fw-bold" for="chkIsTop">置顶</label>
                        </div>
                        <div class="col-md-3 mb-3">
                            <asp:CheckBox ID="chkIsShow" runat="server" CssClass="form-check-input" Checked="true" />
                            <label class="form-check-label fw-bold" for="chkIsShow">显示</label>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="txtContent" class="form-label fw-bold">内容详情 </label>
                        <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Rows="8" CssClass="form-control form-control-ming" style="font-family: 'KaiTi', sans-serif; line-height: 1.8;" />
                        <asp:RequiredFieldValidator ID="rfvContent" runat="server" 
                            ControlToValidate="txtContent" 
                            ErrorMessage="* 请输入内容" 
                            CssClass="validator-error" 
                            Display="Dynamic" />
                    </div>
                </div>
            </div>

            <div class="form-toolbar">
                <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn btn-outline-ming" OnClick="BtnCancel_Click" CausesValidation="False" />
                <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btn-ming" OnClick="BtnSave_Click">
                    <i class="ri-save-line"></i> 保存
                </asp:LinkButton>
            </div>
        </div>
    </asp:Panel>

    <div class="ming-card animate__animated animate__fadeInUp">
        <div class="card-header">
            <h5 class="card-title">
                <i class="ri-government-line"></i>
                典章制度列表
            </h5>
            <div>
                <asp:Button ID="btnAddNew" runat="server" Text="新增典章" CssClass="btn btn-ming" OnClick="BtnAddNew_Click" CausesValidation="False" />
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvSystem" runat="server" 
                AutoGenerateColumns="False" 
                AllowPaging="True" 
                PageSize="5" 
                DataKeyNames="ID"
                CssClass="table ming-table align-middle"
                GridLines="None"
                OnPageIndexChanging="GvSystem_PageIndexChanging" 
                OnRowCommand="GvSystem_RowCommand"
                PagerStyle-CssClass="d-none">
                
                <HeaderStyle CssClass="table-light" />
                <RowStyle CssClass="align-middle" />
                
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" ItemStyle-Width="60" />
                    <asp:BoundField DataField="Title" HeaderText="标题" />
                    <asp:BoundField DataField="Category" HeaderText="分类" />
                    <asp:TemplateField HeaderText="置顶" ItemStyle-Width="70">
                        <ItemTemplate>
                            <%# Eval("IsTop").ToString() == "True" ? "是" : "否" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="状态" ItemStyle-Width="70">
                        <ItemTemplate>
                            <%# Eval("IsShow").ToString() == "True" ? "显示" : "隐藏" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="CreateTime" HeaderText="创建时间" DataFormatString="{0:yyyy-MM-dd}" HtmlEncode="False" />
                    
                    <asp:TemplateField HeaderText="操作" ItemStyle-Width="180">
                        <ItemTemplate>
                            <div class="action-btns">
                                <asp:Button ID="btnEditRow" runat="server" Text="编辑" CommandName="EditItem" CommandArgument='<%# Eval("ID") %>' CausesValidation="False" CssClass="action-btn edit" />
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