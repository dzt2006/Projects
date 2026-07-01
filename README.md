# 大明纪事历史 (MingDynasty )

> 我的第一个大型项目 — 一个关于中国明朝历史的科普网站。
> This is my first big project — an educational website about Ming Dynasty history.

---

## 项目总览 / Project Mind Map

```
大明纪事历史 (MingDynasty Project)
│
├── 前端 (Page/)
│   ├── 皇帝、人物、事件、文化、制度 — 内容展示
│   ├── 留言板、登录注册、个人中心 — 用户功能
│   └── Bootstrap 5 + Vue.js + jQuery
│
├── 后台管理 — 文渊阁 (Admin/)
│   ├── 各模块数据 CRUD 管理
│   └── ECharts 仪表盘 + Vis.js 时间轴
│
├── 数据库 (MingDynastyDB / SQL Server)
│   ├── MingEmperor / MingEvent / MingFigure — 核心历史数据
│   ├── MingCulture / MingSystemArticle — 文章内容
│   └── MingUser / AdminUser / MingMessage — 用户与互动
│
└── 技术栈
    ├── ASP.NET Web Forms (C#) + Entity Framework 6
    ├── Bootstrap 5 + Vue.js + jQuery + ECharts
    └── PBKDF2 密码加密
```

---

## 快速开始

```bash
# 1. 克隆项目
git clone <repo-url>
cd MingDynasty

# 2. 还原 NuGet 包
nuget restore MingDynasty.sln

# 3. 导入数据库
# 在 SQL Server 中执行 App_Data/App_Database.sql

# 4. 修改连接字符串 (Web.config)
# <connectionStrings>
#   <add name="MingDynastyEntities"
#        connectionString="Server=你的服务器;Database=MingDynastyDB;..."
#        providerName="System.Data.SqlClient" />
# </connectionStrings>

# 5. 用 Visual Studio 2019+ 打开 MingDynasty.sln 运行
```
