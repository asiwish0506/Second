    SELECT a.kcalss
	 , d.kunnr
	 , d.ctnum
     , a.conn_dept
     , a.conn_emp
     , a.cost_dept
     , a.cost_emp
     , a.ctnum
     , a.cstat
     , a.gad_name
     , a.gad_start
     , a.conn_start
     , a.conn_end
     , CAST(a.monexp_amt AS DOUBLE) AS monexp_amt
     , a.conn_type
     , a.ctype_l
     , a.ctype_m
     , a.intro_asp
     , a.itype_l
     , a.itype_m
     , a.itype_s
     , a.itype_sdesc
     , a.kunnr
     , c.name1
     , a.gad_add01
     , a.post_add01
     , a.first_bildate
     , c.telf2
--     , (SELECT ETAX_EMAIL FROM SAP.ZSDT4021 WHERE CTNUM = A.CTNUM AND RQNUM = A.RQNUM AND AMT_TYPE = 'F3' AND MANDT = '100') AS 전자계산서EMAIL
--     , (SELECT GROS_CODE FROM SAP.ZSDT1110 WHERE KUNNR = A.KUNNR AND MANDT = '100' AND BUKRS = '1000') AS GROSCODE
     , a.svc_str
     , a.pay_type
     , a.depo_type
     , a.line_type
     , a.pck_str
--     , (SELECT BIR_DATE FROM SAP.ZSDT1110 WHERE KUNNR = A.KUNNR AND MANDT = '100' AND BUKRS = '1000') AS 생년월일
     , SUBSTR(c.stcd1, 1 ,6) AS B_YMD
     , SUBSTR(c.stcd1, 7 ,1) AS SEX
     , c.stcd2
     , a.gros_code
     , a.gross_type
     , a.kvgr4
     , a.gad_pstlz
     , a.gad_add02
     , a.post_add02
     , b.result1
     , b.result2
     , b.result3
     , b.result4
     , b.result5
     , b.result6
     , b.sms_yn
     , b.email_yn
     , b.tm_yn
     , b.dm_yn
     , b.sk1_yn
     , b.sk2_yn
     , b.adt1_yn
     , b.aedat
     , b.aenam
  FROM sap.zsdt4013      AS a 
  LEFT JOIN (SELECT ctnum, kunnr, sms_yn, email_yn, tm_yn, dm_yn, sk1_yn, sk2_yn, adt1_yn, aedat, aenam, result1, result2, result3, result4, result5, result6 FROM sap.zsdt3748 WHERE usest = 'X') AS b
        ON a.ctnum = b.ctnum
  LEFT JOIN (SELECT kunnr, stcd2, stcd1, telf2, name1 FROM sap.kna1 WHERE mandt = '100') AS c
        ON a.kunnr = c.kunnr
LEFT JOIN (select distinct ctnum_hash, ctnum, kunnr_hash, kunnr from adt_work.hash_info) d
       ON a.ctnum = d.ctnum_hash
  WHERE a.mandt = '100' 
    AND a.stmon = '202007'  --년월 변경
    AND a.bukrs = '1000'
    AND a.cstat IN ('1','2');
