--===================ARCHIVE==============================
--Crear tablas de backup a las tablas a limpiar. Misma estructura de las tablas actuales, pero con el archive alfrente.
--Estas tablas deben conservar el estatus de los records antes del proceso de limpieza.
--dbo.MemberArchive
--dbo.MemberHealthCareAdminArchive
--dbo.MemberBenefitPackageArchive
--dbo.dbo.MemberPCPArchive
--dboMemberEnrollmentStatusArchive
--===================ARCHIVE==============================

--===================RECON================================
--1. ¿Cuantos afiliados tengo en dboMember que hacen match con dbo.MPIMembership? 
Select Count(*)
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.MPI = MM.MPI
;--736,445 con los duplicados

Select Count(Distinct M.MPI)
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.MPI = MM.MPI
;--268,906

SELECT COUNT(*)
FROM dbo.MemberBenefitPackageConsolidation
;

Select *
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.SORId = MM.NAME_ID
Where 1 = 1
	and MM.MPI = '0080021117817'
	--and M.SORId = 'N00228014424'
;

Select *
From dbo.Member M
Where MPI = '0080021882191'
;

Select *
From dbo.MPIMembership MM
Where 1 = 1
	and MM.MPI = '0080021882191'
	--and M.SORId = 'N00228014424'
;
--===================RECON================================


BEGIN--A.===================CURRENT_RECORD================================
--1. Validar afiliados con MPI que solo tengan una cubierta y la misma se encuente cancelada. 
--	 ya que esa sera la que se utilizara para para obtener el record.
--2. Validar afiliados que con dos records, pero que no tenga cubierta.
--3. Validar los afiliados que tengan doble record en la tabla de cubierta.
Select C.MPI, Count(Distinct C.MemberRecId) AS totalMembRecId
From dbo.MemberBenefitPackageConsolidation C
Group By C.MPI
Having Count(Distinct C.MemberRecId) > 1
;

--4. Crear una tabla de benefit package para ultima vigencia de los afiliados.
--5. El ultimo vigente funciona para:
--	A. Quedarme con el memberRecId correcto.
--	B. Actualizar esos memberRecId en todas las tablas.

--Truncate Table dbo.MemberBenefitPackageConsolidation;

Select *
From dbo.MemberBenefitPackageConsolidation
;--263,947

--INSERT INTO dbo.MemberBenefitPackageConsolidation
--           (MemberBenefitPackageRecId
--           ,MemberRecId
--           ,BenefitPackageMRefId
--           ,EffectiveDate
--           ,TerminationDate
--           ,SORId
--           ,CreatedBySrc
--           ,CreatedOnSrc
--           ,LastUpdateBySrc
--           ,LastUpdateOnSrc
--           ,JobLoadDate
--           ,MPI
--           ,PackageId
--           ,OrgId
--           ,Pbp)

Select		MBP.MemberBenefitPackageRecId
           ,MBP.MemberRecId
           ,MBP.BenefitPackageMRefId
           ,MBP.EffectiveDate
           ,MBP.TerminationDate
           ,MBP.SORId
           ,MBP.CreatedBySrc
           ,MBP.CreatedOnSrc
           ,MBP.LastUpdateBySrc
           ,MBP.LastUpdateOnSrc
           ,MBP.JobLoadDate
		   ,LastProduct.MPI
           ,MBP.PackageId
           ,MBP.OrgId
           ,MBP.Pbp
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.SORId = MM.NAME_ID
	Inner Join dbo.MemberBenefitPackage MBP
	On M.MemberRecId = mbp.MemberRecId
	inner Join
	(
		Select M.MPI, Max(MBP.EffectiveDate) as effectiveDate
		From dbo.Member M
			Inner Join dbo.MPIMembership MM
			On M.SORId = MM.NAME_ID
			Inner Join dbo.MemberBenefitPackage MBP
			On M.MemberRecId = mbp.MemberRecId
		Where 1 = 1
			--and MM.MPI = '0080021882191'
			and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
			--and M.SORId = 'N00228014424'
		Group By M.MPI
	) as LastProduct
	On M.MPI = LastProduct.MPI and MBP.EffectiveDate = LastProduct.effectiveDate
