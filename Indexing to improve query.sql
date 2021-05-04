SPOOL task3
SET ECHO ON
SET FEEDBACK ON
SET LINESIZE 300
SET PAGESIZE 300


/*Step1: Implement select statements without indexes and produce the query plans*/

drop index IDX1;
drop index IDX2;
drop index IDX3;

/*Query 1*/
explain plan for
select count(*)
from orders join lineitem on o_orderkey = l_orderkey
join part on l_partkey = p_partkey
where p_name like 'cream%'
having count(*) > 1;
select * from table(dbms_xplan.display);
/*Query 2*/
explain plan for
select distinct(p_name)
from part join partsupp on p_partkey = ps_partkey
join lineitem on ps_partkey = l_partkey
inner join orders on l_orderkey = o_orderkey
where ps_availqty > 5000;
select * from table(dbms_xplan.display);
/*Query 3*/
explain plan for
select distinct(p_name)
from part, partsupp, supplier
where p_partkey = ps_partkey 
and ps_suppkey = s_suppkey
and s_name = 'Supplier#000002996';
select * from table(dbms_xplan.display);
/*Query 4*/
explain plan for
select sum(o_totalprice)
from orders, lineitem, partsupp, part
where o_orderkey = l_orderkey
and l_partkey = p_partkey
and ps_partkey = p_partkey
and ps_supplycost = 128.56;
select * from table(dbms_xplan.display);
/*Query 5*/
explain plan for
select s_name, s_address
from supplier join partsupp on s_suppkey = ps_suppkey
join part on ps_partkey = p_partkey
where p_retailprice = 1679.72;
select * from table(dbms_xplan.display);

/*
Step 2: Improve queries with indexes
Creating an index on :

part(p_name)
partsupp(ps_availqty)
supplier(s_name)
partsupp(supplycost)
part(retailprice)

*/
create index IDX1 on lineitem(l_partkey, l_suppkey);
create index IDX2 on part(p_retailprice);
create index IDX3 on supplier(s_name);


/*Step 3: Run the queries again*/

/*Query 1*/
explain plan for
select count(*)
from orders join lineitem on o_orderkey = l_orderkey
join part on l_partkey = p_partkey
where p_name like 'cream%'
having count(*) > 1;
select * from table(dbms_xplan.display);
/*Query 2*/
explain plan for
select distinct(p_name)
from part join partsupp on p_partkey = ps_partkey
join lineitem on ps_partkey = l_partkey
inner join orders on l_orderkey = o_orderkey
where ps_availqty > 5000;
select * from table(dbms_xplan.display);
/*Query 3*/
explain plan for
select distinct(p_name)
from part, partsupp, supplier
where p_partkey = ps_partkey 
and ps_suppkey = s_suppkey
and s_name = 'Supplier#000002996';
select * from table(dbms_xplan.display);
/*Query 4*/
explain plan for
select sum(o_totalprice)
from orders, lineitem, partsupp, part
where o_orderkey = l_orderkey
and l_partkey = p_partkey
and ps_partkey = p_partkey
and ps_supplycost = 128.56;
select * from table(dbms_xplan.display);
/*Query 5*/
explain plan for
select s_name, s_address
from supplier join partsupp on s_suppkey = ps_suppkey
join part on ps_partkey = p_partkey
where p_retailprice = 1679.72;
select * from table(dbms_xplan.display);

spool off







