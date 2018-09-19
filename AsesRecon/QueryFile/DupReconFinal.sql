--================================================
--1. Actualizar MPI para la tabla de productos.

Select M.SORId, Count(Distinct M.MemberRecId) As recIdCount
From dbo.Member M
Where 1 = 1
	and M.mpi  Not In (
						Select Distinct mpi
						From(
						Select M.MPI, M.SORId, Count(Distinct M.MemberRecId) As recIdCount
						From dbo.Member M
							Left Join dbo.MPIMembership MM
							On M.MPI = MM.MPI
						Where 1 = 1
							--and MM.MPI is null
							--and sorid = 'N00374498295'
							--and M.MPI = '0080032292859'
						Group By M.MPI, M.SORId
						Having Count(Distinct M.MemberRecId) > 1
						) D
					  )
	--and sorid = 'N00374498295'
Group By M.SORId
Having Count(Distinct M.MemberRecId) > 1
;

Select Distinct M.MPI--, M.MemberRecId, M.CarrierMRefId, MBP.MPI--, MBP.EffectiveDate, MBP.TerminationDate
From (
		Select M.MPI, M.SORId, Count(Distinct M.MemberRecId) As recIdCount
		From dbo.Member M
			Left Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
		Where 1 = 1
			--and MM.MPI is null
			--and sorid = 'N00374498295'
			and M.MPI = '0080032292859'
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

Select M.MPI, Count(Distinct M.MemberRecId) As recIdCount
From dbo.Member M
Where 1 = 1
	--and MM.MPI is null
	--and sorid = 'N00374498295'
	and M.MPI = '0080032292859'
Group By M.MPI
Having Count(Distinct M.MemberRecId) > 1
;

Select M.MPI, Count(Distinct M.MemberRecId) As recIdCount
From dbo.Member M
Where 1 = 1
Group By M.MPI
Having Count(Distinct M.MemberRecId) > 1


--Update dbo.MemberBenefitPackage
Set mpi = M.MPI
From (
		Select M.MPI, Count(Distinct M.MemberRecId) As recIdCount
		From dbo.Member M
			Left Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
		Where 1 = 1
			and MM.MPI is null
			--and sorid = 'N00374498295'
		Group By M.MPI
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


--Drop Table dbo.MemberConsNoMPMpi;

Create Table dbo.MemberConsNoMPMpi
(
	mpi nvarchar(13),
	memberRecId uniqueidentifier,
	memberRecIdCons uniqueidentifier,
	carrierMrefId int
)
;

--Create Table dbo.MemberConsNoMpMPIElig(
--	memberRecId uniqueIdentifier,
--	mpi nvarchar(13),
--	maxEligibilityDate dateTime
--)
--;



--================================================
--2. Buscar afiliados con vigencia que no sea cancelada

--Truncate Table dbo.MemberConsNoMPMpi;
--Insert into dbo.MemberConsNoMPMpi(mpi, memberRecId, carrierMrefId)
Select Distinct Mbp.MPI, M.MemberRecId, M.CarrierMRefId--, MBP.EffectiveDate, MBP.TerminationDate
From (
		Select M.MPI, Count(Distinct M.MemberRecId) As recIdCount
		From dbo.Member M
			Left Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
		Where 1 = 1
			and MM.MPI is null
			--and sorid = 'N00374498295'
		Group By M.MPI
		Having Count(Distinct M.MemberRecId) > 1
		) AS D
Inner Join dbo.Member M
On M.MPI = D.MPI
Inner Join dbo.MemberBenefitPackage MBP
On M.mpi = MBP.mpi
Where 1 = 1
	and M.mpi Not In(Select Distinct MCNMM.mpi From dbo.MemberConsNoMPMpi MCNMM)
	--and MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)--249
;

--Delete [dbo].[MemberBenefitPackageMax]
Where mpi In (Select Distinct mpi From dbo.MemberConsNoMPMpi);

--Delete dbo.MemberBenefitPackageConsolidation
Where mpi In (Select Distinct mpi From dbo.MemberConsNoMPMpi);


--=================Max No Cancelaciones
--Insert Into [dbo].[MemberBenefitPackageMax](MPI,LastUpdateOnSrc)
Select Distinct MCNMM.mpi, Max(IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)) as maxDate
From dbo.MemberConsNoMPMpi MCNMM
	Inner Join dbo.MemberBenefitPackage MBP
	On MCNMM.mpi = MBP.mpi
