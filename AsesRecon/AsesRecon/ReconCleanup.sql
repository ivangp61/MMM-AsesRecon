--===================CLEANUP==============================
--dbo.Member
--dbo.MemberHealthCareAdmin
--dbo.MemberBenefitPackage
--dbo.MemberPCP
--dbo.MemberEnrollmentStatus
--===================CLEANUP==============================

BEGIN--A.===================CURRENT_RECORD================================
--1. Validar afiliados con MPI que solo tengan una cubierta y la misma se encuente cancelada. 
--	 ya que esa sera la que se utilizara para para obtener el record.
--2. Validar afiliados que con dos records, pero que no tenga cubierta.
--3. Validar los afiliados que tengan doble record en la tabla de cubierta.
Select C.MPI, Count(Distinct C.MemberRecId) AS totalMembRecId
From dbo.MemberBenefitPackageConsolidation C
Group By C.MPI
--Having Count(Distinct C.MemberRecId) > 1
;

--4. Crear una tabla de benefit package para ultima vigencia de los afiliados.
--5. El ultimo vigente funciona para:
--	A. Quedarme con el memberRecId correcto.
--	B. Actualizar esos memberRecId en todas las tablas.
--  C. Determinar cuales afiliados se quedaron nulos en consolidar y porque.
Select *
From dbo.MemberPCP

--Truncate Table dbo.MemberRecIdCon;
--Insert Into dbo.MemberRecIdCon(mpi, NAME_ID, memberRecId, carrierMrefId)
Select Distinct MM.MPI, M.SORId, M.MemberRecId, M.CarrierMRefId
From dbo.MPIMembership MM
	INNER JOIN dbo.Member M
	On MM.MPI = M.MPI --AND MM.CarrierMRefId = M.CarrierMRefId
;--560,749



--Truncate Table dbo.MemberBenefitPackageConsolidation;

--263,947

INSERT INTO dbo.MemberBenefitPackageConsolidation
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

Select	DISTINCT 
			MBP.MemberBenefitPackageRecId           
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
From dbo.Member MM
	Inner Join dbo.MemberBenefitPackage MBP
	On MM.MemberRecId = mbp.MemberRecId
	inner Join
	(
		Select M.MPI, Max(MBP.EffectiveDate) as effectiveDate
		From dbo.Member M
			Inner Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
			Inner Join dbo.MemberBenefitPackage MBP
			On M.MemberRecId = mbp.MemberRecId--ES EL JOIN DEL NAMEID, HAY QUE UTILIZAR EL CARRIER TAMBIEN
		Where 1 = 1
			--and MM.MPI = '0080021776807'
			and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
			--and M.SORId = 'N00228014424'
		Group By M.MPI
	) as LastProduct
	On MM.MPI = LastProduct.MPI and MBP.EffectiveDate = LastProduct.effectiveDate
Where 1 = 1
	--and MM.MPI = '0080021776807'
	and MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)
	--and M.SORId = 'N00228014424'
;--264,398

INSERT INTO dbo.MemberBenefitPackageConsolidation
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

SELECT	DISTINCT 
			MBP.MemberBenefitPackageRecId           
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
		   ,MBP.MPI
           ,MBP.PackageId
           ,MBP.OrgId
           ,MBP.Pbp
FROM
	(
	SELECT DISTINCT
				row_number() over (partition by L1.MPI,MBP.EffectiveDate,MBP.TerminationDate order by MBP.MemberBenefitPackageRecId) AS [PartitionID]
				,MBP.MemberBenefitPackageRecId
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
			   ,L1.MPI
			   ,MBP.PackageId
			   ,MBP.OrgId
			   ,MBP.Pbp
	FROM dbo.MemberBenefitPackage MBP
		INNER JOIN (

			Select DISTINCT M.MPI, Max(MBP.EffectiveDate) as effectiveDate
			From dbo.Member M
				Inner Join dbo.MPIMembership MM
				On M.MPI = MM.MPI
				Inner Join dbo.MemberBenefitPackage MBP
				On M.MemberRecId = mbp.MemberRecId
				Inner Join (
								SELECT DISTINCT MPI
								FROM dbo.Member
								EXCEPT
								SELECT DISTINCT M.MPI
								FROM dbo.MemberBenefitPackageConsolidation MBP
									INNER JOIN dbo.Member M
									ON MBP.MPI = M.MPI
							) L
				On M.mpi = L.MPI
			Group By M.MPI
			) L1
			ON MBP.MPI = L1.MPI AND MBP.effectiveDate = L1.effectiveDate
	) MBP
