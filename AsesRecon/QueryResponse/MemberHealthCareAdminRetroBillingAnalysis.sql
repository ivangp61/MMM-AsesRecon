Select Top 100 *
From dbo.MemberHealthCareAdminRetroBilling MHCARB
Where MHCARB.mpi = '0080026200561'
;

Select Count(*)
From dbo.MemberHealthCareAdminRetroBilling MHCARB
;--8,142,788


Select Top 200 *
From dbo.MemberHealthCareAdminRetroBilling MHCARB
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;

Select Count(*)
From dbo.MemberHealthCareAdminRetroBilling MHCARB
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--323,420: No Update
--: Update


Select Count(Distinct OdsiFamilyNumber)
From dbo.MemberHealthCareAdminRetroBilling MHCARB
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--105,112: No update
--: Update


Select Count(Distinct BD.OdsiFamilyNumber)
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.MemberHealthCareAdminRetroBilling MHCARB
	On M.MPI = BD.MPI
Where BD.MPI is null
	or Rtrim(Ltrim(MPI))  = ''
;--49,685

Select Distinct BD.MPI
From dbo.MemberHealthCareAdminRetroBilling MHCARB
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON BD.MemberRecId = MRIC.MemberRecId
Where MRIC.MemberRecIdCons Is Null
	--and  = '0080004319904'
;


--====================UpdateReconRecId=================
--UPDATE dbo.MemberHealthCareAdminRetroBilling
SET MemberRecId = MRIC.MemberRecIdCons
From dbo.MemberHealthCareAdminRetroBilling MHCARB
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MHCARB.MemberRecId = MRIC.MemberRecId
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


