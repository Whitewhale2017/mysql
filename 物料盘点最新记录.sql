use barcode_dev;
DELIMITER $$
DROP TRIGGER IF EXISTS tri_new_material_history_item_log; 
create trigger tri_new_material_history_item_log
after insert 
on material_history_item_log
for each row
begin
   DECLARE res VARCHAR(40);
   set res=(select username from admin where id=new.userid);
   if res not like 'CW%' then
   if exists(select id from new_material_history_item_log
   where werks=new.werks and lgort=new.lgort and lgpla=new.lgpla and matnr=new.matnr and charg=new.charg and sonum_ex=new.sonum_ex and bestq=new.bestq)
   then
	update new_material_history_item_log 
    set id=new.id,userid=new.userid,username=res,quantity=new.quantity,createdate=new.createdate,ausme=new.ausme,checked=new.checked,cinsm=new.cinsm
    ,clabs=new.clabs,cspem=new.cspem,gesme=new.gesme,lgtyp=new.lgtyp,maktx=new.maktx,saved=new.saved,sobkz=new.sobkz,sonum=new.sonum,verme=new.verme,
    currentdate=left(new.createdate,10),currentmonth=new.currentmonth
	where werks=new.werks and lgort=new.lgort and lgpla=new.lgpla and matnr=new.matnr and charg=new.charg and sonum_ex=new.sonum_ex and bestq=new.bestq;
  else
	insert into new_material_history_item_log(id,userid,createdate,ausme,bestq,charg,checked,cinsm,clabs,cspem,gesme,lgort,lgpla,lgtyp,maktx,matnr
	,quantity,saved,sobkz,sonum,sonum_ex,verme,werks,username,currentdate,currentmonth) 
	values (new.id,new.userid,new.createdate,new.ausme,new.bestq,new.charg,new.checked,new.cinsm,new.clabs,new.cspem,new.gesme,new.lgort,new.lgpla,new.lgtyp,new.maktx,new.matnr
	,new.quantity,new.saved,new.sobkz,new.sonum,new.sonum_ex,new.verme,new.werks,res,left(new.createdate,10),new.currentmonth);
end if;
end if;
end;$$
DELIMITER ;

drop trigger tri_new_material_history_item_log;

select * from v_material_history_item_log order by createdate desc;
select * from material_history_item_log order by createdate desc;
select * from new_material_history_item_log  order by createdate desc;

SET SQL_SAFE_UPDATES = 0; /*修改数据库模式*/
SET SQL_SAFE_UPDATES = 1; /*修改数据库模式，安全模式下无法delete或者update非查询的数据*/
update new_material_history_item_log set currentdate=left(createdate,10) where id='402884f26a2fb7ba016a33030cea3c65'


drop table if exists new_material_history_item_log;  ##存储非财务账号掌机盘点物料的最新数据
create table new_material_history_item_log
as
select * from  material_history_item_log A  limit 0,1
where createDate=(select max(createDate) from v_material_history_item_log B where A.werks=B.werks and A.lgort=B.lgort 
and A.lgpla=B.lgpla and A.matnr=B.matnr and A.charg=B.charg and A.sonum_ex=B.sonum_ex and A.bestq=B.bestq);

insert into new_material_history_item_log 
select A.*,B.username from  material_history_item_log A
left join admin B
on A.userid=B.id
where A.createDate=(select max(B.createDate) from v_material_history_item_log B where A.werks=B.werks and A.lgort=B.lgort 
and A.lgpla=B.lgpla and A.matnr=B.matnr and A.charg=B.charg and A.sonum_ex=B.sonum_ex and A.bestq=B.bestq);


/*truncate table new_material_history_item_log;*/

select * from new_material_history_item_log limit 0,1

create table cw_new_material_history_item_log
as
select * from new_material_history_item_log limit 0,1;
select * from cw_new_material_history_item_log; ##存储财务掌机账号盘点的数据
truncate table cw_new_material_history_item_log;

