--================================================
--1. Actualizar MPI para la tabla de productos.


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



--================================================
--2. Buscar afiliados con vigencia que no sea cancelada

--Drop Table dbo.MemberConsNoMPMpi;

Create Table dbo.MemberConsNoMPMpi
(
	mpi nvarchar(13),
	memberRecId uniqueidentifier,
	memberRecIdCons uniqueidentifier,
	carrierMrefId int
)
;


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
		Group By M.MPI
		Having Count(Distinct M.MemberRecId) > 1
		) AS D
Inner Join dbo.Member M
On M.MPI = D.MPI
Inner Join dbo.MemberBenefitPackage MBP
On M.mpi = MBP.mpi
Where 1 = 1
	and M.mpi Not In(Select Distinct MCNMM.mpi From dbo.MemberConsNoMPMpi MCNMM)
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

Begin--=============================Max_Duplicates===========================
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


End--=============================Max_Duplicates===========================

Begin--=============================UpdateConsMemberRecId===========================
--Update dbo.MemberConsNoMPMpi
SET memberRecIdCons = MBPC.MemberRecId
From dbo.MemberConsNoMPMpi MCNMM
	Inner Join dbo.MemberBenefitPackageConsolidation MBPC
	On MCNMM.mpi = MBPC.MPI
;
End--=============================UpdateConsMemberRecId===========================

Begin--=============================UpdateMemberBenefitPackage===========================

--UPDATE dbo.MemberBenefitPackage
SET MemberRecId = MCNMM.MemberRecIdCons
FROM dbo.MemberBenefitPackage MBP
	INNER JOIN dbo.MemberConsNoMPMpi MCNMM
	ON MBP.MemberRecId = MCNMM.MemberRecId
;--1,191

Select MBP.MemberRecId, MCNMM.MemberRecIdCons
From dbo.MemberBenefitPackage MBP
	INNER JOIN dbo.MemberConsNoMPMpi MCNMM
	ON MBP.MemberRecId = MCNMM.MemberRecId
Where 1 = 1
	and MCNMM.mpi = '0080033062951'
;--1,191

Select BP.CompanyContract,MBP.*
From dbo.MemberBenefitPackage MBP
	INNER JOIN .MemberConsNoMPMpi MCNMM
	ON MBP.MemberRecId = MCNMM.MemberRecId
	Inner Join MRef.BenefitPackage BP
	On MBP.BenefitPackageMRefId = BP.BenefitPackageMRefId
Where 1 = 1
	and MCNMM.mpi = '0080033062951'
	and BP.CompanyContract = 'H4004'
Order By MBP.EffectiveDate DESC
;

Select *
From dbo.Member M
Where M.MPI = '0080033062951'
;

Select MBP.mpi, Count(Distinct MBP.MemberRecId)
From dbo.MemberBenefitPackage MBP
	INNER JOIN .MemberConsNoMPMpi MCNMM
	ON MBP.MemberRecId = MCNMM.MemberRecId
Where 1 = 1
Group By MBP.mpi
Having Count(Distinct MBP.MemberRecId) > 1
	--and MCNMM.mpi = '0008000032375'
;


End--=============================UpdateMemberBenefitPackage===========================


Begin--=============================UpdateMemberEnrollmentStatus===========================

--2. Actualizar MPI para la tabla de enrollment status.

--Update dbo.MemberEnrollmentStatus
Set mpi = MCNMM.mpi
From dbo.MemberEnrollmentStatus MES
	Inner Join dbo.MemberConsNoMPMpi MCNMM	
	On MCNMM.memberRecId = MES.memberRecId
;

--Update dbo.MemberEnrollmentStatus
Set memberRecId = MCNMM.MemberRecIdCons
From dbo.MemberEnrollmentStatus MES
	Inner Join dbo.MemberConsNoMPMpi MCNMM	
	On MCNMM.memberRecId = MES.memberRecId
;

SELECT MES.SORId, MES.CreatedOnSrc, COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) AS MemberEnrollmentStatusRecId
FROM dbo.MemberEnrollmentStatus MES
	INNER JOIN dbo.MemberConsNoMPMpi MCNMM
	ON MES.MemberRecId = MCNMM.MemberRecId
Group By MES.SORId, MES.CreatedOnSrc
Having COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) > 1

--DELETE dbo.MemberEnrollmentStatus
FROM dbo.MemberEnrollmentStatus MES1
	INNER JOIN (
					SELECT MES.SORId, MES.CreatedOnSrc, COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) AS MemberEnrollmentStatusRecId
					FROM dbo.MemberEnrollmentStatus MES
						INNER JOIN dbo.MemberRecIdCon MRIC
						ON MES.MemberRecId = MRIC.MemberRecId
					Group By MES.SORId, MES.CreatedOnSrc
					Having COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) > 1
			   ) AS DUP
	ON MES1.SORId = DUP.SORId AND MES1.CreatedOnSrc = DUP.CreatedOnSrc
WHERE MES1.OrgId IS NULL
;


Select


Select *
From dbo.MemberConsNoMPMpi MCNMM
Where mpi = '0080026876781'
;

Select Top 100 MES.*
From dbo.MemberEnrollmentStatus MES
Where SORId = 'S00082739062'

Select Distinct MES.*--, MBP.OrgId
From dbo.MemberEnrollmentStatus MES
	Inner Join dbo.MemberConsNoMPMpi MCNMM
	On MCNMM.mpi = MES.MPI
	Inner Join dbo.MemberBenefitPackage MBP
	On MES.MPI = MBP.MPI
		and MES.EffectiveDate Between MBP.EffectiveDate and Isnull(MBP.EffectiveDate, MBP.EffectiveDate + 1)
;

Select Distinct MES.*--, MBP.OrgId
From dbo.MemberConsNoMPMpi MCNMM
	On MCNMM.mpi = MES.MPI
	Inner Join dbo.MemberBenefitPackage MBP
	On MES.MPI = MBP.MPI
		and MES.EffectiveDate Between MBP.EffectiveDate and Isnull(MBP.EffectiveDate, MBP.EffectiveDate + 1)
;

Select MES.*, BP.CompanyContract
From dbo.MemberBenefitPackage MES
	Inner Join dbo.MemberConsNoMPMpi MCNMM	
	On MCNMM.memberRecId = MES.memberRecId
	Inner Join mref.BenefitPackage BP
	On MES.BenefitPackageMRefId = BP.BenefitPackageMRefId
;--1191


End--=============================UpdateMemberEnrollmentStatus===========================

Select Distinct --MCNMM.*
				--MBPC.*	
				MBPC.MemberRecId
From dbo.MemberConsNoMPMpi MCNMM
	Inner Join dbo.MemberBenefitPackageConsolidation MBPC
	On MCNMM.mpi = MBPC.MPI
;


Select Distinct MCNMM.*,
				MBPC.memberRecId				
From dbo.MemberConsNoMPMpi MCNMM
	Inner Join dbo.MemberBenefitPackageConsolidation MBPC
	On MCNMM.mpi = MBPC.MPI
Order By MCNMM.mpi
;


Select Distinct *
From dbo.MemberConsNoMPMpi
;



--Multiple contracts
--0080002366737
--0080003205547
--0080003209267
--0080004443947
--0080006193533

--Normal
--0008000032375: Los estatus de enrollment pueden estar duplicados por la compañia.
--0013042901427
--0080000010426
--0080000032748
--000000112350