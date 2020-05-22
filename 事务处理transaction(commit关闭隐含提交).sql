SET SQL_SAFE_UPDATES = 0; /*修改数据库模式*/
SET SQL_SAFE_UPDATES = 1; /*修改数据库模式，安全模式下无法delete或者update非查询的数据*/

# 一般的MySQL语句都是直接针对数据库表执行和编写的。
# 这就是所谓的隐含提交（implicit commit），即提交（写或保存）操作是自动进行的。
 # 开启事务(start transaction)之后，隐含提交（implicit commit）就会关闭。
start transaction; 
select * from role;
insert into role(id,createdate,modifydate,issystem,name,value) 
values('4028f18153ca6edd0153ca794fc30005','2020-03-31 10:21:01','2020-08-04 18:12:27',0, 'pda用户2', 'ROLE_PDA2');
commit;


select EXTRACT(YEAR FROM now());


start transaction;  # 事务处理结束前，如何开启新的事务，就会commit当前事务。
select * from role;       
delete from role where extract(year from createdate) = '2020';
rollback; 
# ---- commit之后就无法rollback --------------