use barcode_qas;


select * from material_history_item_log;
select count(*) from material_history_check_ltem;
select count(*) from material_history_item_log ;

select * from material_history_item_log 
where (werks,lgort,lgpla,matnr,maktx,lgtyp
,charg,sonum_ex,bestq,gesme,createDate) 
in
(
select werks,lgort,lgpla,matnr,maktx,lgtyp
,charg,sonum_ex,bestq,gesme,createDate 
from material_history_item_log
group by werks,lgort,lgpla,matnr,maktx,lgtyp
,charg,sonum_ex,bestq,gesme,createDate
having count(*)>1
);


SET SQL_SAFE_UPDATES = 0; /*修改数据库模式*/
SET SQL_SAFE_UPDATES = 1; /*修改数据库模式，安全模式下无法delete或者update非查询的数据*/
delete from material_history_item_log
where id in (
select * from (                        /*mysql delete或者update语句后不能直接跟随本表，需要封装一层或者使用join语句*/
select id from material_history_item_log 
where (werks,lgort,lgpla,matnr,maktx,lgtyp
,charg,sonum_ex,bestq,gesme,createDate) 
in
(
select werks,lgort,lgpla,matnr,maktx,lgtyp
,charg,sonum_ex,bestq,gesme,createDate 
from material_history_item_log
group by werks,lgort,lgpla,matnr,maktx,lgtyp
,charg,sonum_ex,bestq,gesme,createDate
having count(*)>1
)
and id not in (
select max(id)
from material_history_item_log
group by werks,lgort,lgpla,matnr,maktx,lgtyp
,charg,sonum_ex,bestq,gesme,createDate
having count(*)>1
)
) t
);
