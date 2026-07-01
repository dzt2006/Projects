<%@ Page Title="帝王管理" Language="C#" MasterPageFile="~/Admin/Site_a.master" AutoEventWireup="true" CodeFile="EmperorManage.aspx.cs" Inherits="Admin_EmperorManage" %>

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

        .img-preview-box {
            width: 120px;
            height: 120px;
            background: var(--paper);
            border: 1px dashed var(--wood);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            margin-top: 0.5rem;
            position: relative;
        }
        
        .img-preview-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: none; /* 默认隐藏，JS控制显示 */
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

        /* 排序数字输入框样式 */
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
                <label for="txtSearchName">帝王名称：</label>
                <asp:TextBox ID="txtSearchName" runat="server" CssClass="form-control form-control-ming" style="width: 200px;" />
            </div>
            <div class="search-item">
                <label for="ddlSearchPeriod">时期：</label>
                <asp:DropDownList ID="ddlSearchPeriod" runat="server" CssClass="form-select form-control-ming" AppendDataBoundItems="True" style="width: 150px;">
                    <asp:ListItem Text="全部" Value="" />
                    <asp:ListItem Text="初期" Value="初期" />
                    <asp:ListItem Text="中期" Value="中期" />
                    <asp:ListItem Text="晚期" Value="晚期" />
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
                    <asp:Literal ID="litEditTitle" runat="server" Text="新增帝王"></asp:Literal>
                </h5>
            </div>
            
            <asp:HiddenField ID="hfEditId" runat="server" />
            
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="mb-3">
                        <label class="form-label fw-bold">帝王名称</label>
                        <asp:TextBox ID="txtEmpName" runat="server" CssClass="form-control form-control-ming" />
                        <asp:RequiredFieldValidator ID="rfvEmpName" runat="server" ControlToValidate="txtEmpName" ErrorMessage="* 请输入名称" CssClass="validator-error" Display="Dynamic" />
                    </div>
                    
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-bold">年号</label>
                            <asp:TextBox ID="txtReignTitle" runat="server" CssClass="form-control form-control-ming" />
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-bold">庙号</label>
                            <asp:TextBox ID="txtTempleName" runat="server" CssClass="form-control form-control-ming" />
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-bold">在位时间</label>
                            <asp:TextBox ID="txtReignYears" runat="server" CssClass="form-control form-control-ming" placeholder="1368-1398" />
                            <span id="timeTip" class="text-muted small" style="display:none; margin-top:0.25rem;"></span>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-bold">时期</label>
                            <asp:DropDownList ID="ddlPeriod" runat="server" CssClass="form-select form-control-ming"
                                onchange="document.getElementById('timeTip').innerText=this.value?'该时期：'+(this.value=='晚期'?'1567及以后':this.value=='中期'?'1436-1566':'1368-1435'):'';document.getElementById('timeTip').style.display=this.value?'block':'none';">
                                <asp:ListItem Text="请选择" Value="" />
                                <asp:ListItem Text="初期" Value="初期" />
                                <asp:ListItem Text="中期" Value="中期" />
                                <asp:ListItem Text="晚期" Value="晚期" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvPeriod" runat="server" ControlToValidate="ddlPeriod" ErrorMessage="* 请选择时期" CssClass="validator-error" Display="Dynamic" />
                        </div>
                    </div>

                    <!-- 排序组件：数字输入+上下箭头 -->
                    <div class="mb-3">
                        <label class="form-label fw-bold">排序</label>
                        <div class="sort-input-group">
                            <asp:TextBox ID="txtSort" runat="server" CssClass="form-control form-control-ming" Text="1" 
                                oninput="var max=<%= (_db.MingEmperor.Any() ? _db.MingEmperor.Max(x => x.Sort) : 0) + 1 %>;this.value=this.value.replace(/[^0-9]/g,'');if(parseInt(this.value)>max)this.value=max;if(parseInt(this.value)<1)this.value=1;" />
                            <div class="sort-btn-group">
                                <button type="button" class="sort-btn" onclick="changeSort(1)">▲</button>
                                <button type="button" class="sort-btn" onclick="changeSort(-1)">▼</button>
                            </div>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvSort" runat="server" ControlToValidate="txtSort" ErrorMessage="* 请输入排序" CssClass="validator-error" Display="Dynamic" />
                        <asp:CompareValidator ID="cvSort" runat="server" ControlToValidate="txtSort" Operator="DataTypeCheck" Type="Integer" ErrorMessage="* 必须为正整数" CssClass="validator-error" Display="Dynamic" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">帝王介绍</label>
                        <asp:TextBox ID="txtIntro" runat="server" TextMode="MultiLine" Rows="8" CssClass="form-control form-control-ming" />
                        <asp:RequiredFieldValidator ID="rfvIntro" runat="server" ControlToValidate="txtIntro" ErrorMessage="* 请输入介绍" CssClass="validator-error" Display="Dynamic" />
                    </div>
                </div>

                <div class="col-lg-4">
                    <label class="form-label fw-bold">头像</label>
                    <div class="mb-3">
                        <asp:FileUpload ID="fuAvatar" runat="server" CssClass="form-control form-control-ming" />
                        <asp:CustomValidator ID="cvAvatar" runat="server" ControlToValidate="fuAvatar" ErrorMessage="* 请上传图片" CssClass="validator-error" Display="Dynamic" OnServerValidate="cvAvatar_ServerValidate" ValidateEmptyText="True" />
                        
                        <!-- 头像预览区域（服务器端控件，确保编辑时显示原有头像） -->
                        <div class="img-preview-box mt-3">
                            <asp:Image ID="imgPreview" runat="server" CssClass="img-preview" />
                            <span class="text-muted" id="imgPlaceholder" style="font-size: 0.8rem;">暂无头像</span>
                        </div>
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
            <h5 class="card-title"><i class="ri-vip-crown-line"></i>帝王列表</h5>
            <div>
                <asp:Button ID="btnAddNew" runat="server" Text="新增帝王" CssClass="btn btn-ming" OnClick="BtnAddNew_Click" CausesValidation="False" />
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvEmperor" runat="server" 
                AutoGenerateColumns="False" 
                AllowPaging="True" 
                PageSize="5" 
                DataKeyNames="ID"
                CssClass="table ming-table align-middle"
                GridLines="None"
                OnPageIndexChanging="GvEmperor_PageIndexChanging" 
                OnRowCommand="GvEmperor_RowCommand"
                PagerStyle-CssClass="d-none">
                
                <HeaderStyle CssClass="table-light" />
                <RowStyle CssClass="align-middle" />
                
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" ItemStyle-Width="60" />
                    <asp:BoundField DataField="EmpName" HeaderText="帝王名称" />
                    <asp:BoundField DataField="ReignTitle" HeaderText="年号" />
                    <asp:BoundField DataField="TempleName" HeaderText="庙号" />
                    <asp:BoundField DataField="Period" HeaderText="时期" />
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
        // 页面加载和每次异步回发后都自动执行
        $(function () {
            initAll();
        });
        // 兼容UpdatePanel异步回发
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(initAll);

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

            // 自动显示已有头像（核心修复）
            updateImagePreview();

            // 选择文件实时预览
            $('#<%= fuAvatar.ClientID %>').change(function () {
                var file = this.files[0];
                var $img = $('#<%= imgPreview.ClientID %>');
                var $placeholder = $('#imgPlaceholder');

                if (file && file.type.startsWith('image/')) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $img.attr('src', e.target.result);
                        $img.show();
                        $placeholder.hide();
                    }
                    reader.readAsDataURL(file);
                }
            });
        }

        // 统一的图片预览函数
        function updateImagePreview() {
            var $img = $('#<%= imgPreview.ClientID %>');
            var $placeholder = $('#imgPlaceholder');
            // 如果图片有src且不为空，就显示
            if ($img.attr('src') && $img.attr('src') !== '') {
                $img.show();
                $placeholder.hide();
            } else {
                $img.hide();
                $placeholder.show();
            }
        }

        // 排序上下箭头功能（带最大值限制）
        function changeSort(delta) {
            var $input = $('#<%= txtSort.ClientID %>');
            var current = parseInt($input.val()) || 1;
            var maxSort = <%= (_db.MingEmperor.Any() ? _db.MingEmperor.Max(x => x.Sort) : 0) + 1 %>;
            var newValue = current + delta;

            if (newValue < 1) newValue = 1;
            if (newValue > maxSort) newValue = maxSort;
            $input.val(newValue);
        }
    </script>
</asp:Content>