Where 1 = 1
	--and MM.MPI = '0080003485453'
	and MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)
	--and M.SORId = 'N00228014424'
;


Select MBP.*
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.SORId = MM.NAME_ID
	Inner Join dbo.MemberBenefitPackage MBP
	On M.MemberRecId = mbp.MemberRecId
Where 1 = 1
	and MM.MPI = '0080021882191'
	and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
	--and M.SORId = 'N00228014424'
;


Select M.MPI, Max(MBP.EffectiveDate) as effectiveDate
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.SORId = MM.NAME_ID
	Inner Join dbo.MemberBenefitPackage MBP
	On M.MemberRecId = mbp.MemberRecId
Where 1 = 1
	and MM.MPI = '0080021882191'
	and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
	--and M.SORId = 'N00228014424'
Group By M.MemberRecId, M.MPI
;
END--===================CURRENT_RECORD================================



--======================UPDATE_MEMBERRECID============================

--Truncate Table dbo.MemberRecIdCon;
--Insert Into dbo.MemberRecIdCon(mpi, NAME_ID, memberRecId, carrierMrefId)
Select Distinct MM.MPI, M.SORId, M.MemberRecId, M.CarrierMRefId
From dbo.MPIMembership MM
	INNER JOIN dbo.Member M
	On MM.NAME_ID = M.SORId
;--560,749
--1,022: Dups


--Update dbo.MemberRecIdCon
	SET memberRecIdCons = MBP.MemberRecId
From dbo.MemberRecIdCon MRI
	 Inner Join
	 (

		Select M.MPI, MBPC.MemberRecId
		From dbo.MemberRecIdCon M
			Inner Join [dbo].[MemberBenefitPackageConsolidation] MBPC
			On M.MemberRecId = MBPC.MemberRecId
	 ) MBP
	 On MRI.MPI = MBP.MPI
--Where MRI.mpi = '0080021882191'
;--550,785: 4 SEGS

--Update dbo.MemberRecIdCon
SET memberRecIdCons = MBP1.MemberRecId
From dbo.MemberRecIdCon MRIC1
	Inner Join dbo.MemberBenefitPackage MBP1
	On MRIC1.MemberRecId = MBP1.MemberRecId
	Inner Join (
					Select MRIC.MPI
					--, mbp.MemberRecId
					, Max(MBP.EffectiveDate) as effectiveDate
					From dbo.Member M
						Inner Join dbo.MPIMembership MM
						On M.SORId = MM.NAME_ID
						Inner Join dbo.MemberBenefitPackage MBP
						On M.MemberRecId = mbp.MemberRecId
						Inner Join dbo.MemberRecIdCon MRIC
						On MRIC.MemberRecId  = MBP.MemberRecId
					Where 1 = 1
						and memberRecIdCons is null
						--and MM.MPI = '0080021882191'
						--and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
						--and M.SORId = 'N00228014424'
					Group By MRIC.MPI--, mbp.MemberRecId
				) MaxProd
	On MRIC1.MPI = MaxProd.mpi and MBP1.effectiveDate = MaxProd.effectiveDate
Where MRIC1.memberRecIdCons is null
;--5,361

Select *
From dbo.MemberRecIdCon M
Where 1 = 1
	and memberRecIdCons is null
	--and M.mpi = '0080021882191'
Order By mpi
;--Enviar nulos luego de la limpieza.
--Enviar a Josue los cancelados.


Select MBP.*
From dbo.MemberRecIdCon M
	Inner Join DBO.MemberBenefitPackage MBP
	On M.memberRecId = MBP.MemberRecId
