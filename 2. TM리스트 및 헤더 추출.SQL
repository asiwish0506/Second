-- tm header

DROP TABLE default.tm_list_header
CREATE TABLE default.tm_list_header AS
SELECT DISTINCT listid
     , listname
     , listtypecd
     , extracteddate
     , extractedtime
     , extractorid
     , requestcnt
     , extractedcnt 
     , isallocation
     , teamcd
     , extractedgbn
FROM telepro.tm_list_cat
WHERE listtypecd = '35'
  AND extractorid = 'K1170127';
  

-- tm list detail

DROP TABLE default.tm_list_detail;
CREATE TABLE default.tm_list_detail AS
SELECT * 
  FROM telepro.tm_list
 WHERE listid in (SELECT DISTINCT listid FROM default.tm_list_header);