WHERE partitionId = 1
;--3,317

INSERT INTO dbo.MemberBenefitPackageConsolidation
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

Select	DISTINCT 
			MBP.MemberBenefitPackageRecId           
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
		   ,MBP.MPI
           ,MBP.PackageId
           ,MBP.OrgId
           ,MBP.Pbp
FROM 
	(
	SELECT DISTINCT
				row_number() over (partition by L1.MPI,MBP.EffectiveDate,MBP.TerminationDate order by MBP.MemberBenefitPackageRecId) AS [PartitionID]
				,MBP.MemberBenefitPackageRecId
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
			   ,L1.MPI
			   ,MBP.PackageId
			   ,MBP.OrgId
			   ,MBP.Pbp
	FROM dbo.MemberBenefitPackage MBP
		INNER JOIN (

			Select DISTINCT M.MPI, Max(MBP.EffectiveDate) as effectiveDate
			From dbo.Member M
				Inner Join dbo.MPIMembership MM
				On M.MPI = MM.MPI
				Inner Join dbo.MemberBenefitPackage MBP
				On M.MemberRecId = mbp.MemberRecId
				Inner Join (
								SELECT DISTINCT MPI
								FROM dbo.Member
								EXCEPT
								SELECT DISTINCT M.MPI
								FROM dbo.MemberBenefitPackageConsolidation MBP
									INNER JOIN dbo.Member M
									ON MBP.MPI = M.MPI
							) L
				On M.mpi = L.MPI
			Where 1 = 1
			Group By M.MPI
			) L1
			ON MBP.MPI = L1.MPI
	) MBP
WHERE partitionId = 1
;--202

END--===================CURRENT_RECORD================================



--======================UPDATE_MEMBERRECID============================

SELECT COUNT(DISTINCT MPI)
FROM dbo.Member
;--269,457
SELECT COUNT(DISTINCT MPI)
FROM dbo.MPIMembership
;--269,261

SELECT DISTINCT MPI
FROM dbo.Member
EXCEPT
SELECT DISTINCT MPI
FROM dbo.MPIMembership
;--552


SELECT --COUNT(*)
COUNT(DISTINCT MPI)
FROM dbo.MemberBenefitPackageConsolidation
;--268,067

SELECT *
FROM dbo.MemberBenefitPackageConsolidation
WHERE MPI = '0080000078578'

SELECT COUNT(DISTINCT M.MPI)
FROM dbo.MemberBenefitPackageConsolidation MBP
	INNER JOIN dbo.Member M
	ON MBP.MPI = M.MPI
;--267,020



SELECT DISTINCT MBP.*
FROM dbo.MemberBenefitPackage MBP
WHERE MBP.MPI IN(
					SELECT DISTINCT MPI
					FROM dbo.Member
					EXCEPT
					SELECT DISTINCT M.MPI
					FROM dbo.MemberBenefitPackageConsolidation MBP
						INNER JOIN dbo.Member M
						ON MBP.MPI = M.MPI
				)
;

SELECT *
FROM dbo.MemberBenefitPackageConsolidation MBP
	INNER JOIN (

		Select DISTINCT M.MPI, Max(MBP.EffectiveDate) as effectiveDate
		From dbo.Member M
			Inner Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
			Inner Join dbo.MemberBenefitPackage MBP
			On M.MemberRecId = mbp.MemberRecId--ES EL JOIN DEL NAMEID, HAY QUE UTILIZAR EL CARRIER TAMBIEN
			Inner Join (
							SELECT DISTINCT MPI
							FROM dbo.Member
							EXCEPT
							SELECT DISTINCT M.MPI
							FROM dbo.MemberBenefitPackageConsolidation MBP
								INNER JOIN dbo.Member M
								ON MBP.MPI = M.MPI
						) L
			On M.mpi = L.MPI
				
		Where 1 = 1
			--and MM.MPI = '0080021776807'
			--and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
			--and M.SORId = 'N00228014424'
		Group By M.MPI
		) L1
		ON MBP.MPI = L1.MPI 