Where 1 = 1
	and memberRecIdCons is null
	--and M.mpi = '0080021882191'
	AND MBP.EffectiveDate <> MBP.TerminationDate
Order By mpi
;



Select	  M.SORId
		, M.MemberRecId
		, M.CarrierMRefId
From dbo.MPIMembership MM
	INNER JOIN dbo.Member M
	On MM.NAME_ID = M.SORId
	Inner Join [dbo].[MemberBenefitPackageConsolidation] MBPC
	On M.MemberRecId = MBPC.MemberRecId
;--264,169
--1,022: Dups

Select Count(*)
From dbo.MemberRecIdCon
;--560,965

Select Count(Distinct mpi)
From dbo.MemberRecIdCon
;--268,915


Select Top 100 *
From dbo.MemberRecIdCon M
Where 1 = 1
	--and M.mpi = '0080021882191'
	and M.MPI = '0080021117817'
;

--EAABB375-98B6-45CE-898D-E2E5E8CAEFFD: Vigente
Select *
From [dbo].[MemberBenefitPackageConsolidation] MBP
Where MBP.mpi = '0080021882191'
;

Select Count(*)
From [dbo].[MemberBenefitPackageConsolidation]
;--263,947

Select MRI.*, MBP.MemberRecId
From dbo.MemberRecIdCon MRI
	 Inner Join
	 (

		Select M.MPI, MBPC.MemberRecId
		From dbo.MemberRecIdCon M
			Inner Join [dbo].[MemberBenefitPackageConsolidation] MBPC
			On M.MemberRecId = MBPC.MemberRecId
	 ) MBP
	 On MRI.MPI = MBP.MPI
--Where MRI.mpi = '0080021882191'
;--552,619




--INSERT INTO dbo.MemberBenefitPackageConsolidation
--           (MemberBenefitPackageRecId
--           ,MemberRecId
--           ,BenefitPackageMRefId
--           ,EffectiveDate
--           ,TerminationDate
--           ,SORId
--           ,CreatedBySrc
--           ,CreatedOnSrc
--           ,LastUpdateBySrc
--           ,LastUpdateOnSrc
--           ,JobLoadDate
--           ,MPI
--           ,PackageId
--           ,OrgId
--           ,Pbp)

Select		MBP.MemberBenefitPackageRecId
           ,MBP.MemberRecId
           ,MBP.BenefitPackageMRefId
           ,MBP.EffectiveDate
           ,MBP.TerminationDate
           ,MBP.SORId
           ,MBP.CreatedBySrc
           ,MBP.CreatedOnSrc
           ,MBP.LastUpdateBySrc
           ,MBP.LastUpdateOnSrc
           ,MBP.JobLoadDate
		   ,LastProduct.MPI
           ,MBP.PackageId
           ,MBP.OrgId
           ,MBP.Pbp
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.SORId = MM.NAME_ID
	Inner Join dbo.MemberBenefitPackage MBP
	On M.MemberRecId = mbp.MemberRecId
	inner Join
	(
		Select M.MPI, Max(MBP.EffectiveDate) as effectiveDate
		From dbo.Member M
			Inner Join dbo.MPIMembership MM
			On M.SORId = MM.NAME_ID
			Inner Join dbo.MemberBenefitPackage MBP
			On M.MemberRecId = mbp.MemberRecId
		Where 1 = 1
			--and MM.MPI = '0080021882191'
			and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
			--and M.SORId = 'N00228014424'
		Group By M.MPI
	) as LastProduct
	On M.MPI = LastProduct.MPI and MBP.EffectiveDate = LastProduct.effectiveDate
	Inner Join 
Where 1 = 1
	--and MM.MPI = '0080003485453'
	and MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)
	--and M.SORId = 'N00228014424'
;

