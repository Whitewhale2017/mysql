use fixedassets;

select * from uf_passthebilljournal;

SET SQL_SAFE_UPDATES = 0; /*修改数据库模式*/
SET SQL_SAFE_UPDATES = 1; /*修改数据库模式，安全模式下无法delete或者update非查询的数据*/

truncate table uf_passthebilljournal;

create table new_uf_passthebilljournal as select * from uf_passthebilljournal where 1=2;

select id,zzbh,sapzzbh,sbmc,sbxh,ysrq,cfwz,ssqy,zclbyj from uf_fixedassets;

select * from new_uf_passthebilljournal;
select * from  uf_passthebilljournal;

delimiter $$
create trigger tri_new_uf_passthebilljournal
    after insert
    on uf_passthebilljournal
    for each row
    begin
        if exists(select id from new_uf_passthebilljournal where zzbh=new.zzbh) then
            update new_uf_passthebilljournal set id=new.id,createdate=new.createdate,modifydate=new.modifydate
            ,userid=new.userid,cfwz=new.cfwz,rfname=new.rfname,sapzzbh=new.sapzzbh,sbmc=new.sbmc,sbxh=new.sbxh
            ,ssqy=new.ssqy,zclbyj=new.zclbyj,ysrq=new.ysrq
            where zzbh=new.zzbh;
            else
            insert into new_uf_passthebilljournal(id,createdate,modifydate,userid,cfwz,rfname,sapzzbh,sbmc,sbxh
            ,ssqy,zclbyj,zzbh,ysrq)
            values (new.id,new.createdate,new.modifydate,new.userid,new.cfwz,new.rfname,new.sapzzbh,new.sbmc
            ,new.sbxh,new.ssqy,new.zclbyj,new.zzbh,new.ysrq);
        end if;
    end;$$
delimiter ;