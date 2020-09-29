-- 기존 미처리 db

 SELECT COUNT(DISTINCT a.custid)
   FROM tm_list_detail a
LEFT JOIN tm_list_header b
       ON a.listid = b.listid
  WHERE b.extracteddate < '2020/04/01'
    AND a.dialdate = ''


--  기접촉 유치실패 건

 CREATE TABLE default.hj_temp AS
 SELECT ROW_NUMBER() OVER (PARTITION BY custid ORDER BY dialdate DESC, dialtime DESC) AS rownum
      , custid, dialdate, dialtime, resultcd
   FROM telepro_raw.tm_list
  WHERE listid IN (SELECT DISTINCT listid FROM default.tm_list_header);


SELECT DISTINCT *
  FROM default.hj_temp
 WHERE rownum = 1;