Select MRIC1.*, MaxProd.effectiveDate, MBP1.MemberRecId, MBP1.EffectiveDate, MBP1.TerminationDate
From dbo.MemberRecIdCon MRIC1
	Inner Join dbo.MemberBenefitPackage MBP1
	On MRIC1.MemberRecId = MBP1.MemberRecId
	Inner Join (
					Select MRIC.MPI
					--, mbp.MemberRecId
					, Max(MBP.EffectiveDate) as effectiveDate
					From dbo.Member M
						Inner Join dbo.MPIMembership MM
						On M.SORId = MM.NAME_ID
						Inner Join dbo.MemberBenefitPackage MBP
						On M.MemberRecId = mbp.MemberRecId
						Inner Join dbo.MemberRecIdCon MRIC
						On MRIC.MemberRecId  = MBP.MemberRecId
					Where 1 = 1
						and memberRecIdCons is null
						--and MM.MPI = '0080021882191'
						--and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
						--and M.SORId = 'N00228014424'
					Group By MRIC.MPI--, mbp.MemberRecId
				) MaxProd
	On MRIC1.MPI = MaxProd.mpi and MBP1.effectiveDate = MaxProd.effectiveDate
Where MRIC1.memberRecIdCons is null
;--5,354


--Update dbo.MemberRecIdCon
SET memberRecIdCons = MBP1.MemberRecId
From dbo.MemberRecIdCon MRIC1
	Inner Join dbo.MemberBenefitPackage MBP1
	On MRIC1.MemberRecId = MBP1.MemberRecId
	Inner Join (
					Select MRIC.MPI
					--, mbp.MemberRecId
					, Max(MBP.EffectiveDate) as effectiveDate
					From dbo.Member M
						Inner Join dbo.MPIMembership MM
						On M.SORId = MM.NAME_ID
						Inner Join dbo.MemberBenefitPackage MBP
						On M.MemberRecId = mbp.MemberRecId
						Inner Join dbo.MemberRecIdCon MRIC
						On MRIC.MemberRecId  = MBP.MemberRecId
					Where 1 = 1
						and memberRecIdCons is null
						--and MM.MPI = '0080021882191'
						--and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
						--and M.SORId = 'N00228014424'
					Group By MRIC.MPI--, mbp.MemberRecId
				) MaxProd
	On MRIC1.MPI = MaxProd.mpi and MBP1.effectiveDate = MaxProd.effectiveDate
Where MRIC1.memberRecIdCons is null
;--5,361



Select Count(*)
From dbo.MemberRecIdCon MRIC
Where memberRecIdCons is null
;--10,180

Select Count(*)
From dbo.MemberBenefitPackage MBP
	Inner Join dbo.MemberRecIdCon MRIC
	On MRIC.MemberRecId  = MBP.MemberRecId
Where memberRecIdCons is null
;--6,695
--3,485: Sin cubierta en MP. Ver que sea unico afiliado.

Select *
From dbo.MemberBenefitPackage MBP
	Inner Join dbo.MemberRecIdCon MRIC
	On MRIC.MemberRecId  = MBP.MemberRecId
Where memberRecIdCons is null
;--6,695


Select Count(*)
From dbo.MemberRecIdCon MRIC
	Left Join dbo.MemberBenefitPackage MBP	
	On MBP.MemberRecId = MRIC.MemberRecId
Where 1 = 1
	and memberRecIdCons is null
	and MBP.MemberRecId is null
;--6,695
--3,485: Sin cubierta en MP. Ver que sea unico afiliado.

Select MRIC.*
From dbo.MemberRecIdCon MRIC
	Left Join dbo.MemberBenefitPackage MBP	
	On MBP.MemberRecId = MRIC.MemberRecId
Where 1 = 1
	and memberRecIdCons is null
	and MBP.MemberRecId is null
;--6,695
--3,485: Sin cubierta en MP. Ver que sea unico afiliado.


Select *
From dbo.MemberBenefitPackage MBP
Where MBP.MemberRecId = 'A3A8EA71-EEA6-4085-823B-58B022969FF3'

