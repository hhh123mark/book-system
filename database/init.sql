-- =============================================
-- 图书管理系统数据库脚本
-- 版本: v1.0
-- 数据库: MySQL 8.0+
-- =============================================

SET FOREIGN_KEY_CHECKS=0;

-- 创建数据库
CREATE DATABASE IF NOT EXISTS library_system DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE library_system;

-- =============================================
-- 1. 用户表
-- =============================================
DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码（MD5加密）',
    nickname VARCHAR(50) COMMENT '昵称',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    avatar VARCHAR(255) DEFAULT '/images/default-avatar.svg' COMMENT '头像路径',
    role TINYINT DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- =============================================
-- 2. 图书分类表
-- =============================================
DROP TABLE IF EXISTS category;
CREATE TABLE category (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '分类ID',
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '分类名称',
    description VARCHAR(255) COMMENT '分类描述',
    sort_order INT DEFAULT 0 COMMENT '排序',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书分类表';

-- =============================================
-- 3. 图书表
-- =============================================
DROP TABLE IF EXISTS book;
CREATE TABLE book (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '图书ID',
    isbn VARCHAR(20) UNIQUE COMMENT 'ISBN编号',
    title VARCHAR(200) NOT NULL COMMENT '书名',
    author VARCHAR(100) COMMENT '作者',
    publisher VARCHAR(100) COMMENT '出版社',
    publish_date DATE COMMENT '出版日期',
    category_id INT COMMENT '分类ID',
    price DECIMAL(10,2) DEFAULT 0.00 COMMENT '价格',
    stock INT DEFAULT 0 COMMENT '库存数量',
    available INT DEFAULT 0 COMMENT '可借数量',
    cover_image VARCHAR(255) COMMENT '封面图片路径',
    description TEXT COMMENT '图书简介',
    status TINYINT DEFAULT 1 COMMENT '状态：0-下架，1-上架',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书表';

-- =============================================
-- 4. 图书图片表（支持多图片）
-- =============================================
DROP TABLE IF EXISTS book_image;
CREATE TABLE book_image (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '图片ID',
    book_id INT NOT NULL COMMENT '图书ID',
    image_path VARCHAR(255) NOT NULL COMMENT '图片路径',
    image_name VARCHAR(255) COMMENT '原始文件名',
    sort_order INT DEFAULT 0 COMMENT '排序',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书图片表';

-- =============================================
-- 5. 借阅记录表
-- =============================================
DROP TABLE IF EXISTS borrow_record;
CREATE TABLE borrow_record (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    user_id INT NOT NULL COMMENT '用户ID',
    book_id INT NOT NULL COMMENT '图书ID',
    borrow_date DATE NOT NULL COMMENT '借阅日期',
    due_date DATE NOT NULL COMMENT '应还日期',
    return_date DATE COMMENT '实际归还日期',
    status TINYINT DEFAULT 0 COMMENT '状态：0-借阅中，1-已归还，2-已逾期',
    remark VARCHAR(255) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='借阅记录表';

-- =============================================
-- 插入测试数据
-- =============================================

-- 插入分类数据
INSERT INTO category (name, description, sort_order) VALUES
('计算机技术', '计算机科学与技术相关书籍', 1),
('文学小说', '文学作品与小说类', 2),
('历史人文', '历史与人文社科书籍', 3),
('经济管理', '经济与管理类书籍', 4),
('自然科学', '自然科学类书籍', 5),
('艺术设计', '艺术与设计类书籍', 6);

-- 插入用户数据（密码都是 123456 的MD5：e10adc3949ba59abbe56e057f20f883e）
INSERT INTO user (username, password, nickname, email, phone, role, status) VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', 'admin@library.com', '13800000000', 1, 1),
('user1', 'e10adc3949ba59abbe56e057f20f883e', '张三', 'zhangsan@example.com', '13800000001', 0, 1),
('user2', 'e10adc3949ba59abbe56e057f20f883e', '李四', 'lisi@example.com', '13800000002', 0, 1),
('user3', 'e10adc3949ba59abbe56e057f20f883e', '王五', 'wangwu@example.com', '13800000003', 0, 1),
('user4', 'e10adc3949ba59abbe56e057f20f883e', '赵六', 'zhaoliu@example.com', '13800000004', 0, 1),
('user5', 'e10adc3949ba59abbe56e057f20f883e', '孙七', 'sunqi@example.com', '13800000005', 0, 1);

-- 插入图书数据
INSERT INTO book (isbn, title, author, publisher, publish_date, category_id, price, stock, available, description) VALUES
('9787111213826', 'Java编程思想', 'Bruce Eckel', '机械工业出版社', '2007-06-01', 1, 108.00, 10, 8, '本书赢得了全球程序员的广泛赞誉，即使是最晦涩的概念，在Bruce Eckel的文字和示例面前也会迎刃而解。'),
('9787115428280', '深入理解Java虚拟机', '周志明', '人民邮电出版社', '2016-06-01', 1, 89.00, 5, 4, '《深入理解Java虚拟机》是Java领域最有影响力的书籍之一。'),
('9787121155346', '算法导论', 'Thomas H.Cormen', '机械工业出版社', '2013-01-01', 1, 128.00, 8, 6, '全书选材经典、内容丰富、结构完整，是算法领域的经典教材。'),
('9787020002207', '红楼梦', '曹雪芹', '人民文学出版社', '2008-07-01', 2, 59.70, 15, 12, '中国古典四大名著之一，是一部具有高度思想性和艺术性的伟大作品。'),
('9787020024759', '百年孤独', '加西亚·马尔克斯', '人民文学出版社', '2011-06-01', 2, 39.50, 12, 10, '魔幻现实主义文学的代表作，被誉为"再现拉丁美洲历史社会图景的鸿篇巨著"。'),
('9787108022257', '明朝那些事儿', '当年明月', '浙江人民出版社', '2017-05-01', 3, 358.00, 6, 5, '以史料为基础，以年代和具体人物为主线，加入小说式笔法的历史读物。'),
('9787111300175', '经济学原理', '曼昆', '北京大学出版社', '2015-01-01', 4, 128.00, 7, 6, '经济学入门的经典教材，被称为经济学的"圣经"。'),
('9787544244077', '时间简史', '史蒂芬·霍金', '湖南科学技术出版社', '2010-04-01', 5, 45.00, 10, 8, '探索时间和空间的奥秘，是全球科学著作的里程碑。'),
('9787115385116', '设计模式', 'Erich Gamma', '人民邮电出版社', '2015-01-01', 1, 59.00, 9, 7, '四人帮经典著作，是软件设计领域的必读之书。'),
('9787508616376', '三体', '刘慈欣', '重庆出版社', '2008-01-01', 2, 93.00, 20, 15, '中国科幻文学的里程碑之作，雨果奖获奖作品。'),
('9787532739259', '追风筝的人', '卡勒德·胡赛尼', '上海人民出版社', '2006-05-01', 2, 29.00, 11, 9, '一个关于友谊、背叛与救赎的故事。'),
('9787111287584', '代码整洁之道', 'Robert C. Martin', '人民邮电出版社', '2010-01-01', 1, 59.00, 8, 6, '软件开发领域的经典之作，教你如何写出整洁的代码。');

-- 插入图书图片（部分图书）
INSERT INTO book_image (book_id, image_path, image_name, sort_order) VALUES
(1, '/uploads/books/java-thinking-1.jpg', 'java-thinking-1.jpg', 1),
(1, '/uploads/books/java-thinking-2.jpg', 'java-thinking-2.jpg', 2),
(2, '/uploads/books/jvm-1.jpg', 'jvm-1.jpg', 1),
(4, '/uploads/books/hongloumeng-1.jpg', 'hongloumeng-1.jpg', 1),
(10, '/uploads/books/santi-1.jpg', 'santi-1.jpg', 1),
(10, '/uploads/books/santi-2.jpg', 'santi-2.jpg', 2);

-- 插入借阅记录
INSERT INTO borrow_record (user_id, book_id, borrow_date, due_date, return_date, status) VALUES
(2, 1, '2026-06-01', '2026-06-21', '2026-06-18', 1),
(2, 2, '2026-06-10', '2026-06-30', NULL, 0),
(2, 10, '2026-06-15', '2026-07-05', NULL, 0),
(3, 4, '2026-06-05', '2026-06-25', '2026-06-23', 1),
(3, 5, '2026-06-12', '2026-07-02', NULL, 0),
(4, 1, '2026-06-08', '2026-06-28', NULL, 0),
(4, 8, '2026-05-20', '2026-06-10', NULL, 2),
(5, 3, '2026-06-01', '2026-06-21', '2026-06-20', 1),
(5, 9, '2026-06-15', '2026-07-05', NULL, 0),
(6, 11, '2026-06-10', '2026-06-30', NULL, 0);

SET FOREIGN_KEY_CHECKS=1;

-- =============================================
-- 完成
-- =============================================
