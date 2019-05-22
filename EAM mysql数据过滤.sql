use fixedassets;
SET SQL_SAFE_UPDATES = 0; /*修改数据库模式*/
SET SQL_SAFE_UPDATES = 1; /*修改数据库模式，安全模式下无法delete或者update非查询的数据*/

select * from uf_fixedassets order by id desc;

#delete from uf_fixedassets where id in (4853)


select zzbh,sbmc,sbxh,replace(cast(sbxh as char(1000)),' ','') as a
from uf_fixedassets where zzbh like 'PMY%';

update  uf_fixedassets set sbxh=replace(cast(sbxh as char(1000)),' ','') where zzbh like 'PMP%';