Select DISTINCT MBP.MPI, Max(MBP.EffectiveDate)
--MRIC.*
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.MemberBenefitPackage MBP	
	On MBP.MemberRecId = MRIC.MemberRecId
Where 1 = 1
	and memberRecIdCons is null
	--and MBP.MemberRecId is null
Group By MBP.MPI
;--6,695
--3,485: Sin cubierta en MP. Ver que sea unico afiliado.



Select *
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.SORId = MM.NAME_ID
Where 1 = 1
	and MM.MPI = '0080021117817'
	--and M.SORId = 'N00228014424'
;



Select Count(*)
From dbo.MemberBenefitPackageConsolidation MBP
	Inner Join dbo.MemberRecIdCon MRIC
	On MRIC.MemberRecId  = MBP.MemberRecId
Where memberRecIdCons is null
;

Select MRIC.MPI, Max(MBP.EffectiveDate) as effectiveDate
From dbo.MemberBenefitPackage MBP
	Inner Join dbo.MemberRecIdCon MRIC
	On MRIC.MemberRecId  = MBP.MemberRecId
Where 1 = 1
	and memberRecIdCons is null
	--and MM.MPI = '0080021882191'
	--and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
	--and M.SORId = 'N00228014424'
Group By MRIC.MPI
;--5,354



--ENROLLKEYS

Select ME.memberRecId,
M.MPI,M.NAME_ID,M.memberRecIdCons,M.memberRecId,M.carrierMrefId, 


MBPC.MemberRecId,
		MBPC.MemberBenefitPackageRecId, 
		MBPC.BenefitPackageMRefId, 
		MBPC.EffectiveDate, 
		MBPC.TerminationDate, 
		MBPC.SORId, 
		MBPC.CreatedBySrc, 
		MBPC.PackageId, 
		MBPC.OrgId, 
		MBPC.Pbp
From dbo.MemberRecIdCon M
	Inner Join [dbo].[MemberBenefitPackageConsolidation] MBPC
	On M.MemberRecId = MBPC.MemberRecId
	Inner Join dbo.Member ME
	On M.mpi = ME.MPI
Where M.mpi = '0080021882191'
;--263,947

Select ME.memberRecId,
M.MPI,


MBPC.MemberRecId
From dbo.MemberRecIdCon M
	Inner Join [dbo].[MemberBenefitPackageConsolidation] MBPC
	On M.MemberRecId = MBPC.MemberRecId
	Inner Join dbo.Member ME
	On M.mpi = ME.MPI
Where M.mpi = '0080021882191'
;--263,947

Select MRI.*, MBP.MemberRecId
From dbo.MemberRecIdCon MRI
	 Inner Join
	 (

		Select M.MPI, MBPC.MemberRecId
		From dbo.MemberRecIdCon M
			Inner Join [dbo].[MemberBenefitPackageConsolidation] MBPC
			On M.MemberRecId = MBPC.MemberRecId
	 ) MBP
	 On MRI.MPI = MBP.MPI
Where MRI.mpi = '0080021882191'
;--263,947


--Update dbo.MemberRecIdCon
	SET memberRecIdCons = MBP.MemberRecId
--Select MRI.*, MBP.MemberRecId
From dbo.MemberRecIdCon MRI
	 Inner Join
	 (

		Select M.MPI, MBPC.MemberRecId
		From dbo.MemberRecIdCon M
			Inner Join [dbo].[MemberBenefitPackageConsolidation] MBPC
			On M.MemberRecId = MBPC.MemberRecId
	 ) MBP
	 On MRI.MPI = MBP.MPI
--Where MRI.mpi = '0080021882191'
;--




Select MBPC.*
From dbo.MemberRecIdCon M
	Inner Join [dbo].[MemberBenefitPackageConsolidation] MBPC
	On M.MemberRecId = MBPC.MemberRecId
