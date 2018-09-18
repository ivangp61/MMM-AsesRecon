Update dbo.EnrollmentDetailFailPreProcess
Set mpi = MRIC.mpi
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.EnrollmentDetailFailPreProcess QUDQ
	On M.SocialSecurity = QUDQ.MemberSSN
;
