Select Top 100 *
From dbo.EnrollmentDetail ED
Where ED.mpi = '0080026200561'
;

Select Count(*)
From dbo.EnrollmentDetail ED
;--466,143


Select *
From dbo.EnrollmentDetail ED
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;

Select Count(*)
From dbo.EnrollmentDetail ED
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--106: No Update
--: Update


Select Count(Distinct ED.MemberSSN)
From dbo.EnrollmentDetail ED
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--106: No update
--: Update


Select Count(Distinct ED.MemberSSN)
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.EnrollmentDetail ED
	On M.SocialSecurity = ED.MemberSSN
Where ED.MPI is null
	or Rtrim(Ltrim(ED.MPI))  = ''
;--49,685

--====================UpdateReconRecId=================
--UPDATE dbo.EnrollmentDetail
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.EnrollmentDetail ED
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON ED.MemberRecId = MRIC.MemberRecId
;
--====================================================

Select *
From dbo.Member m
Where m.mpi = '0080026200561'
;