SELECT --COUNT(DISTINCT MBP1.MemberBenefitPackageRecId),MPI
*
FROM 
	(
	SELECT DISTINCT 			
				--COUNT(DISTINCT MBP.MemberBenefitPackageRecId)
				row_number() over (partition by L1.MPI,MBP.EffectiveDate,MBP.TerminationDate order by MBP.MemberBenefitPackageRecId) AS [PartitionID]
				,MBP.MemberBenefitPackageRecId
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
			   ,L1.MPI
			   ,MBP.PackageId
			   ,MBP.OrgId
			   ,MBP.Pbp
	FROM dbo.MemberBenefitPackage MBP
		INNER JOIN (

			Select DISTINCT M.MPI, Max(MBP.EffectiveDate) as effectiveDate
			From dbo.Member M
				Inner Join dbo.MPIMembership MM
				On M.MPI = MM.MPI
				Inner Join dbo.MemberBenefitPackage MBP
				On M.MemberRecId = mbp.MemberRecId--ES EL JOIN DEL NAMEID, HAY QUE UTILIZAR EL CARRIER TAMBIEN
				Inner Join (
								SELECT DISTINCT MPI
								FROM dbo.Member
								EXCEPT
								SELECT DISTINCT M.MPI
								FROM dbo.MemberBenefitPackageConsolidation MBP
									INNER JOIN dbo.Member M
									ON MBP.MPI = M.MPI
							) L
				On M.mpi = L.MPI
				
			Where 1 = 1
				--and MM.MPI = '0080001679555'
				--and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
				--and M.SORId = 'N00228014424'
			Group By M.MPI
			) L1
			ON MBP.MPI = L1.MPI --AND MBP.effectiveDate = L1.effectiveDate
	) MBP1
WHERE partitionId = 1
--GROUP BY MBP1.MPI
--HAVING COUNT(DISTINCT MBP1.MemberBenefitPackageRecId) > 1
;--3317



	
SELECT --COUNT(DISTINCT MBP1.MemberBenefitPackageRecId),MPI
*
FROM 
	(
	SELECT DISTINCT 			
				--COUNT(DISTINCT MBP.MemberBenefitPackageRecId)
				row_number() over (partition by L1.MPI,MBP.EffectiveDate,MBP.TerminationDate order by MBP.MemberBenefitPackageRecId) AS [PartitionID]
				,MBP.MemberBenefitPackageRecId
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
			   ,L1.MPI
			   ,MBP.PackageId
			   ,MBP.OrgId
			   ,MBP.Pbp
	FROM dbo.MemberBenefitPackage MBP
		INNER JOIN (

			Select DISTINCT M.MPI, Max(MBP.EffectiveDate) as effectiveDate
			From dbo.Member M
				Inner Join dbo.MPIMembership MM
				On M.MPI = MM.MPI
				Inner Join dbo.MemberBenefitPackage MBP
				On M.MemberRecId = mbp.MemberRecId--ES EL JOIN DEL NAMEID, HAY QUE UTILIZAR EL CARRIER TAMBIEN
				Inner Join (
								SELECT DISTINCT MPI
								FROM dbo.Member
								EXCEPT
								SELECT DISTINCT M.MPI
								FROM dbo.MemberBenefitPackageConsolidation MBP
									INNER JOIN dbo.Member M
									ON MBP.MPI = M.MPI
							) L
				On M.mpi = L.MPI
				
			Where 1 = 1
				--and MM.MPI = '0080001679555'
				--and EffectiveDate <> IsNull(TerminationDate, EffectiveDate + 1)
				--and M.SORId = 'N00228014424'
			Group By M.MPI
			) L1
			ON MBP.MPI = L1.MPI AND MBP.effectiveDate = L1.effectiveDate
	) MBP1
WHERE partitionId = 1
GROUP BY MBP1.MPI
HAVING COUNT(DISTINCT MBP1.MemberBenefitPackageRecId) > 1
;--3317


