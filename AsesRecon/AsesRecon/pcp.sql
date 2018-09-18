Select NAME_ID, 
		PROVIDER_ID, 
		NAME_FIRST, 
		NAME_LAST, 
		GENDER, 
		SOC_SEC, 
		BIRTH_DATE, 
		ORG_ID, 
		EFF_DATE, 
		TERM_DATE, 
		COMPANY, 
		CREATEDBY, 
		CREATEDON, 
		LASTUPDATEBY, 
		LASTUPDATEON
From stg.MemberExtrPCPHistory
;

--[stg].[MemberTgtPCPHistory]
--1- Incluirle los campos del alter.

Select Top 10 MemberRecId, ProviderId, EffectiveDate, TerminationDate, SORId, CreatedBySrc, CreatedOnSrc, LastUpdateBySrc, LastUpdateOnSrc
From [stg].[MemberTgtPCPHistory]
;


Select Top 100 *
From [dbo].[MemberPCP]
Where Convert(varchar, CreatedOnSrc,112) = '20180406'
;

Select *
From dbo.Member M
Where 1= 1
--	and M.MemberRecId = 'F0D3EF71-06EF-4832-A504-F3C23D39D958'
	and CarrierMRefId = 2
	and mpi is not null
	and Convert(varchar, CreatedOnSrc,112) = '20170406'
;



