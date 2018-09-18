Select Top 100 *
From dbo.BillingDetail BD
Where BD.mpi = '0080026200561'
;

Select Count(*)
From dbo.BillingDetail BD
;--8,142,788


Select Top 200 *
From dbo.BillingDetail BD
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;

Select Count(*)
From dbo.BillingDetail BD
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--323,420: No Update
--: Update


Select Count(Distinct BD.OdsiFamilyNumber)
From dbo.BillingDetail BD
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--105,112: No update
--: Update


Select Count(Distinct BD.OdsiFamilyNumber)
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.BillingDetail BD
	On M.MPI = BD.MPI
Where BD.MPI is null
	or Rtrim(Ltrim(BD.MPI))  = ''
;--49,685

Select Distinct BD.MPI
FROM dbo.BillingDetail BD
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON BD.MemberRecId = MRIC.MemberRecId
Where MRIC.MemberRecIdCons Is Null
	--and  = '0080004319904'
;


--====================UpdateReconRecId=================
--UPDATE dbo.BillingDetail
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.BillingDetail BD
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON BD.MemberRecId = MRIC.MemberRecId
Where MRIC.MemberRecIdCons Is Not Null
;
--====================================================

Select *
From dbo.Member m
Where m.mpi = '0080026200561'
;

Select *
From dbo.Member M
Where M.MemberRecId = '815AFDA7-349A-41F5-8BC7-0490E95DD10B'
;




