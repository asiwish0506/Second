-----TM정보조회

SELECT  DIALDATE,   
			DIALTIME,
             Custid,  custname, TM_LIST.teamcd, 
              Mymemo,
			(select  codename  
                from tb_code_book with (nolock)
             where codetype   = 'lst016' and  code = TM_LIST.resultcd
             ) resultcd,
			(select listname from tm_list_cat  WITH (NOLOCK)    where listid = TM_LIST.LISTID) Listnm,   
			ISNULL(TELNO1, ISNULL(TELNO2, TELNO3)) TELNO,
              TM_LIST.LISTID, ALLOCCHARGERID, LISTSEQID,
			contact,
              zipaddr,
			description,
			(select LISTTYPECD from tm_list_cat  WITH (NOLOCK)    where listid = TM_LIST.LISTID) LISTTYPECD,
			PDTASKID,
			(select CONTACTTYPECD from TM_PDTASK  WITH (NOLOCK)    where LISTID = TM_LIST.LISTID) CONTACTTYPECD,
			(select PDTASKNAME from TM_PDTASK  WITH (NOLOCK)    where LISTID = TM_LIST.LISTID) PDTASKNAME,
			(select S25CCD from TS25CTA0  WITH (NOLOCK)    where S25CSQ = TM_LIST.Custid) S25CCD,
			MKTPGMID
FROM TM_LIST WITH (NOLOCK)   outer apply (
							select top 1 contactid as contact ,description 
							from tb_contact with (nolock)
							where tb_contact.listseqid= TM_LIST.listseqid 
							and description is not null
							order by contactid desc
							) as x
JOIN TM_LIST_CAT WITH (NOLOCK) ON TM_LIST.LISTID = TM_LIST_CAT.LISTID
WHERE DIALDATE Between :as_sdate AND :as_edate																	//상담일자
AND :as_userid = (case when :as_userid = '%' then '%' else TM_LIST.ALLOCCHARGERID end)				//접수자
AND :as_result = (case when :as_result = '%' then '%' else TM_LIST.RESULTCD end)							//결과
AND :as_teamcd = (case when :as_teamcd = '%' then '%' else TM_LIST.teamcd end)							//팀구분
AND :as_typecd = (case when :as_typecd = '%' then '%' else TM_LIST_CAT.LISTTYPECD end)					//리스트유형
AND LISTSEQID IN (SELECT LISTSEQID FROM DBO.TB_CONTACT WITH (NOLOCK) WHERE LISTSEQID = TM_LIST.listseqid GROUP BY LISTSEQID HAVING COUNT(*) LIKE :as_cnt)	//회차


------TM모니터링
1. TM별상담원
 select tm_list_cat.listname,
		(case when tb_user.username = '' or  tb_user.username is null then tm_list.allocchargerid else tb_user.username end) username,
		tm_list.allocchargerid,
		tm_list_cat.listid,
		sum(case when ltrim(tm_list.resultcd) = '' or tm_list.resultcd is null then 0 else 1 end) totcnt,			--합계
		sum(case when ltrim(tm_list.resultcd) = 'SS01' then 1 else 0 end) ss01cnt,		--유치완료
		sum(case when ltrim(tm_list.resultcd) = 'SS02' then 1 else 0 end) ss02cnt,		--중도취소
		sum(case when ltrim(tm_list.resultcd) = 'SS03' then 1 else 0 end) ss03cnt,		--거절
		sum(case when ltrim(tm_list.resultcd) = 'SE01' then 1 else 0 end) se01cnt,		--TM거부
		sum(case when ltrim(tm_list.resultcd) = 'NF05' then 1 else 0 end) nf05cnt,		--가망재통화
		sum(case when ltrim(tm_list.resultcd) = 'SS05' then 1 else 0 end) ss05cnt,		--단순재통화
		sum(case when ltrim(tm_list.resultcd) = 'SS06' then 1 else 0 end) ss06cnt,		--부재중
		sum(case when ltrim(tm_list.resultcd) = 'NF03' then 1 else 0 end) nf03cnt,		--실패-무응답	
		sum(case when ltrim(tm_list.resultcd) = 'SE05' then 1 else 0 end) se05cnt,		--오류번호
		sum(case when ltrim(tm_list.resultcd) = 'SE04' then 1 else 0 end) se04cnt		--TM-자체제외

   from tm_list WITH (NOLOCK) left outer join tb_user on  tm_list.allocchargerid = tb_user.userid, 
          tm_list_cat WITH (NOLOCK), tm_pdtask WITH (NOLOCK)
  where tm_list.listid = tm_list_cat.listid
    and tm_pdtask.listid = tm_list_cat.listid
 AND ( tm_list_cat.extracteddate Between '2018/01/01' AND '2018/02/01' ) 
 AND ( tm_list.dialDate Between '2018/01/02' AND '2018/02/02' ) 
 AND (  tm_list_cat.listtypecd = '35' ) 
 AND tm_pdtask.statuscd = 'PROC'  
 AND tm_list_cat.listtypecd <> '01'  
 AND ltrim(tm_list.allocchargerid) <> ''  
 AND tm_list.allocchargerid is not null 
 group by tm_list_cat.listname, tb_user.username, tm_list.allocchargerid, tm_list_cat.listid