where 1 = 1
	and MCNMM.mpi Not In (Select Distinct mpi From [dbo].[MemberBenefitPackageMax])
	and MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)--249
Group By MCNMM.mpi
;

--=================Max Cancelaciones
--Insert Into [dbo].[MemberBenefitPackageMax](MPI,LastUpdateOnSrc)
Select Distinct MCNMM.mpi, Max(IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)) as maxDate
From dbo.MemberConsNoMPMpi MCNMM
	Inner Join dbo.MemberBenefitPackage MBP
	On MCNMM.mpi = MBP.mpi
where 1 = 1
	and MCNMM.mpi Not In (Select Distinct mpi From [dbo].[MemberBenefitPackageMax])
Group By MCNMM.mpi
;




--================================================

Select Distinct M.MPI, MBP.EffectiveDate, MBP.TerminationDate
From [dbo].[MemberBenefitPackageMax] M
	Inner Join dbo.MemberBenefitPackage MBP
	On M.mpi = MBP.mpi and M.LastUpdateOnSrc = IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)
	Inner Join dbo.MemberConsNoMPMpi MCNMMP
	On M.mpi = MCNMMP.mpi
Order By M.MPI
;


Select Distinct M.MPI, Count(Distinct MBP.EffectiveDate)
From [dbo].[MemberBenefitPackageMax] M
	Inner Join dbo.MemberBenefitPackage MBP
	On M.mpi = MBP.mpi and M.LastUpdateOnSrc = IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)
	Inner Join dbo.MemberConsNoMPMpi MCNMMP
	On M.mpi = MCNMMP.mpi
Group By M.MPI
Having Count(Distinct MBP.EffectiveDate) > 1
Order By M.MPI--155
;

Select Distinct MBP.MemberBenefitPackageRecId,
				MBP.MemberRecId,
				MBP.BenefitPackageMRefId, 
				MBP.EffectiveDate, 
				MBP.TerminationDate,
				MBP.SORId,
				MBP.CreatedBySrc,
				MBP.CreatedOnSrc,
				MBP.LastUpdateBySrc,
				MBP.LastUpdateOnSrc,
				MBP.JobLoadDate,
				MCNMM.mpi,
				MBP.PackageId,
				MBP.OrgId,
				MBP.Pbp
				--,				ME.CarrierMRefId
From [dbo].[MemberBenefitPackageMax] M
	Inner Join dbo.MemberConsNoMPMpi MCNMM
	On M.MPI = MCNMM.MPI
	Inner Join dbo.MemberBenefitPackage MBP
	On M.mpi = MBP.mpi and M.LastUpdateOnSrc = IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)
	Inner Join dbo.Member ME
	On MBP.MemberRecId = ME.MemberRecId
	Left Join
	(
		Select Distinct M.MPI, Count(Distinct MBP.EffectiveDate) effDate
		From [dbo].[MemberBenefitPackageMax] M
			Inner Join dbo.MemberBenefitPackage MBP
			On M.mpi = MBP.mpi and M.LastUpdateOnSrc = IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)
			Inner Join dbo.MemberConsNoMPMpi MCNMMP
			On M.mpi = MCNMMP.mpi
		Group By M.MPI
		Having Count(Distinct MBP.EffectiveDate) > 1
	) as D
	On M.mpi = D.mpi
Where 1 = 1
	and D.mpi is null
	and MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)--249
;--383

Select MBP.*
From dbo.MemberBenefitPackage MBP
	Inner Join dbo.MemberConsNoMPMpi MCNMM
	On MBP.MPI = MCNMM.MPI
