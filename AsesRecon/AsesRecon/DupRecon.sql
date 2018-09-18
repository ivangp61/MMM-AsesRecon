--================================================
--1. Actualizar MPI para la tabla de productos.

Select Distinct M.MPI--, M.MemberRecId, M.CarrierMRefId, MBP.MPI--, MBP.EffectiveDate, MBP.TerminationDate
From (
		Select M.MPI, M.SORId, Count(Distinct M.MemberRecId) As recIdCount
		From dbo.Member M
			Left Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
		Where 1 = 1
			and MM.MPI is null
			--and sorid = 'N00374498295'
		Group By M.MPI, M.SORId
		Having Count(Distinct M.MemberRecId) > 1
		) AS D
Inner Join dbo.Member M
On M.MPI = D.MPI
Inner Join dbo.MemberBenefitPackage MBP
On M.MemberRecId = MBP.MemberRecId
Where 1 = 1
	and MBP.MPI is null
;

--Update dbo.MemberBenefitPackage
Set mpi = M.MPI
From (
		Select M.MPI, M.SORId, Count(Distinct M.MemberRecId) As recIdCount
		From dbo.Member M
			Left Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
		Where 1 = 1
			and MM.MPI is null
			--and sorid = 'N00374498295'
		Group By M.MPI, M.SORId
		Having Count(Distinct M.MemberRecId) > 1
		) AS D
Inner Join dbo.Member M
On M.MPI = D.MPI
Inner Join dbo.MemberBenefitPackage MBP
On M.MemberRecId = MBP.MemberRecId
Where 1 = 1
	and MBP.MPI is null
;
--================================================



Create Table dbo.MemberConsNoMPMpi
(
	mpi nvarchar(13),
	memberRecId uniqueidentifier,
	carrierMrefId int
)

Create Table dbo.MemberConsNoMpMPIElig(
	memberRecId uniqueIdentifier,
	mpi nvarchar(13),
	maxEligibilityDate dateTime
)
;

--Truncate Table dbo.MemberConsNoMPMpi;




--================================================
--2. Buscar afiliados con vigencia que no sea cancelada
--Insert into dbo.MemberConsNoMPMpi(mpi, memberRecId, carrierMrefId)
Select Distinct Mbp.MPI, M.MemberRecId, M.CarrierMRefId,mbp.MPI--, MBP.EffectiveDate, MBP.TerminationDate
From (
		Select M.MPI, M.SORId, Count(Distinct M.MemberRecId) As recIdCount
		From dbo.Member M
			Left Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
		Where 1 = 1
			and MM.MPI is null
			--and sorid = 'N00374498295'
		Group By M.MPI, M.SORId
		Having Count(Distinct M.MemberRecId) > 1
		) AS D
Inner Join dbo.Member M
On M.MPI = D.MPI
Inner Join dbo.MemberBenefitPackage MBP
On M.MemberRecId = MBP.MemberRecId
Where 1 = 1
	and MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)--249
Except
Select Distinct Mbp.MPI--, M.MemberRecId, M.CarrierMRefId--, MBP.EffectiveDate, MBP.TerminationDate
From (
		Select M.MPI, M.SORId, Count(Distinct M.MemberRecId) As recIdCount
		From dbo.Member M
			Left Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
		Where 1 = 1
			and MM.MPI is null
			--and sorid = 'N00374498295'
		Group By M.MPI, M.SORId
		Having Count(Distinct M.MemberRecId) > 1
		) AS D
Inner Join dbo.Member M
On M.MPI = D.MPI
Inner Join dbo.MemberBenefitPackage MBP
On M.mpi = MBP.mpi
Where 1 = 1
	and MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)--249	
;
--================================================

Select *
From dbo.Member M
Where 1 = 1
	and MemberRecId = 'D65762F9-3F81-41B6-9C7E-4A2DC4D4D375'
	--and M.mpi = '0080006613835' --'0080006613828'
Select *
From dbo.MemberBenefitPackage MBP
Where MemberRecId = 'D65762F9-3F81-41B6-9C7E-4A2DC4D4D375'

--Insert Into 
Select MBP.MPI, Max(IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)) AS maxEligibilityDate--MBP.EffectiveDate, MBP.TerminationDate
From dbo.MemberBenefitPackage MBP
	Inner Join dbo.MemberConsNoMPMpi C
	On MBP.MPI = C.mpi
Group By MBP.MPI
;







--Insert into dbo.MemberConsNoMPMpi(mpi, memberRecId, carrierMrefId)
Select Distinct M.MPI, M.MemberRecId, M.CarrierMRefId--, MBP.EffectiveDate, MBP.TerminationDate
From (
		Select M.MPI, M.SORId, Count(Distinct M.MemberRecId) As recIdCount
		From dbo.Member M
			Left Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
		Where 1 = 1
			and MM.MPI is null
			--and sorid = 'N00374498295'
		Group By M.MPI, M.SORId
		Having Count(Distinct M.MemberRecId) > 1
		) AS D
Inner Join dbo.Member M
On M.MPI = D.MPI
Inner Join dbo.MemberBenefitPackage MBP
On M.MemberRecId = MBP.MemberRecId
Where 1 = 1	
	and M.MPI Not In(Select Distinct MPI From dbo.MemberConsNoMPMpi)
;



