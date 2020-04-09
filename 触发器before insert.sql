select lifnrjc,matnrjc,matnr from z_suppier_order LIMIT 100
use srm_qas;
SET SQL_SAFE_UPDATES = 0; /*修改数据库模式*/
SET SQL_SAFE_UPDATES = 1;

DELIMITER $$
DROP TRIGGER IF EXISTS z_suppier_order_trigger; 
create trigger z_suppier_order_trigger
before insert on z_suppier_order
for each row 
begin 

        if substr(new.matnr,1,1)='0' then
            set new.lifnrjc=substr(new.lifnr,5,6);
            set new.matnrjc = substr(new.matnr,9,10);
        else 
			 set new.lifnrjc = substr(new.lifnr,5,6);
             set new.matnrjc = new.matnr;
        end if;        
end;$$
DELIMITER ;