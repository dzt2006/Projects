<%@ Page Title="历史事件管理" Language="C#" MasterPageFile="~/Admin/Site_a.master" AutoEventWireup="true" CodeFile="EventManage.aspx.cs" Inherits="Admin_EventManage" %>

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

        /* 排序数字输入框样式（和帝王页完全一致） */
        .sort-input-group {
            display: flex;
            align-items: center;
            width: 120px;
        }

        .sort-input-group input {
            text-align: center;
            border-right: none;
            border-top-right-radius: 0;
            border-bottom-right-radius: 0;
        }

        .sort-btn-group {
            display: flex;
            flex-direction: column;
        }

        .sort-btn {
            height: 20px;
            padding: 0 8px;
            border: 1px solid var(--wood);
            background: #fff;
            cursor: pointer;
            font-size: 0.7rem;
            line-height: 1;
            transition: all 0.2s ease;
        }

        .sort-btn:first-child {
            border-top-right-radius: 6px;
            border-bottom: none;
        }

        .sort-btn:last-child {
            border-bottom-right-radius: 6px;
        }

        .sort-btn:hover {
            background: var(--cinnabar);
            color: #fff;
            border-color: var(--cinnabar);
        }

        /* 帝王在位时间提示样式 */
        .year-hint {
            font-size: 0.85rem;
            color: #666;
            margin-top: 0.25rem;
            display: none;
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
                <label for="txtSearchEventName">事件名称：</label>
                <asp:TextBox ID="txtSearchEventName" runat="server" CssClass="form-control form-control-ming" style="width: 200px;" />
            </div>
            <div class="search-item">
                <label for="ddlSearchPeriod">标签：</label>
                <asp:DropDownList ID="ddlSearchPeriod" runat="server" CssClass="form-select form-control-ming" AppendDataBoundItems="True" style="width: 150px;">
                    <asp:ListItem Text="全部" Value="" />
                    <asp:ListItem Text="开国" Value="开国" />
                    <asp:ListItem Text="盛世" Value="盛世" />
                    <asp:ListItem Text="转折" Value="转折" />
                    <asp:ListItem Text="衰落" Value="衰落" />
                    <asp:ListItem Text="灭亡" Value="灭亡" />
                </asp:DropDownList>
            </div>
            <div class="ms-auto">
                <asp:Button ID="btnReset" runat="server" Text="重置" CssClass="btn btn-outline-ming me-2" OnClick="BtnReset_Click" CausesValidation="False" />
                <asp:LinkButton ID="btnSearch" runat="server" CssClass="btn btn-ming" OnClick="BtnSearch_Click" CausesValidation="False">
                    <i class="ri-search-2-line"></i>查询
                </asp:LinkButton>
            </div>
        </div>
    </div>

    <asp:Panel ID="pnlEdit" runat="server" CssClass="mb-4" Visible="False">
        <div class="ming-card animate__animated animate__zoomIn">
            <div class="card-header">
                <h5 class="card-title">
                    <i class="ri-edit-box-line"></i>
                    <asp:Literal ID="litEditTitle" runat="server" Text="新增事件"></asp:Literal>
                </h5>
            </div>
            
            <asp:HiddenField ID="hfEditId" runat="server" />
            
            <div class="row g-4">
                <div class="col-lg-12">
                    <div class="mb-3">
                        <label class="form-label fw-bold">事件名称</label>
                        <asp:TextBox ID="txtEventName" runat="server" CssClass="form-control form-control-ming" placeholder="请输入事件名称" />
                        <asp:RequiredFieldValidator ID="rfvEventName" runat="server" ControlToValidate="txtEventName" ErrorMessage="* 请输入事件名称" CssClass="validator-error" Display="Dynamic" />
                    </div>
                    
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-bold">发生年份</label>
                            <asp:TextBox ID="txtEventYear" runat="server" CssClass="form-control form-control-ming" placeholder="请输入年份" />
                            <asp:CompareValidator ID="cvEventYear" runat="server" ControlToValidate="txtEventYear" Operator="DataTypeCheck" Type="Integer" ErrorMessage="* 必须为整数年份" CssClass="validator-error" Display="Dynamic" />
                            <span id="spnYearHint" class="text-muted small" style="display:none; margin-top:0.25rem;"></span>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-bold">关联帝王</label>
                            <asp:DropDownList ID="ddlEmpID" runat="server" CssClass="form-select form-control-ming" AppendDataBoundItems="True">
                                <asp:ListItem Text="请选择帝王" Value="" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-bold">标签</label>
                            <asp:DropDownList ID="ddlPeriod" runat="server" CssClass="form-select form-control-ming" AppendDataBoundItems="True">
                                <asp:ListItem Text="请选择标签" Value="" />
                                <asp:ListItem Text="开国" Value="开国" />
                                <asp:ListItem Text="盛世" Value="盛世" />
                                <asp:ListItem Text="转折" Value="转折" />
                                <asp:ListItem Text="衰落" Value="衰落" />
                                <asp:ListItem Text="灭亡" Value="灭亡" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-bold">排序</label>
                            <div class="sort-input-group">
                                <asp:TextBox ID="txtSort" runat="server" CssClass="form-control form-control-ming" Text="1" 
                                    oninput="var max=<%= (_db.MingEvent.Any() ? _db.MingEvent.Max(x => x.Sort) : 0) + 1 %>;this.value=this.value.replace(/[^0-9]/g,'');if(parseInt(this.value)>max)this.value=max;if(parseInt(this.value)<1)this.value=1;" />
                                <div class="sort-btn-group">
                                    <button type="button" class="sort-btn" onclick="changeSort(1)">▲</button>
                                    <button type="button" class="sort-btn" onclick="changeSort(-1)">▼</button>
                                </div>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvSort" runat="server" ControlToValidate="txtSort" ErrorMessage="* 请输入排序" CssClass="validator-error" Display="Dynamic" />
                            <asp:CompareValidator ID="cvSort" runat="server" ControlToValidate="txtSort" Operator="DataTypeCheck" Type="Integer" ErrorMessage="* 必须为正整数" CssClass="validator-error" Display="Dynamic" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">事件详情</label>
                        <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Rows="8" CssClass="form-control form-control-ming" placeholder="请输入事件详情" />
                        <asp:RequiredFieldValidator ID="rfvContent" runat="server" ControlToValidate="txtContent" ErrorMessage="* 请输入事件详情" CssClass="validator-error" Display="Dynamic" />
                    </div>
                </div>
            </div>

            <div class="form-toolbar">
                <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn btn-outline-ming" OnClick="BtnCancel_Click" CausesValidation="False" />
                <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btn-ming" OnClick="BtnSave_Click">
                    <i class="ri-save-line"></i>保存
                </asp:LinkButton>
            </div>
        </div>
    </asp:Panel>

    <div class="ming-card animate__animated animate__fadeInUp">
        <div class="card-header">
            <h5 class="card-title"><i class="ri-history-line"></i>历史事件列表</h5>
            <div>
                <asp:Button ID="btnAddNew" runat="server" Text="新增事件" CssClass="btn btn-ming" OnClick="BtnAddNew_Click" CausesValidation="False" />
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvEvent" runat="server" 
                AutoGenerateColumns="False" 
                AllowPaging="True" 
                PageSize="5" 
                DataKeyNames="ID"
                CssClass="table ming-table align-middle"
                GridLines="None"
                OnPageIndexChanging="GvEvent_PageIndexChanging" 
                OnRowCommand="GvEvent_RowCommand"
                PagerStyle-CssClass="d-none">
                
                <HeaderStyle CssClass="table-light" />
                <RowStyle CssClass="align-middle" />
                
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" ItemStyle-Width="60" />
                    <asp:BoundField DataField="EventName" HeaderText="事件名称" />
                    <asp:BoundField DataField="EventYear" HeaderText="年份" ItemStyle-Width="80" />
                    <asp:BoundField DataField="EmpName" HeaderText="关联帝王" ItemStyle-Width="100" />
                    <asp:BoundField DataField="Period" HeaderText="标签" ItemStyle-Width="80" />
                    <asp:BoundField DataField="Sort" HeaderText="排序" ItemStyle-Width="70" />
                    
                    <asp:TemplateField HeaderText="操作" ItemStyle-Width="180">
                        <ItemTemplate>
                            <div class="action-btns">
                                <asp:Button ID="btnEditRow" runat="server" Text="编辑" CommandName="EditItem" CommandArgument='<%# Eval("ID") %>' CausesValidation="False" CssClass="action-btn edit" />
                                <asp:Button ID="btnDeleteRow" runat="server" Text="删除" CommandName="DeleteItem" CommandArgument='<%# Eval("ID") %>' CausesValidation="False" OnClientClick="return confirm('确定删除？');" CssClass="action-btn delete" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        
        <div class="pagination-area">
            <div class="page-count-text">
                共 <asp:Literal ID="litTotalCount" runat="server" Text="0" /> 条，第 <asp:Literal ID="litCurrentPage" runat="server" Text="1" /> / <asp:Literal ID="litTotalPages" runat="server" Text="1" /> 页
            </div>
            <div class="page-btn-group">
                <asp:LinkButton ID="btnPrevPage" runat="server" CssClass="page-arrow-btn" OnClick="btnPrevPage_Click" Text="&lt;" />
                <asp:LinkButton ID="btnNextPage" runat="server" CssClass="page-arrow-btn" OnClick="btnNextPage_Click" Text="&gt;" />
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptsPlaceHolder" Runat="Server">
    <script>
        // 全局变量，存储帝王信息
        var empYearData = {};

        // 页面加载完成后执行
        $(document).ready(function () {
            // 初始化所有功能
            initAll();

            // 绑定帝王下拉框变化事件（关键修复：直接绑定到document，确保永远有效）
            $(document).on('change', '#<%= ddlEmpID.ClientID %>', function () {
                var empId = $(this).val();
                autoFillYear(empId);
            });
        });

        // 兼容UpdatePanel异步回发
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
            initAll();
        });

        function initAll() {
            // 消息提示
            var $msgPanel = $('#<%= pnlMsg.ClientID %>');
            var $msg = $('#<%= lblMessage.ClientID %>');
            if ($msgPanel.length > 0 && $msg.text() !== '') {
                $msgPanel.show();
                var isError = $msg.text().indexOf('出错') > -1 || $msg.text().indexOf('失败') > -1;
                var icon = isError ? 'ri-error-warning-line' : 'ri-checkbox-circle-line';
                var color = isError ? '#C41E3A' : '#28A745';
                $msg.css({
                    'padding': '1rem 1.5rem', 'border-radius': '12px',
                    'background': isError ? 'rgba(196,30,58,0.1)' : 'rgba(40,167,69,0.1)',
                    'color': color, 'border': '1px solid ' + color,
                    'display': 'flex', 'align-items': 'center', 'gap': '0.5rem'
                }).prepend('<i class="' + icon + '" style="font-size:1.2rem;"></i>');
            }

            // 编辑模式下自动填充年份
            var selectedEmpId = $('#<%= ddlEmpID.ClientID %>').val();
            if (selectedEmpId && $('#<%= txtEventYear.ClientID %>').val() === '') {
                autoFillYear(selectedEmpId);
            }
        }

        // 自动填充年份函数（独立函数，确保可调用）
        function autoFillYear(empId) {
            var $yearInput = $('#<%= txtEventYear.ClientID %>');
            var $hint = $('#spnYearHint');

            if (empId && empYearData[empId]) {
                var data = empYearData[empId];
                
                // 显示在位时间提示
                $hint.text('提示：该帝王在位时间为 ' + data.full + ' 年');
                $hint.show();

                // 只有当年份输入框为空时才自动填充
                if ($yearInput.val() === '') {
                    $yearInput.val(data.start);
                }
            } else {
                $hint.hide();
            }
        }

        // 排序上下箭头功能
        function changeSort(delta) {
            var $input = $('#<%= txtSort.ClientID %>');
            var current = parseInt($input.val()) || 1;
            var maxSort = <%= (_db.MingEvent.Any() ? _db.MingEvent.Max(x => x.Sort) : 0) + 1 %>;
            var newValue = current + delta;

            if (newValue < 1) newValue = 1;
            if (newValue > maxSort) newValue = maxSort;
            $input.val(newValue);
        }
    </script>

    <!-- 后端生成帝王数据（关键修复：直接输出JavaScript对象，避免序列化问题） -->
    <script>
        <%= GetEmpYearScript() %>
</script>
</asp:Content>