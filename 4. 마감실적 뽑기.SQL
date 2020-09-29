WITH t1 AS (
SELECT DISTINCT a.listseqid 
     , a.listid
     , b.listname
     , CASE WHEN listname LIKE '%정전%' THEN '정전'
           WHEN listname LIKE '%주택%' THEN '주택'
		   ELSE '화재' END AS listtype
     , b.extracteddate
     , a.custid
     , a.resultcd
     , a.dialdate
     , a.dialtime
     , c.contactstartdate
     , c.contactstarttime
     , c.contactenddate
     , c.contactendtime
     , CASE WHEN a.resultcd IN ('NF03', 'SE05', '') THEN 0 ELSE 1 END AS call_success
     , CASE WHEN a.resultcd = 'SS01' THEN 1 ELSE 0 END AS final_success
  FROM (SELECT DISTINCT listseqid, listid, custid, dialdate, dialtime, resultcd FROM default.tm_list_detail) a
 LEFT JOIN (SELECT DISTINCT listid, listname, extracteddate FROM default.tm_list_header) b 
        ON a.listid = b.listid
 LEFT JOIN (SELECT DISTINCT listseqid, listid, contactstartdate, contactstarttime, contactenddate, contactendtime
              FROM telepro.tb_contact) c
        ON a.listseqid = c.listseqid
 WHERE a.dialdate LIKE '2020/08%'
)

 -- 마감 실적 뽑기
 
 SELECT listid
     , listname
     , extracteddate
	 , listtype
     , COUNT(DISTINCT custid) AS cust_cnt
     , COUNT(custid) AS call_cnt
     , COUNT(DISTINCT CASE WHEN call_success = 1 THEN custid ELSE NULL END) AS call_success_cnt
     , COUNT(DISTINCT CASE WHEN final_success = 1 THEN custid ELSE NULL END) AS final_success_cnt
  FROM t1
GROUP BY listid, listtype, listname, extracteddate
ORDER BY listid 

