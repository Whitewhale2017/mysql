
/*mysql添加表注释、字段注释、查看与修改注释*/
#1 创建表的时候写注释
create table test1
(
field_name int comment '字段的注释'
)comment='表的注释';

#2 修改表的注释
alter table test1 comment '修改后的表的注释';

#3 修改字段的注释
alter table test1 modify column field_name int comment '修改后的字段注释';
--注意：字段名和字段类型照写就行

#4 查看表注释的方法
#--在生成的SQL语句中看
show create table test1;
#--在元数据的表里面看
use information_schema;
select * from TABLES where TABLE_SCHEMA='sapdata' and TABLE_NAME='v_test' \G

#5 查看字段注释的方法
#--show
show full columns from v_test;
#--在元数据的表里面看
use information_schema;
select * from COLUMNS where TABLE_SCHEMA='sapdata' and TABLE_NAME='v_test' 