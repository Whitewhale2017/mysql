
create view v_worthless_factory_item_log
as
select a.id,a.userid,a.createdate,a.ausme,a.bestq,a.charg,a.checked,a.cinsm,a.clabs,a.cspem,a.gesme,a.lgort,a.lgpla,a.lgtyp,a.matnr
	,a.quantity,a.saved,a.sobkz,a.sonum,a.sonum_ex,a.verme,a.werks,b.username,a.currentdate,a.currentmonth,a.zzdiscr,a.zzguige,a.zzposnr,left(a.createdate,10) as cdate
    from worthless_factory_item_log a
left join admin b on a.userid=b.id;

select * from new_worthless_factory_item_log;
#create table new_worthless_factory_item_log as select * from worthless_factory_item_log;

truncate table new_worthless_factory_item_log;

select id,userid,createdate,ausme,bestq,charg,checked,cinsm,clabs,cspem,gesme,lgort,lgpla,lgtyp,matnr
	,quantity,saved,sobkz,sonum,sonum_ex,verme,werks,username,currentdate,currentmonth,zzdiscr,zzguige,zzposnr
from worthless_factory_item_log;

use barcode_dev;
DELIMITER $$
##DROP TRIGGER IF EXISTS tri_new_material_history_item_log; 
create trigger tri_new_worthless_factory_item_log
after insert 
on worthless_factory_item_log
for each row
begin
   DECLARE res VARCHAR(40);
   set res=(select username from admin where id=new.userid);
   if exists(select id from new_worthless_factory_item_log
   where werks=new.werks and lgort=new.lgort and lgpla=new.lgpla and matnr=new.matnr and charg=new.charg and sonum_ex=new.sonum_ex and bestq=new.bestq)
   then
	update new_worthless_factory_item_log 
    set id=new.id,userid=new.userid,username=res,quantity=new.quantity,createdate=new.createdate,ausme=new.ausme,checked=new.checked,cinsm=new.cinsm
    ,clabs=new.clabs,cspem=new.cspem,gesme=new.gesme,lgtyp=new.lgtyp,saved=new.saved,sobkz=new.sobkz,sonum=new.sonum,verme=new.verme,
    currentdate=left(new.createdate,10),currentmonth=new.currentmonth,zzdiscr=new.zzdiscr,zzguige=new.zzguige,zzposnr=new.zzposnr
	where werks=new.werks and lgort=new.lgort and lgpla=new.lgpla and matnr=new.matnr and charg=new.charg and sonum_ex=new.sonum_ex and bestq=new.bestq;
   else 
	insert into new_worthless_factory_item_log(id,userid,createdate,ausme,bestq,charg,checked,cinsm,clabs,cspem,gesme,lgort,lgpla,lgtyp,matnr
	,quantity,saved,sobkz,sonum,sonum_ex,verme,werks,username,currentdate,currentmonth,zzdiscr,zzguige,zzposnr) 
	values (new.id,new.userid,new.createdate,new.ausme,new.bestq,new.charg,new.checked,new.cinsm,new.clabs,new.cspem,new.gesme,new.lgort,new.lgpla,new.lgtyp,new.matnr
	,new.quantity,new.saved,new.sobkz,new.sonum,new.sonum_ex,new.verme,new.werks,res,left(new.createdate,10),new.currentmonth,new.zzdiscr,new.zzguige,new.zzposnr);
   end if;
end;$$
DELIMITER ;

drop trigger tri_new_worthless_factory_item_log;