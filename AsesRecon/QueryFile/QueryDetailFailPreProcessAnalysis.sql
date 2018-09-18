Select Top 100 *
From dbo.QueryDetailFailPreProcess
;


Select *
From dbo.QueryDetailFailPreProcess
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;


Select Count(*)
From dbo.QueryDetailFailPreProcess
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--3,435,837: No update
--196,078: Updated


Select Count(Distinct QDFP.MemberSSN)
From dbo.QueryDetailFailPreProcess QDFP
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--131,759 SSN: No update
--3,604 SSN: Updated

Select Count(Distinct QDFPP.MemberSSN)
From dbo.QueryDetailFailPreProcess QDFPP
	Inner Join dbo.Member M
	On M.SocialSecurity = QDFPP.MemberSSN
Where QDFPP.MPI is null
	or Rtrim(Ltrim(QDFPP.MPI))  = ''
;--127,664




Select Top 100 *
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.QueryDetailFailPreProcess QDFPP
	On M.SocialSecurity = QDFPP.MemberSSN
;


Select Top 100 QDFPP.MPI, Count(Distinct QDFPP.MemberRecId)
From dbo.QueryDetailFailPreProcess QDFPP
Group By QDFPP.MPI
Having Count(Distinct QDFPP.MemberRecId) > 1
;


Select Top 100 QDFPP.MPI,Mric.memberRecId, QDFPP.MemberRecId, Mric.memberRecIdCons
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.QueryDetailFailPreProcess QDFPP
	On Mric.memberRecId = QDFPP.MemberRecId
Where QDFPP.MPI is not null
	and QDFPP.MPI = '0080019119571'
Order By QDFPP.MPI
;

--====ConsolidateRecId================================
--Update dbo.QueryDetailFailPreProcess
Set memberRecId = MRIC.memberRecIdCons
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.QueryDetailFailPreProcess QDFPP
	On Mric.memberRecId = QDFPP.MemberRecId
;
--====================================================

--====================UpdateMpi=======================
Update dbo.QueryDetailFailPreProcess
Set mpi = MRIC.mpi
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.QueryDetailFailPreProcess QDFPP
	On Mric.memberRecIdCons = QDFPP.MemberRecId
;
--====================================================