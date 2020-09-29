WITH t1 AS 
(SELECT DISTINCT a.s25csq -- 계약번호 
     , b.kunnr
	 , a.custname -- 상호 (hashing처리되니까 현재로서는 어차피 무의미함)
     , a.listid
	 , a.contactstartdate
	 , a.contactstarttime
	 , a.dialresultcd
  FROM telepro.tb_contact a
  LEFT JOIN (SELECT DISTINCT ctnum, kunnr FROM sap.zsdt4013) b
         ON a.s25csq = b.ctnum
 WHERE a.listid IN (SELECT DISTINCT listid FROM default.tm_list_header))
 
, t2 AS
(SELECT *
     , CASE WHEN contactstartdate = '' THEN '9999/99/99' ELSE contactstartdate END AS contactstartdate_new
     , DENSE_RANK() OVER (PARTITION BY s25csq ORDER BY s25csq, listid) AS nth_contact_ctnum
	 , ROW_NUMBER() OVER (PARTITION BY s25csq, listid ORDER BY contactstartdate DESC, contactstarttime DESC) AS row_num_ctnum
     , DENSE_RANK() OVER (PARTITION BY kunnr ORDER BY kunnr, listid) AS nth_contact_kunnr
	 , ROW_NUMBER() OVER (PARTITION BY kunnr, listid ORDER BY contactstartdate DESC, contactstarttime DESC) AS row_num_kunnr
   FROM t1)
   
, t3 AS
(SELECT *
     , LAG(nth_contact_final_date_ctnum) OVER (PARTITION BY s25csq ORDER BY s25csq, listid) AS prior_contact_final_date_ctnum
     , LAG(nth_contact_final_date_kunnr) OVER (PARTITION BY kunnr ORDER BY kunnr, listid) AS prior_contact_final_date_kunnr    
  FROM (SELECT *
             , MAX(contactstartdate) OVER (PARTITION BY s25csq, listid ORDER BY s25csq, listid) AS nth_contact_final_date_ctnum
	         , MIN(contactstartdate_new) OVER (PARTITION BY s25csq, listid ORDER BY s25csq, listid) AS nth_contact_first_date_ctnum
             , MAX(contactstartdate) OVER (PARTITION BY kunnr, listid ORDER BY kunnr, listid) AS nth_contact_final_date_kunnr
	         , MIN(contactstartdate_new) OVER (PARTITION BY kunnr, listid ORDER BY kunnr, listid) AS nth_contact_first_date_kunnr	         
          FROM t2)
ORDER BY s25csq, kunnr, listid, contactstartdate, contactstarttime)

SELECT a.*
   FROM t3 a;
 