;--263,947



Select M.MemberRecId
, Count(Distinct MBPC.MemberBenefitPackageRecId)
From dbo.MemberRecIdCon M
	Inner Join [dbo].[MemberBenefitPackageConsolidation] MBPC
	On M.MemberRecId = MBPC.MemberRecId
Group By M.MemberRecId
Having Count(Distinct [MemberBenefitPackageRecId]) > 1
;--263,947



Select	  M.MemberRecId
		, Count(Distinct [MemberBenefitPackageRecId])
From dbo.MPIMembership MM
	INNER JOIN dbo.Member M
	On MM.NAME_ID = M.SORId
	Inner Join [dbo].[MemberBenefitPackageConsolidation] MBPC
	On M.MemberRecId = MBPC.MemberRecId
Group By M.MemberRecId
Having Count(Distinct [MemberBenefitPackageRecId]) > 1
;

Select *
From [dbo].[MemberBenefitPackageConsolidation]
Where MemberRecId = 'B27170F4-86D7-45D4-9C16-009361DDAE56'
;

Select *
From dbo.Member M
Where 1 = 1
	AND MemberRecId = 'B27170F4-86D7-45D4-9C16-009361DDAE56'
--	AND M.SORId = 'N00054856265'
;
--======================UPDATE_MEMBERRECID============================

--===============DUPS=====================
Select *
From
(
	Select M.SORId, M.MemberRecId, M.CarrierMRefId, (ROW_NUMBER() OVER(PARTITION BY M.SORId, M.MemberRecId, M.CarrierMRefId ORDER BY M.SORId)) as rowNum
	From dbo.MPIMembership MM
		INNER JOIN dbo.Member M
		On MM.NAME_ID = M.SORId
) as dup
Where rowNum > 1
;
--===============DUPS=====================

--===============DUPS=====================


Select *
From dbo.Member M
Where 1 = 1
	and M.MPI = '0080021882191'
	--and M.SORId = 'N00228014424'
;

Select *
From dbo.MPIMembership MM
Where 1 = 1
	and MM.MPI = '0080021882191'
	--and M.SORId = 'N00228014424'
;


Select Count(*)
From dbo.MPIMembership
;--326,715






--======================dbo.MemberEnrollmentStatus=====================
--1. Se consolidan los rec id.
--2. Se eliminan los duplicados de sorid por createdonsource date cuando el orgid es nulo. Esto se puede hacer con la tabla dbo.member también.
--3. Eliminar los que no tengan MPI
SELECT COUNT(*)
FROM dbo.MemberEnrollmentStatus
;--7,802,466


--ELIMINARLE LOS ORG_ID EN NULOS YA QUE SON DE LOS PRODUCTOS A LOS CUALES EL NO PERTENECIO.
SELECT COUNT(*)
FROM dbo.MemberEnrollmentStatus MES
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MES.MemberRecId = MRIC.MemberRecId
;--3,975,796


--UPDATE dbo.MemberEnrollmentStatus
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.MemberEnrollmentStatus MES
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MES.MemberRecId = MRIC.MemberRecId
--WHERE MRIC.MPI = '0080021882191'
;--3,975,796--1:18

--DELETE dbo.MemberEnrollmentStatus
FROM dbo.MemberEnrollmentStatus MES1
	INNER JOIN (
					SELECT MES.SORId, MES.CreatedOnSrc, COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) AS MemberEnrollmentStatusRecId
					FROM dbo.MemberEnrollmentStatus MES
						INNER JOIN dbo.MemberRecIdCon MRIC
						ON MES.MemberRecId = MRIC.MemberRecId
					WHERE 1 = 1
						--and MRIC.MPI = '0080021882191'
						--and OrgId is null
					Group By MES.SORId, MES.CreatedOnSrc
					Having COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) > 1
			   ) AS DUP
	ON MES1.SORId = DUP.SORId AND MES1.CreatedOnSrc = DUP.CreatedOnSrc
