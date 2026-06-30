# 图书管理系统（Library Management System）

JavaWeb 课程期末项目，基于 JSP + Servlet + JDBC 实现的 B/S 架构图书管理系统。

## 技术栈

### 必做技术
- **JSP** - 视图层，使用 EL 表达式和 JSTL 标签
- **Servlet** - 控制层，处理业务逻辑
- **JavaBean** - 模型层，实体类、工具类
- **会话跟踪** - Session 和 Cookie
- **JDBC** - 数据库操作，使用 PreparedStatement
- **Filter** - 编码过滤、登录拦截、权限控制
- **HTML/CSS/JavaScript** - 前端页面和交互
- **Ajax 异步交互** - 原生 fetch + JSON

### 选做技术（加分项）
- **Listener** - 在线人数统计、系统初始化监听器
- **连接池** - 可扩展（当前使用 DriverManager）
- **响应式设计** - 纯 CSS 响应式布局
- **README.md** - 项目说明文档
- **SQL 脚本** - 完整数据库脚本

## 功能模块

### 用户模块
- 用户注册（用户名唯一性检查、密码 MD5 加密）
- 用户登录（验证码、Session 管理）
- 用户注销（安全退出）
- 个人中心（头像上传、信息修改）

### 权限控制
- 普通用户：浏览图书、借阅/归还图书、管理个人信息
- 管理员：图书管理、分类管理、用户管理、借阅管理

### 图书模块
- 图书列表（分页、搜索、分类筛选、排序）
- 图书详情（多图展示、详细信息）
- 图书管理（增删改查、上下架）
- 多图片上传

### 分类模块
- 分类列表
- 分类增删改

### 借阅模块
- 借书（事务管理：扣库存 + 插入记录）
- 还书（事务管理：加库存 + 更新记录）
- 我的借阅（分页、状态筛选）
- 借阅管理（管理员）

### 文件上传下载
- 头像上传（单文件）
- 图书封面上传（单文件）
- 图书多图片上传（多文件）
- 文件下载
- 数据导出（CSV 格式）

## 数据库设计

### 表结构
- `user` - 用户表
- `category` - 图书分类表
- `book` - 图书表
- `book_image` - 图书图片表
- `borrow_record` - 借阅记录表

### ER 关系
- book.category_id → category.id（多对一）
- book_image.book_id → book.id（一对多）
- borrow_record.user_id → user.id（多对一）
- borrow_record.book_id → book.id（多对一）

## 项目结构

```
library-system/
├── src/                              # Java 源代码
│   └── com/library/
│       ├── controller/               # 控制层（Servlet）
│       ├── service/                  # 服务层接口
│       │   └── impl/                 # 服务层实现
│       ├── dao/                      # 数据访问层接口
│       │   └── impl/                 # 数据访问层实现
│       ├── entity/                   # 实体类
│       ├── filter/                   # 过滤器
│       ├── listener/                 # 监听器
│       └── util/                     # 工具类
├── src/resources/                    # 配置文件
│   └── db.properties                 # 数据库配置
├── web/                              # Web 应用根目录
│   ├── WEB-INF/
│   │   ├── web.xml                   # Web 应用配置
│   │   └── lib/                      # 依赖 JAR 包
│   ├── css/                          # 样式文件
│   ├── js/                           # JavaScript 文件
│   ├── images/                       # 图片资源
│   ├── uploads/                      # 上传文件目录
│   ├── admin/                        # 管理员页面
│   ├── user/                         # 用户中心页面
│   ├── error/                        # 错误页面
│   ├── index.jsp                     # 首页
│   ├── login.jsp                     # 登录页
│   └── register.jsp                  # 注册页
├── database/                         # 数据库脚本
│   └── init.sql                      # 初始化脚本
├── .gitignore                        # Git 忽略配置
└── README.md                         # 项目说明
```

## 快速开始

### 环境要求
- JDK 8+
- MySQL 8.0+
- Tomcat 9+
- 浏览器（Chrome / Firefox / Edge）

### 数据库配置
1. 创建数据库并执行脚本：
```sql
source database/init.sql
```

2. 修改数据库配置文件 `src/resources/db.properties`：
```properties
jdbc.url=jdbc:mysql://localhost:3306/library_system?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
jdbc.username=root
jdbc.password=123456
```

### 部署运行
1. 将项目导入 IDE（IntelliJ IDEA / Eclipse）
2. 配置 Tomcat 服务器
3. 添加依赖 JAR 包到 `web/WEB-INF/lib/`：
   - mysql-connector-java-8.0.x.jar
   - jstl-1.2.jar
   - javax.servlet-api.jar（Tomcat 自带，无需添加）
4. 启动 Tomcat
5. 访问 `http://localhost:8080/library-system/`

### 默认账号
| 角色 | 用户名 | 密码 |
|------|--------|------|
| 管理员 | admin | 123456 |
| 普通用户 | zhangsan | 123456 |

## 代码规范

### 后端规范
- 使用 PreparedStatement，防止 SQL 注入
- 使用 try-with-resources 管理数据库资源
- 密码 MD5 加密存储
- MVC 分层架构（Controller → Service → DAO）
- Service 层定义接口 + 实现类
- XSS 防护（HTML 转义）
- CSRF 防护（Token 验证）
- 事务管理（JDBC 手动事务）

### 前端规范
- 独立 CSS 样式文件
- 表单前端验证 + 实时反馈
- 前后端双重验证
- Ajax 异步交互
- 表格排序
- 用户操作反馈（Toast / Modal）

## 核心亮点

1. **完整的 MVC 架构** - 清晰的分层设计
2. **事务管理** - 借书/还书等多表操作使用事务保证一致性
3. **安全防护** - XSS、CSRF、SQL 注入防护
4. **文件上传下载** - 单文件、多文件上传，文件下载，数据导出
5. **分页查询** - 通用分页工具类，支持条件查询
6. **权限控制** - Filter 实现登录拦截和角色权限验证
7. **在线人数统计** - Listener 实现
8. **响应式布局** - 适配多种屏幕尺寸

## 小组成员

| 学号 | 姓名 | 角色 | 工作量 |
|------|------|------|--------|
| - | - | 组长 | - |

## 版本历史

- **v1.0** (2026-06-28) - 初始版本，完成所有必做功能