--Truncate Table dbo.MemberRecIdCon;
--Insert Into dbo.MemberRecIdCon(mpi, NAME_ID, memberRecId, carrierMrefId)
Select Distinct MM.MPI, M.SORId, M.MemberRecId, M.CarrierMRefId
From dbo.MPIMembership MM
	INNER JOIN dbo.Member M
	On MM.MPI = M.MPI --AND MM.CarrierMRefId = M.CarrierMRefId
--Where M.SORId = 'N00033112081' 
;--560,749
--1,022: Dups

SELECT *
--Count(*)
FROM dbo.MemberRecIdCon
WHERE 1 = 1
	--AND SORId = 'N00033112081'
	AND MPI = '0080021776807'
;

SELECT --count(*)
TOP 100*
FROM dbo.Member M
WHERE 1 = 1
	--AND SORId = 'N00033112081'
	AND M.MPI = '0080021776807'
;



Select Distinct TOP 100 MM.*
From dbo.MPIMembership MM
Where MM.NAME_ID = 'N00053894188'

Select COUNT(Distinct MM.MPI)
From dbo.MPIMembership MM
Where MM.NAME_ID = 'N00053894188'


Select *
From xref.Carrier




SELECT M.SORID, COUNT(DISTINCT M.CarrierMRefId)
FROM dbo.Member M
	INNER JOIN (
					SELECT M1.SORID, M1.CarrierMRefId, M1.MemberRecId
					FROM dbo.Member M1
						INNER JOIN dbo.MPIMembership MM1
						ON M1.SORId = MM1.NAME_ID
					WHERE M1.CarrierMRefId IN(1,2)
			   ) M2
			   ON M.SORID = M2.SORID AND M.MemberRecId = M2.MemberRecId
	INNER JOIN dbo.MPIMembership MM
	ON M.SORId = MM.NAME_ID
WHERE M.MPI IS NOT NULL
GROUP BY M.SORID
HAVING COUNT(DISTINCT M.CarrierMRefId) > 1
;

SELECT *
FROM dbo.MemberRecIdCon
WHERE MPI = '0080021776807'
ORDER BY MPI
;

SELECT *
FROM dbo.MemberRecIdCon
WHERE memberRecIdCons is null
ORDER BY MPI
;

SELECT DISTINCT MBP.MPI
FROM dbo.MemberBenefitPackage MBP
	INNER JOIN dbo.MemberRecIdCon M
	ON MBP.MemberRecId = M.MemberRecId
WHERE memberRecIdCons is null
--WHERE MPI = '0080000012261'
;


--1. Ver duplicados de MPI y memberrecidcons
--2. Enviar los que sobren.

SELECT top 100 *
FROM [dbo].[MemberBenefitPackageConsolidation] 
WHERE MPI = '0080022982070'
;

SELECT --Count(*)
m.MPI, Count(Distinct memberRecIdCons)
FROM dbo.MemberRecIdCon M
--WHERE MPI = '0080022982070'
Group By m.MPI
Having Count(Distinct memberRecIdCons) > 1
;


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
;--553,429: 4 SEGS


INSERT INTO dbo.MemberBenefitPackageConsolidation
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

Select	DISTINCT 
			MBP.MemberBenefitPackageRecId ,
			MBP.MemberRecId
           ,MBP.BenefitPackageMRefId
           ,MBP.EffectiveDate
           ,MBP.TerminationDate
           ,MBP.SORId
           ,MBP.CreatedBySrc
           ,MBP.CreatedOnSrc
           ,MBP.LastUpdateBySrc
           ,MBP.LastUpdateOnSrc
           ,MBP.JobLoadDate
		   ,MBP.MPI
           ,MBP.PackageId
           ,MBP.OrgId
           ,MBP.Pbp