order by tm_list_cat.listname, tb_user.username, tm_list.allocchargerid


2. 상담원별TM
 select tm_list_cat.listname,
		(case when tb_user.username = '' or  tb_user.username is null then tm_list.allocchargerid else tb_user.username end) username,
		tm_list.allocchargerid,
		tm_list_cat.listid,
		sum(case when ltrim(tm_list.resultcd) = '' or tm_list.resultcd is null then 0 else 1 end) totcnt,			--합계
		sum(case when ltrim(tm_list.resultcd) = 'SS01' then 1 else 0 end) ss01cnt,		--유치완료
		sum(case when ltrim(tm_list.resultcd) = 'SS02' then 1 else 0 end) ss02cnt,		--중도취소
		sum(case when ltrim(tm_list.resultcd) = 'SS03' then 1 else 0 end) ss03cnt,		--거절
		sum(case when ltrim(tm_list.resultcd) = 'SE01' then 1 else 0 end) se01cnt,		--TM거부
		sum(case when ltrim(tm_list.resultcd) = 'NF05' then 1 else 0 end) nf05cnt,		--가망재통화
		sum(case when ltrim(tm_list.resultcd) = 'SS05' then 1 else 0 end) ss05cnt,		--단순재통화
		sum(case when ltrim(tm_list.resultcd) = 'SS06' then 1 else 0 end) ss06cnt,		--부재중
		sum(case when ltrim(tm_list.resultcd) = 'NF03' then 1 else 0 end) nf03cnt,		--실패-무응답	
		sum(case when ltrim(tm_list.resultcd) = 'SE05' then 1 else 0 end) se05cnt,		--오류번호
		sum(case when ltrim(tm_list.resultcd) = 'SE04' then 1 else 0 end) se04cnt		--TM-자체제외

   from tm_list WITH (NOLOCK) left outer join tb_user on  tm_list.allocchargerid = tb_user.userid, 
          tm_list_cat WITH (NOLOCK), tm_pdtask WITH (NOLOCK)
  where tm_list.listid = tm_list_cat.listid
    and tm_pdtask.listid = tm_list_cat.listid
 AND ( tm_list_cat.extracteddate Between '2018/01/01' AND '2018/02/01' ) 
 AND ( tm_list.dialDate Between '2018/01/02' AND '2018/02/02' ) 
 AND (  tm_list_cat.listtypecd = '35' ) 
 AND tm_pdtask.statuscd = 'PROC'  
 AND tm_list_cat.listtypecd <> '01'  
 AND ltrim(tm_list.allocchargerid) <> ''  
 AND tm_list.allocchargerid is not null 
 group by tm_list_cat.listname, tb_user.username, tm_list.allocchargerid, tm_list_cat.listid
order by tb_user.username, tm_list_cat.listname