WHERE MES1.OrgId IS NULL
;--3,975,796

SELECT COUNT(*)
FROM dbo.MemberEnrollmentStatus MES
WHERE MES.MPI IS NULL
;

SELECT MES.SORId,
Count(Distinct  IsNull(MES.SORId, 'NULL'))
FROM dbo.MemberEnrollmentStatus MES
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MES.MemberRecId = MRIC.MemberRecId
WHERE 1 = 1
	and MRIC.MPI = '0080021882191'
	and OrgId is null
Group By MES.SORId
Having Count(Distinct  IsNull(MES.SORId, 'NULL')) > 1
;--3,975,796


--=================================================
--SE ELIMINAN LOS DUPLICADOS
SELECT *
FROM dbo.MemberEnrollmentStatus MES1
	INNER JOIN (
					SELECT MES.SORId, MES.CreatedOnSrc, COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) AS MemberEnrollmentStatusRecId
					FROM dbo.MemberEnrollmentStatus MES
						INNER JOIN dbo.MemberRecIdCon MRIC
						ON MES.MemberRecId = MRIC.MemberRecId
					WHERE 1 = 1
						--and MRIC.MPI = '0080021882191'
						--and OrgId is null
					Group By MES.SORId, MES.CreatedOnSrc
					Having COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) > 1
			   ) AS DUP
	ON MES1.SORId = DUP.SORId AND MES1.CreatedOnSrc = DUP.CreatedOnSrc
WHERE MES1.OrgId IS NULL
;--3,975,796
--=================================================

--=================================================
--SE ELIMINAN MPI NULOS
--DELETE dbo.MemberEnrollmentStatus
WHERE MPI IS NULL
;--3,828,643


SELECT COUNT(*)
FROM dbo.MemberEnrollmentStatus MES
WHERE MES.MPI IS NULL
;--3,828,643


SELECT COUNT(*)
FROM dbo.MemberEnrollmentStatus MES
WHERE MES.MPI IS NOT NULL
;--3,813,344

SELECT *
FROM dbo.MemberEnrollmentStatus MES
WHERE MES.MPI = '0080021882191'
	--AND MES.OrgId = 'H4004'
ORDER BY  MES.OrgId, MES.CreatedOnSrc ASC
;--3,813,344


SELECT COUNT(DISTINCT MES.MemberRecId)
FROM dbo.MemberEnrollmentStatus MES
	INNER JOIN dbo.Member M
	ON MES.MemberRecId = M.MemberRecId
WHERE MES.MPI IS NOT NULL
;--3,828,643
--=================================================

--======================dbo.MemberEnrollmentStatus=====================


--======================dbo.MemberPCP=====================

--======================dbo.MemberPCP=====================


Select M.MPI, MBP.LastUpdateOnSrc
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.MPI = MM.MPI
	Inner Join dbo.MemberBenefitPackage MBP
	On M.MemberRecId = mbp.MemberRecId--ES EL JOIN DEL NAMEID, HAY QUE UTILIZAR EL CARRIER TAMBIEN
Where 1 = 1
	and EffectiveDate >= IsNull(TerminationDate, EffectiveDate + 1)
	and MBP.LastUpdateOnSrc is null
order by M.MPI


		Select M.MPI, Max(IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)) as srcDate
		From dbo.Member M
			Inner Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
			Inner Join dbo.MemberBenefitPackage MBP
			On M.MemberRecId = mbp.MemberRecId--ES EL JOIN DEL NAMEID, HAY QUE UTILIZAR EL CARRIER TAMBIEN
		Where 1 = 1
			--and MM.MPI = '0080021776807'
			and EffectiveDate >= IsNull(TerminationDate, EffectiveDate + 1)
			--and M.SORId = 'N00228014424'
		Group By M.MPI
		order by M.MPI