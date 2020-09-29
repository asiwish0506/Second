-- TM 필터링 프로세스

SELECT a.ctnum, a.tm_yn
  FROM default.monthly_deadline_202004_hj a
 WHERE a.conn_type IN ('A01', 'A02')
   AND a.monexp_amt BETWEEN 300 AND 4000
   AND a.itype_l = '1'
   AND a.gross_type <> 'Y'
