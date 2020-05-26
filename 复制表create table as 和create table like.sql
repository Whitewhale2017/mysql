-- 没有开启gtid的情况下,不拷贝数据，只创建一模一样的表结构，包括索引约束等，结合insert语句可以实现复制一个表的结构和数据的目的
create table tbl_test_bak like  tbl_test; 
insert into tbl_test_bak select * from tbl_test;

-- 以下方式也可以创建表结构,包含数据，但是没有索引约束等，所以不推荐再使用了。而且，在开启gtid情况下，会报语法错误
create table tbl_test_bak as select * from tbl_test;