3. 유형+TM별
 select tm_list_cat.listtypecd,
        tm_list_cat.listname,
        tm_list_cat.listid,
		sum(case when ltrim(tm_list.resultcd) = '' or tm_list.resultcd is null then 0 else 1 end) totcnt,			--합계
		sum(case when ltrim(tm_list.resultcd) = 'SS01' then 1 else 0 end) ss01cnt,		--유치완료
		sum(case when ltrim(tm_list.resultcd) = 'SS02' then 1 else 0 end) ss02cnt,		--중도취소
		sum(case when ltrim(tm_list.resultcd) = 'SS03' then 1 else 0 end) ss03cnt,		--거절
		sum(case when ltrim(tm_list.resultcd) = 'SE01' then 1 else 0 end) se01cnt,		--TM거부
		sum(case when ltrim(tm_list.resultcd) = 'NF05' then 1 else 0 end) nf05cnt,		--가망재통화
		sum(case when ltrim(tm_list.resultcd) = 'SS05' then 1 else 0 end) ss05cnt,		--단순재통화
		sum(case when ltrim(tm_list.resultcd) = 'SS06' then 1 else 0 end) ss06cnt,		--부재중
		sum(case when ltrim(tm_list.resultcd) = 'NF03' then 1 else 0 end) nf03cnt,		--실패-무응답	
		sum(case when ltrim(tm_list.resultcd) = 'SE05' then 1 else 0 end) se05cnt,		--오류번호
		sum(case when ltrim(tm_list.resultcd) = 'SE04' then 1 else 0 end) se04cnt		--TM-자체제외

   from tm_list WITH (NOLOCK) left outer join tb_user on  tm_list.allocchargerid = tb_user.userid, 
          tm_list_cat WITH (NOLOCK), tm_pdtask WITH (NOLOCK)
  where tm_list.listid = tm_list_cat.listid
    and tm_pdtask.listid = tm_list_cat.listid
 AND ( tm_list_cat.extracteddate Between '2018/01/01' AND '2018/02/01' ) 
 AND ( tm_list.dialDate Between '2018/01/02' AND '2018/02/02' ) 
 AND (  tm_list_cat.listtypecd = '35' ) 
 AND tm_pdtask.statuscd = 'PROC'  
 AND tm_list_cat.listtypecd <> '01'  
 AND ltrim(tm_list.allocchargerid) <> ''  
 AND tm_list.allocchargerid is not null 
 group by tm_list_cat.listtypecd, tm_list_cat.listname, tm_list_cat.listid
order by tm_list_cat.listtypecd, tm_list_cat.listid


4. 상담원별
 select (case when tb_user.username = '' or  tb_user.username is null then tm_list.allocchargerid else tb_user.username end) username,
		tm_list.allocchargerid,
		sum(case when ltrim(tm_list.resultcd) = '' or tm_list.resultcd is null then 0 else 1 end) totcnt,			--합계
		sum(case when ltrim(tm_list.resultcd) = 'SS01' then 1 else 0 end) ss01cnt,		--유치완료
		sum(case when ltrim(tm_list.resultcd) = 'SS02' then 1 else 0 end) ss02cnt,		--중도취소
		sum(case when ltrim(tm_list.resultcd) = 'SS03' then 1 else 0 end) ss03cnt,		--거절
		sum(case when ltrim(tm_list.resultcd) = 'SE01' then 1 else 0 end) se01cnt,		--TM거부
		sum(case when ltrim(tm_list.resultcd) = 'NF05' then 1 else 0 end) nf05cnt,		--가망재통화
		sum(case when ltrim(tm_list.resultcd) = 'SS05' then 1 else 0 end) ss05cnt,		--단순재통화
		sum(case when ltrim(tm_list.resultcd) = 'SS06' then 1 else 0 end) ss06cnt,		--부재중
		sum(case when ltrim(tm_list.resultcd) = 'NF03' then 1 else 0 end) nf03cnt,		--실패-무응답	
		sum(case when ltrim(tm_list.resultcd) = 'SE05' then 1 else 0 end) se05cnt,		--오류번호
		sum(case when ltrim(tm_list.resultcd) = 'SE04' then 1 else 0 end) se04cnt		--TM-자체제외

   from tm_list WITH (NOLOCK) left outer join tb_user on  tm_list.allocchargerid = tb_user.userid, 
          tm_list_cat WITH (NOLOCK), tm_pdtask WITH (NOLOCK)
  where tm_list.listid = tm_list_cat.listid
    and tm_pdtask.listid = tm_list_cat.listid
 AND ( tm_list_cat.extracteddate Between '2018/01/01' AND '2018/02/01' ) 
 AND ( tm_list.dialDate Between '2018/01/02' AND '2018/02/02' ) 
 AND (  tm_list_cat.listtypecd = '35' ) 
 AND tm_pdtask.statuscd = 'PROC'  
 AND tm_list_cat.listtypecd <> '01'  
 AND ltrim(tm_list.allocchargerid) <> ''  
 AND tm_list.allocchargerid is not null 
 group by tb_user.username, tm_list.allocchargerid
order by tb_user.username




