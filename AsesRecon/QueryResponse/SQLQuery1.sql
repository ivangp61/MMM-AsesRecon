Select Top 100 *
From dbo.EnrollmentDetailFailPreProcess
;



Select *
From MRef.EligibilityType



Select Top 100 *
From dbo.EligibilityMember EM
;

Select Count(*)
From dbo.EligibilityMember EM
;--9,966,735


Select *
From dbo.EligibilityMember EM
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;


Select Top 100 *
From dbo.EligibilityFamily


Select Count(*)
From dbo.EligibilityMember EM
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--106: No Update
--: Update


Select Count(Distinct EM.MemberSSN)
From dbo.EligibilityMember EM
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--106: No update
--: Update


Select Count(Distinct EM.MemberSSN)
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.EligibilityMember EM
	On M.SocialSecurity = EM.MemberSSN
Where EM.MPI is null
	or Rtrim(Ltrim(EM.MPI))  = ''
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

Select *
From dbo.Member m
Where m.mpi = '0080026200561'

