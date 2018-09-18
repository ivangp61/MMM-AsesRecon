Update dbo.QueryDetail
Set MPI = MRIC.MPI
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.QueryDetail QD
	On Mric.memberRecId = QD.MemberRecId
Where QD.MPI is null;


Update dbo.QueryDetail
Set MPI = m.MPI
From dbo.Member M
	Inner Join dbo.QueryDetail QD
	On M.SocialSecurity = QD.MemberSSN
Where 1 = 1	
	and QD.MPI is null
;

