SELECT t1.*
      , t3.tm_yn AS first_tm_yn 
      , t2.tm_yn AS last_tm_yn
  FROM (SELECT ctnum
             , MIN(erdat) AS first_dt  
			 , MAX(erdat) AS last_dt
         FROM sap_raw.zsdt3748
      GROUP BY ctnum) AS t1
   LEFT JOIN  sap_raw.zsdt3748   AS t2
         ON t1.ctnum = t2.ctnum
        AND t1.last_dt = t2.erdat
   LEFT JOIN  sap_raw.zsdt3748   AS t3
         ON t1.ctnum = t3.ctnum
        AND t1.first_dt = t3.erdat;     