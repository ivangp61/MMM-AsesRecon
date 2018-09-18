--==============EligibilityMember=======================
Select Top 200 *
From dbo.EnrollmentDetail

Select Count(*)
From dbo.EnrollmentDetail

Select Count(*)
From dbo.EnrollmentDetail
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;
--==============EligibilityMember=======================



Select Top 100 *
From dbo.QueryUserDefinedQueue QUDQ
;

Select Count(*)
From dbo.QueryUserDefinedQueue QUDQ
;--89,883


Select *
From dbo.QueryUserDefinedQueue QUDQ
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;


Select Count(*)
From dbo.QueryUserDefinedQueue QUDQ
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--89,766: No Update
--736: Update


Select Count(Distinct QUDQ.MemberSSN)
From dbo.QueryUserDefinedQueue QUDQ
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--50,350 SSN: No update
--665: Update


Select Count(Distinct QUDQ.MemberSSN)
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.QueryUserDefinedQueue QUDQ
	On M.SocialSecurity = QUDQ.MemberSSN
Where QUDQ.MPI is null
	or Rtrim(Ltrim(QUDQ.MPI))  = ''
;--49,685

--====================UpdateMpi=======================
--Update dbo.QueryUserDefinedQueue
Set mpi = MRIC.mpi
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.QueryUserDefinedQueue QUDQ
	On M.SocialSecurity = QUDQ.MemberSSN
;
--====================================================

