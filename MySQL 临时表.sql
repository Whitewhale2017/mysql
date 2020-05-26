/*MySQL 临时表
MySQL 临时表在我们需要保存一些临时数据时是非常有用的。临时表只在当前连接可见，当关闭连接时，Mysql会自动删除表并释放所有空间。
临时表在MySQL 3.23版本中添加，如果你的MySQL版本低于 3.23版本就无法使用MySQL的临时表。不过现在一般很少有再使用这么低版本的MySQL数据库服务了。
如果你使用了其他MySQL客户端程序连接MySQL数据库服务器来创建临时表，那么只有在关闭客户端程序时才会销毁临时表，当然你也可以手动销毁。
实例
以下展示了使用MySQL 临时表的简单实例，以下的SQL代码可以适用于PHP脚本的mysql_query()函数。*/
 CREATE TEMPORARY TABLE SalesSummary (
    product_name VARCHAR(50) NOT NULL
    , total_sales DECIMAL(12,2) NOT NULL DEFAULT 0.00
    , avg_unit_price DECIMAL(7,2) NOT NULL DEFAULT 0.00
    , total_units_sold INT UNSIGNED NOT NULL DEFAULT 0
);
-- Query OK, 0 rows affected (0.00 sec)

 INSERT INTO SalesSummary
 (product_name, total_sales, avg_unit_price, total_units_sold)
 VALUES
('cucumber', 100.25, 90, 2);

SELECT * FROM SalesSummary;
/*+--------------+-------------+----------------+------------------+
| product_name | total_sales | avg_unit_price | total_units_sold |
+--------------+-------------+----------------+------------------+
| cucumber     |      100.25 |          90.00 |                2 |
+--------------+-------------+----------------+------------------+
1 row in set (0.00 sec)*/
/*删除MySQL 临时表
默认情况下，当你断开与数据库的连接后，临时表就会自动被销毁。当然你也可以在当前MySQL会话使用 DROP TABLE 命令来手动删除临时表。*/