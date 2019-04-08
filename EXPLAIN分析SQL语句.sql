explain select A.*,B.username from  material_history_item_log A
left join admin B
on A.userid=B.id
where A.createDate=(select max(B.createDate) from v_material_history_item_log B where A.werks=B.werks and A.lgort=B.lgort 
and A.lgpla=B.lgpla and A.matnr=B.matnr and A.charg=B.charg and A.sonum_ex=B.sonum_ex and A.bestq=B.bestq);
