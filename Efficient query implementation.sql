spool task1

set echo on
set feedback on
set linesize 300
set pagesize 100
/*
Access the tables as little as possible

*/

/* 01 
*/

explain plan for 
SELECT   L_SUPPKEY, COUNT(*)
FROM     LINEITEM
GROUP BY L_SUPPKEY
UNION
SELECT   S_SUPPKEY, 0
FROM     SUPPLIER
WHERE    S_SUPPKEY NOT IN ( SELECT L_SUPPKEY
                            FROM   LINEITEM );
select * from table(dbms_xplan.display);


explain plan for 
select s_suppkey, count(l_suppkey)
from supplier full outer join lineitem
on s_suppkey = l_suppkey
group by s_suppkey;
select * from table(dbms_xplan.display);


/* 02 
*/

explain plan for 	
SELECT P_NAME
FROM PART
WHERE 4 <= ( SELECT COUNT(*)
             FROM PARTSUPP
	     WHERE PART.P_PARTKEY = PARTSUPP.PS_PARTKEY );
select * from table(dbms_xplan.display);	

explain plan for 			
select p_name
from partsupp, part
where p_partkey = ps_partkey
group by p_partkey, p_name
having count(*) <= 4;
select * from table(dbms_xplan.display);				

/* 03 
*/
explain plan for 
SELECT DISTINCT O_ORDERDATE, (SELECT COUNT(*)
                              FROM ORDERS OS
                              WHERE OS.O_ORDERDATE = ORDERS.O_ORDERDATE) TOTAL
FROM ORDERS;
select * from table(dbms_xplan.display);

explain plan for 			
SELECT O_ORDERDATE, count(*) TOTAL
FROM ORDERS o2
Where o_orderdate = o2.o_orderdate
GROUP BY O_ORDERDATE;
select * from table(dbms_xplan.display);


/* 04 */
CREATE INDEX IDX ON ORDERS(O_ORDERDATE);

explain plan for 
SELECT *
FROM ORDERS
WHERE (TO_CHAR(O_ORDERDATE,'DD-MON-YY') = '23-MAR-97' AND O_TOTALPRICE > 2) OR (NOT O_CUSTKEY > 3 AND TO_CHAR(O_ORDERDATE, 'DD-MON-YYYY') = '23-MAR-1997'); 
select * from table(dbms_xplan.display);


explain plan for 
select * from orders
where TO_CHAR(o_orderdate,'DD-MON-YY') = '23-MAR-97' and (o_totalprice > 2 or o_custkey <= 3); 
select * from table(dbms_xplan.display);

DROP INDEX IDX;

/* 05 
*/
CREATE INDEX IDX ON ORDERS(O_CLERK);

explain plan for 	
SELECT DISTINCT O_ORDERDATE
FROM ORDERS
WHERE NOT EXISTS (SELECT O_ORDERSTATUS
                  FROM ORDERS) OR O_CLERK =  'Clerk#000000859';
select * from table(dbms_xplan.display);

explain plan for 	
select distinct o_orderdate
from orders
where o_clerk =  'Clerk#000000859' or o_orderstatus = null;
select * from table(dbms_xplan.display);

DROP INDEX IDX;

/* 06 */

explain plan for 			
SELECT DISTINCT O_TOTALPRICE
FROM ORDERS
WHERE NOT EXISTS (SELECT O_TOTALPRICE
                  FROM ORDERS OS
                  WHERE OS.O_TOTALPRICE > ORDERS.O_TOTALPRICE);
select * from table(dbms_xplan.display);

explain plan for 	
SELECT max(O_TOTALPRICE)
FROM ORDERS;
select * from table(dbms_xplan.display);

spool off