;

--=============================GOLD_QUERY===========================
--INSERT INTO dbo.MemberBenefitPackageConsolidation
           (MemberBenefitPackageRecId
           ,MemberRecId
           ,BenefitPackageMRefId
           ,EffectiveDate
           ,TerminationDate
           ,SORId
           ,CreatedBySrc
           ,CreatedOnSrc
           ,LastUpdateBySrc
           ,LastUpdateOnSrc
           ,JobLoadDate
           ,MPI
           ,PackageId
           ,OrgId
           ,Pbp)

Select Distinct MBP.MemberBenefitPackageRecId,
				MBP.MemberRecId,
				MBP.BenefitPackageMRefId, 
				MBP.EffectiveDate, 
				MBP.TerminationDate,
				MBP.SORId,
				MBP.CreatedBySrc,
				MBP.CreatedOnSrc,
				MBP.LastUpdateBySrc,
				MBP.LastUpdateOnSrc,
				MBP.JobLoadDate,
				MCNMM.mpi,
				MBP.PackageId,
				MBP.OrgId,
				MBP.Pbp
				--,				ME.CarrierMRefId
From [dbo].[MemberBenefitPackageMax] M
	Inner Join dbo.MemberConsNoMPMpi MCNMM
	On M.MPI = MCNMM.MPI
	Inner Join dbo.MemberBenefitPackage MBP
	On M.mpi = MBP.mpi and M.LastUpdateOnSrc = IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)
	Inner Join dbo.Member ME
	On MBP.MemberRecId = ME.MemberRecId
	Left Join
	(
		Select Distinct M.MPI, Count(Distinct MBP.EffectiveDate) effDate
		From [dbo].[MemberBenefitPackageMax] M
			Inner Join dbo.MemberBenefitPackage MBP
			On M.mpi = MBP.mpi and M.LastUpdateOnSrc = IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)
			Inner Join dbo.MemberConsNoMPMpi MCNMMP
			On M.mpi = MCNMMP.mpi
		Group By M.MPI
		Having Count(Distinct MBP.EffectiveDate) > 1
	) as D
	On M.mpi = D.mpi
Where 1 = 1
	and D.mpi is null
;--383
--=============================GOLD_QUERY===========================

--=============================Max_Duplicates===========================
--=====Delete_Max_Duplicates================
--Delete [dbo].[MemberBenefitPackageMax]
Where mpi In (

				Select Distinct mpi
				From dbo.MemberConsNoMPMpi

				Except 

				Select Distinct MBP.MPI
				From dbo.MemberBenefitPackageConsolidation MBP
					Inner Join dbo.MemberConsNoMPMpi MCNMM
					On MBP.MPI = MCNMM.mpi
			  )
;
--=====Delete_Max_Duplicates================

--=================Max No Cancelaciones
--Insert Into [dbo].[MemberBenefitPackageMax](MPI,LastUpdateOnSrc)
Select Distinct MCNMM.mpi, Max(MBP.CreatedOnSrc) as maxDate
From dbo.MemberConsNoMPMpi MCNMM
	Inner Join dbo.MemberBenefitPackage MBP
	On MCNMM.mpi = MBP.mpi
where 1 = 1
	and MCNMM.mpi Not In (Select Distinct mpi From [dbo].[MemberBenefitPackageMax])
	and MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)--249
Group By MCNMM.mpi
;

--=================Max Cancelaciones
--Insert Into [dbo].[MemberBenefitPackageMax](MPI,LastUpdateOnSrc)
Select Distinct MCNMM.mpi, Max(MBP.CreatedOnSrc) as maxDate
From dbo.MemberConsNoMPMpi MCNMM
	Inner Join dbo.MemberBenefitPackage MBP
	On MCNMM.mpi = MBP.mpi
where 1 = 1
	and MCNMM.mpi Not In (Select Distinct mpi From [dbo].[MemberBenefitPackageMax])
Group By MCNMM.mpi
;