FROM 
	(
	SELECT DISTINCT
				row_number() over (partition by L1.MPI,MBP.EffectiveDate,MBP.TerminationDate order by MBP.MemberBenefitPackageRecId) AS [PartitionID]
				,MBP.MemberBenefitPackageRecId
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
			   ,L1.MPI
			   ,MBP.PackageId
			   ,MBP.OrgId
			   ,MBP.Pbp
	FROM dbo.MemberBenefitPackage MBP
		INNER JOIN (

			Select DISTINCT M.MPI, Max(MBP.EffectiveDate) as effectiveDate
			From dbo.Member M
				Inner Join dbo.MPIMembership MM
				On M.MPI = MM.MPI
				Inner Join dbo.MemberBenefitPackage MBP
				On M.MemberRecId = mbp.MemberRecId
				Inner Join (
								SELECT DISTINCT MBP.MPI
								FROM dbo.MemberBenefitPackage MBP
									INNER JOIN dbo.MemberRecIdCon M
									ON MBP.MemberRecId = M.MemberRecId
								WHERE memberRecIdCons is null
							) L
				On M.mpi = L.MPI
			Where 1 = 1
			Group By M.MPI
			) L1
			ON MBP.MPI = L1.MPI and MBP.EffectiveDate = L1.EffectiveDate
	) MBP
WHERE partitionId = 1
;--202

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
;--553,429: 4 SEGS




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


--======================UPDATE_MEMBERRECID============================


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
;--3,989,314


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

--SE ELIMINAN MPI NULOS
--DELETE dbo.MemberEnrollmentStatus
WHERE MPI IS NULL
;--3,828,643
--======================dbo.MemberEnrollmentStatus=====================


--======================dbo.MemberPCP==================================
--1. Se consolidan los rec id.
--2. Se eliminan los duplicados de sorid por createdonsource date cuando el orgid es nulo. Esto se puede hacer con la tabla dbo.member también.
--3. Eliminar los que no tengan MPI
SELECT COUNT(*)
FROM dbo.MemberPCP
;--1,705,593


--ELIMINARLE LOS ORG_ID EN NULOS YA QUE SON DE LOS PRODUCTOS A LOS CUALES EL NO PERTENECIO.
SELECT COUNT(*)
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON PCP.MemberRecId = MRIC.memberRecIdCons
;--903,987
SELECT COUNT(*)
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON PCP.MemberRecId = MRIC.MemberRecId
;--903,987

SELECT COUNT(PCP.MemberRecId)
FROM dbo.MemberPCP PCP
WHERE PCP.MPI IS NOT NULL
;--902,528


SELECT COUNT(DISTINCT PCP.MemberRecId)
FROM dbo.MemberPCP PCP
WHERE PCP.MPI IS NULL
;--802,008


SELECT COUNT(DISTINCT MRIC.MemberRecId)
FROM dbo.MemberRecIdCon MRIC
;--560,965

SELECT COUNT(DISTINCT PCP.MemberRecId)
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON PCP.MemberRecId = MRIC.MemberRecId
--WHERE MRIC.MPI = '0080021882191'
;--903,987
--371,999


SELECT PCP.*
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON PCP.MemberRecId = MRIC.MemberRecId
WHERE 1 = 1
	and MRIC.MPI = '0080000008470'
--	and pcp.OrgId is null
--	and pcp.EffectiveDate > pcp.TerminationDate
;


SELECT *
FROM dbo.MemberRecIdCon MRIC
WHERE MPI = '0080000008470'

SELECT *
FROM dbo.Member M
WHERE M.MPI = '0080000008470'
;

SELECT *
FROM dbo.Member M
WHERE 1 = 1 
	AND SORId = 'N00053894188'
	--AND M.MPI = '0080000008470'
;



SELECT PCP.*
FROM dbo.MemberPCP PCP
WHERE 1 = 1
	and MPI = '0080000008470'
;


D0C1D259-44C3-4D50-92CD-5E3A01D240B8
201A1FDB-82E0-4AE4-B427-0DBBDDB5395D
2D1B8346-0BE5-4E0B-939F-B068B0148758
B537DD79-22E4-4EFB-9995-6A40C4B15608


SELECT DISTINCT *
--DISTINCT top 100 PCP.*
FROM dbo.memberextrpcp ExtrPcp
WHERE 1 = 1
	and MPI = '0080000008470'
--903,987
--371,999

SELECT DISTINCT PCP.*, MBP.OrgId, BP.CompanyContract
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberBenefitPackage MBP
	ON PCP.MemberRecId = MBP.MemberRecId
	INNER JOIN mref.BenefitPackage BP
	ON MBP.BenefitPackageMRefId = BP.BenefitPackageMRefId
