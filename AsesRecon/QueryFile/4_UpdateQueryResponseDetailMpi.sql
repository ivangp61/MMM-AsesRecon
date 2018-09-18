--========================================
--1. Esto hay que optimizarlo
--   ya que tardo 25 minutos,
--   se actualizaron 2,744,502
--========================================

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
)
--Select *
--From QueryResponseDetailMember
,
QueryResponseDetailMemberMpi
As
(
	Select Distinct	
				QRDM.MemberSSN,
				QRDM.SocialSecurity,
				MRIC.MemberRecId,
				MRIC.MPI
	From QueryResponseDetailMember QRDM
		Inner Join dbo.MemberRecIdCon MRIC
		On Mric.memberRecId = QRDM.MemberRecId
)
--Select *
--From QueryResponseDetailMemberMpi

Update dbo.QueryResponseDetail
Set MPI = QRDMM.MPI
From QueryResponseDetailMemberMpi QRDMM
	Inner Join dbo.QueryResponseDetail QRD
	On QRDMM.MemberSSN = QRD.MemberSSN
;