--INSERT INTO dbo.MemberBenefitPackageConsolidation
           (MemberBenefitPackageRecId
           ,MemberRecId
           ,BenefitPackageMRefId
           ,EffectiveDate
           ,TerminationDate
           ,SORId
           ,CreatedBySrc
           ,CreatedOnSrc
           ,LastUpdateBySrc
           ,LastUpdateOnSrc
           ,JobLoadDate
           ,MPI
           ,PackageId
           ,OrgId
           ,Pbp)

Select Distinct MBP.MemberBenefitPackageRecId,
				MBP.MemberRecId,
				MBP.BenefitPackageMRefId, 
				MBP.EffectiveDate, 
				MBP.TerminationDate,
				MBP.SORId,
				MBP.CreatedBySrc,
				MBP.CreatedOnSrc,
				MBP.LastUpdateBySrc,
				MBP.LastUpdateOnSrc,
				MBP.JobLoadDate,
				MCNMM.mpi,
				MBP.PackageId,
				MBP.OrgId,
				MBP.Pbp
				--,				ME.CarrierMRefId
From [dbo].[MemberBenefitPackageMax] M
	Inner Join dbo.MemberConsNoMPMpi MCNMM
	On M.MPI = MCNMM.MPI
	Inner Join dbo.MemberBenefitPackage MBP
	On M.mpi = MBP.mpi and M.LastUpdateOnSrc = MBP.CreatedOnSrc
	Inner Join dbo.Member ME
	On MBP.MemberRecId = ME.MemberRecId
	Left Join
	(
		Select Distinct M.MPI, Count(Distinct MBP.EffectiveDate) effDate
		From [dbo].[MemberBenefitPackageMax] M
			Inner Join dbo.MemberBenefitPackage MBP
			On M.mpi = MBP.mpi and M.LastUpdateOnSrc = MBP.CreatedOnSrc
			Inner Join dbo.MemberConsNoMPMpi MCNMMP
			On M.mpi = MCNMMP.mpi
		Group By M.MPI
		Having Count(Distinct MBP.EffectiveDate) > 1
	) as D
	On M.mpi = D.mpi
	Left Join dbo.MemberBenefitPackageConsolidation MBPC
	On M.mpi = MBPC.mpi
Where 1 = 1
	and D.mpi is null
	and MBPC.mpi is null
;--


--1. Crear recon de los max dups.

--=============================Max_Duplicates===========================

Select Distinct MBPC.*
From dbo.MemberBenefitPackageConsolidation MBPC
	Inner Join dbo.MemberConsNoMPMpi MCNMM
	On MBPC.MPI = MCNMM.mpi
Where 1 = 1
	--and MBPC.mpi = '0080000010426'
;



Select Distinct MCNMM.mpi
From dbo.MemberConsNoMPMpi MCNMM

Except

Select Distinct MBPC.mpi
From dbo.MemberBenefitPackageConsolidation MBPC
	Inner Join dbo.MemberConsNoMPMpi MCNMM
	On MBPC.MPI = MCNMM.mpi
Where 1 = 1
;

Select *
From dbo.Member M
Where 1 = 1
	--and MemberRecId = 'D65762F9-3F81-41B6-9C7E-4A2DC4D4D375'
	--and M.mpi = '0080006613835' --'0080006613828'--
;

Select *
From dbo.MemberBenefitPackage MBP
Where 1 = 1
	--and MemberRecId = 'D65762F9-3F81-41B6-9C7E-4A2DC4D4D375'
	and mpi = '0080006613828'--'0080006613835' --
;
--============================ValidacionMpiVsRecId=============================

Select Distinct Mbp.MPI, M.MemberRecId, M.CarrierMRefId--, MBP.EffectiveDate, MBP.TerminationDate
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

Except

Select Distinct Mbp.MPI--, M.MemberRecId, M.CarrierMRefId,mbp.MPI--, MBP.EffectiveDate, MBP.TerminationDate
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
;
--============================ValidacionMpiVsRecId=============================




