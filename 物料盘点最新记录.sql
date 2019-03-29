DELIMITER $$
create trigger tri_new_material_history_item_log
after insert 
on material_history_item_log
for each row
begin
   if exists(select 1 from new_material_history_item_log A 
   where A.werks=Bnew.werks and A.lgort=new.lgort and A.lgpla=new.lgpla and A.matnr=new.matnr and A.charg=new.charg and A.sonum_ex=new.sonum_ex and A.bestq=new.bestq)
   then
   update new_material_history_item_log A set A.createdate=new.createdate 
   where A.werks=Bnew.werks and A.lgort=new.lgort and A.lgpla=new.lgpla and A.matnr=new.matnr and A.charg=new.charg and A.sonum_ex=new.sonum_ex and A.bestq=new.bestq;
  else
   insert into new_material_history_item_log values (new.id,new.createdate,new.modifydate,new.userid,new.ausme,new.bestq,new.charg,new.checked,new.cinsm,new.clabs,
   new.cspem,new.currentdate,new.currentmonth,new.gesme,new.lgort,new.lgpla,new.lgtyp,new.maktx,new.quantity,new.saved,new.sobkz,new.sonum,new.sonum_ex,new.spnum,new.verme,
   new.werks);
  end if;
end;$$
DELIMITER ; 

drop trigger tri_new_material_history_item_log;

select * from material_history_item_log;
select * from new_material_history_item_log;
truncate table new_material_history_item_log;
