--========================================
--1. Esto hay que optimizarlo
--   ya que tardo 25 minutos,
--   se actualizaron 2,744,502.
--2. Se puede meter en una tabla temporera
--   fisica con indices.
--========================================

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
;--70,920 SSN: No Update
--17,535 SSN: Update

Select Count(Distinct QRD.MemberSSN)
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.QueryResponseDetail QRD
	On M.SocialSecurity = QRD.MemberSSN
Where QRD.MPI is null
	or Rtrim(Ltrim(QRD.MPI))  = ''
;--53,387



Select	QRD.MemberSSN,
		M.SocialSecurity,
		MRIC.MPI
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.QueryResponseDetail QRD
	On M.SocialSecurity = QRD.MemberSSN
Where QRD.MPI is null
	or Rtrim(Ltrim(QRD.MPI))  = ''
;

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
				--QRDM.MemberRecId,
				MRIC.MemberRecId,
				MRIC.MPI
	From QueryResponseDetailMember QRDM
		Inner Join dbo.MemberRecIdCon MRIC
		On Mric.memberRecId = QRDM.MemberRecId
)
--Select *
--From QueryResponseDetailMemberMpi

--Update dbo.QueryResponseDetail
Set MPI = QRDMM.MPI
From QueryResponseDetailMemberMpi QRDMM
	Inner Join dbo.QueryResponseDetail QRD
	On QRDMM.MemberSSN = QRD.MemberSSN
;



--Update dbo.QueryResponseDetail
Set MPI = MRIC.MPI
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.QueryResponseDetail QRD
	On M.SocialSecurity = QRD.MemberSSN
;



