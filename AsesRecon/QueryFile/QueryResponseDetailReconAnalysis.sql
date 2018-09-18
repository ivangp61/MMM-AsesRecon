Select Top 100 *
From dbo.QueryResponseDetail QRD
;


Select *
From dbo.QueryResponseDetail QRD
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;


Select Count(*)
From dbo.QueryResponseDetail QRD
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--2,379,106


Select Count(Distinct QRD.MemberSSN)
From dbo.QueryResponseDetail QRD
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--70,920 SSN

Select Count(Distinct QRD.MemberSSN)
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.QueryResponseDetail QRD
	On M.SocialSecurity = QRD.MemberSSN
Where QRD.MPI is null
	or Rtrim(Ltrim(QRD.MPI))  = ''
;--53,387


