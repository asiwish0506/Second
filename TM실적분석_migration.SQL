DROP TABLE default.tm_result_temp;
CREATE TABLE default.tm_result_temp AS
SELECT DISTINCT c.contactid 
       , c.s25csq					                         --계약번호 (custid랑 동일한 값임)
	   , d.custid                                            --계약번호(고객번호 아님. 고객번호는 sap.zsdt4013 테이블의 kunnr 필드)
       , c.contactstartdate
       , c.contactstarttime
       , c.contactenddate
       , c.talkenddate
       , c.contactendtime
       , c.talkendtime
       , c.userid 
       , c.ncustname
       , c.ncusttel
       , c.ncustzip
       , c.description
       , c.listid
       , b.listname
       , b.listtype                                          --리스트 타입 (화재,정전,주택)
       , b.extracteddate                                     --리스트 추출일자
	   , c.dialresultcd                                      -- 통화결과
	   , CASE WHEN c.dialresultcd IN ('NF03', 'SE05', '') THEN 0 ELSE 1 END AS call_success
	   , CASE WHEN c.dialresultcd = 'SS01' THEN 1 ELSE 0 END AS final_success
FROM telepro_raw.tb_contact c 
LEFT JOIN (SELECT DISTINCT listid, listname, listtype, extracteddate FROM default.tm_list_header) b
       ON c.listid = b.listid
LEFT JOIN (SELECT DISTINCT listseqid, custid FROM telepro_raw.tm_list) d
       ON c.listseqid = d.listseqid
WHERE contactstartdate BETWEEN '2020/04/01' AND '2020/04/30'   
AND contactmajorcd = 'T50' 
AND contactmiddlecd = 'T50T52' 
AND contactminorcd = 'T50T52T63' 
AND contactpathcd = 'T';                                      --상담유형 

 

