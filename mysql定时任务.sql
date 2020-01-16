#查看event是否开启 : SHOW VARIABLES LIKE '%event_sche%';
#将事件计划开启 : SET GLOBAL event_scheduler = 1;
#将事件计划关闭 : SET GLOBAL event_scheduler = 0;
#关闭事件任务 : ALTER EVENT eventName ON COMPLETION PRESERVE DISABLE;
#开启事件任务 : ALTER EVENT eventName ON COMPLETION PRESERVE ENABLE;
#查看事件任务 : SHOW EVENTS ;

#创建一个存储过程
DELIMITER //
DROP PROCEDURE IF EXISTS p_test//
CREATE PROCEDURE p_test() 
BEGIN
     NSERT INTO test(name, create_time) values('testName', now());
END//

#设置定时任务调用这个存储过程（从2015.8.8 1点每十秒执行一次）
DROP EVENT IF EXISTS e_test//
CREATE EVENT e_test
ON SCHEDULE EVERY 10 second STARTS TIMESTAMP '2015-08-08 01:00:00'
ON COMPLETION PRESERVE
DO
BEGIN
CALL p_test();
END//

/*备注：在event事件中：ON SCHEDULE 计划任务，有两种设定计划任务的方式：
1. AT 时间戳，用来完成单次的计划任务。
2. EVERY 时间（单位）的数量时间单位[STARTS 时间戳] [ENDS时间戳]，用来完成重复的计划任务。
在两种计划任务中，时间戳可以是任意的TIMESTAMP 和DATETIME 数据类型，时间戳需要大于当前时间。
在重复的计划任务中，时间（单位）的数量可以是任意非空（Not Null）的整数式，时间单位是关键词：YEAR，MONTH，DAY，HOUR，MINUTE 或者SECOND。
提示: 其他的时间单位也是合法的如：QUARTER, WEEK, YEAR_MONTH,DAY_HOUR,DAY_MINUTE,DAY_SECOND,HOUR_MINUTE,HOUR_SECOND, MINUTE_SECOND，不建
使用这些不标准的时间单位。
 [ON COMPLETION [NOT] PRESERVE]
 
ON COMPLETION参数表示"当这个事件不会再发生的时候"，即当单次计划任务执行完毕后或当重复性的计划任务执行到了ENDS阶段。而PRESERVE的作用是使事件在执行完毕后不会
被Drop掉，建议使用该参数，以便于查看EVENT具体信息。*/

#例：
DELIMITER $$
ALTER DEFINER=`root`@`%` EVENT `AutoFinishNightCase` ON SCHEDULE EVERY 1 DAY STARTS '2018-09-17 09:00:00' ON COMPLETION PRESERVE ENABLE DO BEGIN 
    DECLARE goodIds VARCHAR(255) DEFAULT '';     
    SELECT @goodIds:=CONCAT((SELECT TRIM(EnumValue) FROM table1 WHERE DictionaryName='NightRegisterGoodId'));
    UPDATE table2  AS caseinfo  INNER JOIN 
    (SELEC Ttable3.`Id`   FROM Ttable3 WHERE FIND_IN_SET(Ttable3.`GoodId`, @goodIds))p 
    SET caseinfo.`CaseStatus`=40  
    WHERE caseinfo.RegistrationId=p.id   AND (caseinfo.casestatus=0 OR caseinfo.casestatus=2) AND `CreateTime`<DATE_FORMAT(NOW(),'%Y-%m-%d 09:00:00');
END$$
DELIMITER ;

#DEFINER：创建者；
#ON COMPLETION [NOT] PRESERVE ：表示当事件不会再发生的情况下，删除事件（注意特定时间执行的事件，如果设置了该参数，
#执行完毕后，事件将被删除，不想删除的话可以设置成ON COMPLETION PRESERVE）；
#ENABLE：表示系统将执行这个事件；
DROP EVENT IF EXISTS `event_minute`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `event_minute` ON SCHEDULE EVERY 1 MINUTE STARTS '2016-01-17 14:49:43' 
ON COMPLETION NOT PRESERVE ENABLE 
DO  
BEGIN    
    INSERT INTO USER(name, address,addtime) VALUES('test1','test1',now());    
    INSERT INTO USER(name, address,addtime) VALUES('test2','test2',now());
END;;
DELIMITER ;

