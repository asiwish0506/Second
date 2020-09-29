SELECT DISTINCT a.ctnum, b.ctnum, a.gad_start, a.stmon
  FROM sap.zsdt4013 a
LEFT JOIN (select distinct ctnum_hash, ctnum from adt_work.hash_info) b
       ON a.ctnum = b.ctnum_hash
 WHERE regexp_like(a.gad_start, '202008')  
   AND a.stmon = '202008'
