DROP TABLE default.tm_result;
CREATE TABLE default.tm_result AS
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
        ON a.listid = b.listid;