-- 실적자료 뽑기 전 temp table

DROP TABLE default.tm_result_temp;
CREATE TABLE default.tm_result_temp AS
SELECT DISTINCT a.listid
     , b.listname
     , b.extracteddate
     , b.listtype
     , a.custid
     , a.resultcd
     , a.dialdate
     , a.dialtime
     , CASE WHEN a.resultcd IN ('NF03', 'SE05', '') THEN 0 ELSE 1 END AS call_success
     , CASE WHEN a.resultcd = 'SS01' THEN 1 ELSE 0 END AS final_success
  FROM (SELECT DISTINCT listid, custid, dialdate, dialtime, resultcd FROM default.tm_list_detail) a
 LEFT JOIN (SELECT DISTINCT listid, listname, listtype, extracteddate FROM default.tm_list_header) b 
        ON a.listid = b.listid
 WHERE a.dialdate LIKE '2020/05%';

-- telepro_raw.tb_contact 테이블까지 조인

CREATE TABLE default.tm_result_temp_2 AS
SELECT DISTINCT a.listseqid 
     , a.listid
     , b.listname
     , b.extracteddate
     , b.listtype
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
 LEFT JOIN (SELECT DISTINCT listid, listname, listtype, extracteddate FROM default.tm_list_header) b 
        ON a.listid = b.listid
 LEFT JOIN (SELECT DISTINCT listseqid, listid, contactstartdate, contactstarttime, contactenddate, contactendtime
              FROM telepro_raw.tb_contact) c
        ON a.listseqid = c.listseqid
 WHERE a.dialdate LIKE '2020/05%';