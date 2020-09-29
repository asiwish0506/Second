    SELECT conn_type
	    , COUNT(DISTINCT a.ctnum) AS ctnum_cnt
  FROM sap.zsdt4013      AS a
GROUP BY conn_type  
  WHERE a.mandt = '100' 
    AND a.stmon = '202008'  --년월 변경
    AND a.bukrs = '1000'
    AND a.cstat IN ('1','2');