select * from barcode_dev.admin where username not regexp '^CW'
######################################
DELIMITER $$
DROP TRIGGER IF EXISTS tri_cw_new_material_history_item_log; 
create trigger tri_cw_new_material_history_item_log
after insert 
on material_history_item_log
for each row
begin
   DECLARE res VARCHAR(40);
   set res=(select username from admin where id=new.userid);
   if res regexp '^CW' then
     if exists(select id from cw_new_material_history_item_log
        where werks=new.werks and lgort=new.lgort and lgpla=new.lgpla and matnr=new.matnr and charg=new.charg and sonum_ex=new.sonum_ex and bestq=new.bestq)
       then
	    update cw_new_material_history_item_log 
        set id=new.id,userid=new.userid,username=res,quantity=new.quantity,createdate=new.createdate,ausme=new.ausme,checked=new.checked,cinsm=new.cinsm
        ,clabs=new.clabs,cspem=new.cspem,gesme=new.gesme,lgtyp=new.lgtyp,maktx=new.maktx,saved=new.saved,sobkz=new.sobkz,sonum=new.sonum,verme=new.verme,
        currentdate=left(new.createdate,10),currentmonth=new.currentmonth
	    where werks=new.werks and lgort=new.lgort and lgpla=new.lgpla and matnr=new.matnr and charg=new.charg and sonum_ex=new.sonum_ex and bestq=new.bestq;
     else
	  insert into cw_new_material_history_item_log(id,userid,createdate,ausme,bestq,charg,checked,cinsm,clabs,cspem,gesme,lgort,lgpla,lgtyp,maktx,matnr
	  ,quantity,saved,sobkz,sonum,sonum_ex,verme,werks,username,currentdate,currentmonth) 
	  values (new.id,new.userid,new.createdate,new.ausme,new.bestq,new.charg,new.checked,new.cinsm,new.clabs,new.cspem,new.gesme,new.lgort,new.lgpla,new.lgtyp,new.maktx,new.matnr
	   ,new.quantity,new.saved,new.sobkz,new.sonum,new.sonum_ex,new.verme,new.werks,res,left(new.createdate,10),new.currentmonth);
    end if;
end if;
end;$$
DELIMITER ;
#####################

drop trigger tri_cw_new_material_history_item_log；##报错
SHOW CREATE TRIGGER  tri_new_material_history_item_log;
show triggers;
DROP TRIGGER IF EXISTS tri_cw_new_material_history_item_log; ##不报错

select createdate,username from new_material_history_item_log order by createdate desc;
select createdate,username from new_material_history_item_log where username like 'CW%';
delete from new_material_history_item_log where username like 'CW%';

select createdate,username from cw_new_material_history_item_log;

insert into new_material_history_item_log(id,createdate,ausme,checked,cinsm,clabs,cspem,gesme,quantity,saved,verme,werks) 
values ('123','2019-03-29 11:09:33','0',0,0,0,0,117,117,0,117,1001);

truncate table new_material_history_item_log;

/*
alter 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`%` 
    SQL SECURITY DEFINER
VIEW `v_material_history_item_log` AS
    SELECT 
        `m`.`id` AS `id`,
        LEFT(`m`.`createDate`, 19) AS `createDate`,
        LEFT(`m`.`createDate`, 10) AS `cDate`,
        `m`.`modifyDate` AS `modifyDate`,
        `m`.`userId` AS `userId`,
        `m`.`ausme` AS `ausme`,
        `m`.`bestq` AS `bestq`,
        `m`.`charg` AS `charg`,
        `m`.`checked` AS `checked`,
        `m`.`cinsm` AS `cinsm`,
        `m`.`clabs` AS `clabs`,
        `m`.`cspem` AS `cspem`,
        `m`.`currentDate` AS `currentDate`,
        `m`.`currentMonth` AS `currentMonth`,
        `m`.`gesme` AS `gesme`,
        `m`.`lgort` AS `lgort`,
        `m`.`lgpla` AS `lgpla`,
        `m`.`lgtyp` AS `lgtyp`,
        `m`.`maktx` AS `maktx`,
        `m`.`matnr` AS `matnr`,
        `m`.`quantity` AS `quantity`,
        `m`.`saved` AS `saved`,
        `m`.`sobkz` AS `sobkz`,
        `m`.`sonum` AS `sonum`,
        `m`.`sonum_ex` AS `sonum_ex`,
        `m`.`spnum` AS `spnum`,
        `m`.`verme` AS `verme`,
        `m`.`werks` AS `werks`,
        `a`.`username` AS `username`
    FROM
        (`material_history_item_log` `m`
        LEFT JOIN `admin` `a` ON ((`a`.`id` = `m`.`userId`)))
        */