WHERE 1 = 1
	AND pcp.OrgId is null
	AND PCP.EffectiveDate BETWEEN MBP.EffectiveDate AND ISNULL(MBP.TerminationDate, PCP.EffectiveDate + 1)
	--AND MBP.OrgId IS NULL
;


SELECT DISTINCT PCP.*, 
--DISTINCT top 100 PCP.*
FROM dbo.memberextrpcp ExtrPcp
	INNER JOIN dbo.MemberPCP PCP
	ON ExtrPcp.MPI = PCP.MPI 
		AND CONVERT(VARCHAR, ExtrPcp.[EFF_DATE], 112) = CONVERT(VARCHAR, PCP.[EffectiveDate], 112)
		AND CONVERT(VARCHAR, ISNULL(ExtrPcp.[TERM_DATE],GETDATE()), 112) = CONVERT(VARCHAR, ISNULL(PCP.[TerminationDate],GETDATE()), 112)
WHERE 1 = 1
	--and PCP.MPI = '0080006985585'
	AND pcp.OrgId is null
--903,987
--371,999



SELECT DISTINCT PCP.*
--DISTINCT top 100 PCP.*
FROM dbo.memberextrpcp ExtrPcp
	INNER JOIN dbo.MemberPCP PCP
	ON ExtrPcp.MPI = PCP.MPI 
		AND CONVERT(VARCHAR, ExtrPcp.[EFF_DATE], 112) = CONVERT(VARCHAR, PCP.[EffectiveDate], 112)
		AND CONVERT(VARCHAR, ISNULL(ExtrPcp.[TERM_DATE],GETDATE()), 112) = CONVERT(VARCHAR, ISNULL(PCP.[TerminationDate],GETDATE()), 112)
WHERE 1 = 1
	--and PCP.MPI = '0080006985585'
	AND pcp.OrgId is null
--903,987
--371,999

SELECT *
--COUNT(*)
FROM dbo.MemberPCP PCP
WHERE pcp.OrgId is null
ORDER BY MPI
;--7,049
--903,987
--371,999

--Update dbo.MemberPCP
	Set mpi = MM.MPI
From [dbo].[MPIMembership] MM
	Inner Join dbo.Member M
	On MM.name_id = M.SORId
	Inner Join dbo.MemberPCP PCP
	On PCP.MemberRecId = M.MemberRecId
;

--======================================================
--UPDATE dbo.MemberPCP
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON PCP.MemberRecId = MRIC.MemberRecId
--WHERE MRIC.MPI = '0080021882191'
;--903,585--0:16

--DELETE dbo.MemberPCP
WHERE MPI IS NULL
;--3,828,643

--DELETE dbo.MemberPCP
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON PCP.MemberRecId = MRIC.MemberRecId
WHERE 1 = 1
--	and MRIC.MPI = '0080002794559'
	and pcp.OrgId is null
	and pcp.EffectiveDate > pcp.TerminationDate
;


--UPDATE dbo.MemberPCP 
SET OrgId = BP.CompanyContract
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberBenefitPackage MBP
	ON PCP.MemberRecId = MBP.MemberRecId
	INNER JOIN mref.BenefitPackage BP
	ON MBP.BenefitPackageMRefId = BP.BenefitPackageMRefId
WHERE 1 = 1
	AND pcp.OrgId is null
	AND PCP.EffectiveDate BETWEEN MBP.EffectiveDate AND ISNULL(MBP.TerminationDate, PCP.EffectiveDate + 1)
	--AND MBP.OrgId IS NULL
;
--======================================================

--SE ELIMINAN RECORDS CON FECHA DE EFECTIVIDAD MAYOR QUE TERMINACION Y ORG ID NULO
SELECT PCP.*
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON PCP.MemberRecId = MRIC.MemberRecId
WHERE 1 = 1
--	and MRIC.MPI = '0080002794559'
	and pcp.OrgId is null
	and pcp.EffectiveDate > pcp.TerminationDate
;

--======================dbo.MemberPCP==================================



