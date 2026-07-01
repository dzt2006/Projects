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

---

## Git 操作速查

### 首次初始化并推送

```bash
# 1. 初始化本地仓库
git init

# 2. 关联远程仓库
git remote add origin https://github.com/dzt2006/Projects.git

# 3. 拉取远程已有文件（如 README），合并不相关历史
#    如果远程仓库完全为空，可跳过此步
git pull origin main --allow-unrelated-histories

# 4. 暂存所有文件
git add .

# 5. 检查暂存状态（确认无误后再提交）
git status

# 6. 提交到本地仓库
git commit -m "初始化仓库，上传所有项目代码"

# 7. 基于当前 master 分支，创建并切换到 main 分支
git checkout -b main

# 8. 推送到远程 main 分支，并建立追踪关系
git push -u origin main
```

### 日常提交流程

```bash
git add .
git commit -m "你的提交说明"
git push
```

### 删除多余的 master 分支

```bash
# 1. 确保当前在 main 分支
git checkout main

# 2. 安全删除本地 master（仅当 master 的所有提交已合并到 main 时生效）
git branch -d master

# 3. 删除远程 master 分支
git push origin --delete master
```
