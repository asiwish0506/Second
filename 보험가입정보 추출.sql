SELECT DISTINCT b.ctnum
     , b.rqnum
     , b.aedat
     , b.ins_type
     , b.ins_amt
     , b.ins_amt_type
     , b.ins_payment
     , b.ins_stat
     , b.ins_user4
     , c.ins_stat_nm
     , c.ins_amt_type_nm
  FROM (SELECT DISTINCT ctnum, ins_type, ins_amt, ins_amt_type, ins_payment, ins_stat, rqnum, aedat, ins_user4
             FROM sap.zsdt4150
            WHERE ins_type IN ('02', '03', '07')) b
LEFT JOIN (SELECT DISTINCT ctnum, rqnum, ins_stat_nm, ins_amt_type_nm FROM mart.zsdr6051) c
       ON b.ctnum = c.ctnum
      AND b.rqnum = c.rqnum