With QueryResponseDetailMember
As
(
	Select Distinct	QRD.MemberSSN,
					M.SocialSecurity,
					M.MemberRecId
	From dbo.Member M		
		Inner Join dbo.QueryResponseDetail QRD
		On M.SocialSecurity = QRD.MemberSSN
	Where QRD.MPI is null
		or Rtrim(Ltrim(QRD.MPI))  = ''
),
QueryResponseDetailMemberMpi
As
(
	Select Distinct	
				QRDM.MemberSSN,
				QRDM.SocialSecurity,
				--QRDM.MemberRecId,
				MRIC.MemberRecId,
				MRIC.MPI
	From QueryResponseDetailMember QRDM
		Inner Join dbo.MemberRecIdCon MRIC
		On Mric.memberRecId = QRDM.MemberRecId
)

Update dbo.QueryResponseDetail
Set MPI = QRDMM.MPI
From QueryResponseDetailMemberMpi QRDMM
	Inner Join dbo.QueryResponseDetail QRD
	On QRDMM.MemberSSN = QRD.MemberSSN
;



Update dbo.QueryResponseDetail
Set MPI = MRIC.MPI
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.QueryResponseDetail QRD
	On M.SocialSecurity = QRD.MemberSSN
;



