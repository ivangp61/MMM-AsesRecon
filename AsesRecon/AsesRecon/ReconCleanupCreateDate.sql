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

--1.===========================================================================
--truncate table dbo.memberrecidcon;
--Insert Into dbo.MemberRecIdCon(mpi, NAME_ID, memberRecId, carrierMrefId)
Select Distinct MM.MPI, M.SORId, M.MemberRecId, M.CarrierMRefId
From dbo.MPIMembership MM
	INNER JOIN dbo.Member M
	On MM.MPI = M.MPI --AND MM.CarrierMRefId = M.CarrierMRefId
;--563,386
--=============================================================================

--2.===========================================================================
--Truncate Table [dbo].[MemberBenefitPackageMax];

--Insert Into [dbo].[MemberBenefitPackageMax](MPI,LastUpdateOnSrc)
Select distinct M.MPI, Max(MBPS.CreatedOnSrc) as srcDate
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.MPI = MM.MPI
	Inner Join [dbo].[memberbenefitpackagempsource] MBPS
	On M.MPI = MBPS.MPI
Where 1 = 1
	--and MM.MPI = '0080021776807'
	--and EffectiveDate >= IsNull(TerminationDate, EffectiveDate + 1)
	--and M.SORId = 'N00228014424'
Group By M.MPI
--order by M.MPI
--===========================================================================


--263,947


Select*
From [dbo].[MemberBenefitPackageMax]

Select Count(*)
From [dbo].[MemberBenefitPackageMax]


Select mpi, Count(distinct LastUpdateOnSrc)
From [dbo].[MemberBenefitPackageMax]
Group By mpi
Having Count(distinct LastUpdateOnSrc) > 1

--3.===========================================================================
--Truncate Table dbo.MemberBenefitPackageConsolidation;

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

Select	distinct 
			MBP.MemberBenefitPackageRecId
		   ,M.MemberRecId
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
From [dbo].[MemberBenefitPackageMpSource] MBP
	Inner Join Xref.Carrier C
	On MBP.orgId = C.ExternalValue
	Inner Join dbo.Member M
	On MBP.MPI = M.MPI and M.CarrierMRefId = C.CarrierMRefId
	inner Join	[dbo].[MemberBenefitPackageMax] as LastProduct
	On MBP.MPI = LastProduct.MPI and MBP.CreatedOnSrc = LastProduct.LastUpdateOnSrc
Where 1 = 1
	--and MM.MPI = '0080021776807'
	--and MBP.EffectiveDate >= IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)
	--and M.SORId = 'N00228014424'
	--and mbp.memberrecid = '2944CDB0-095A-4667-80A6-6C4A4752C5ED'
;--268,907


--===============================NulosEnConsolidacion==============
--ValidacionAfiliadosNulosEndbo.MemberRecIdCon

--Insert Into [dbo].[MemberBenefitPackageMax](MPI,LastUpdateOnSrc)
SELECT M.MPI, Max(MBP.CreatedOnSrc)
FROM [dbo].[MemberBenefitPackageMpSource] MBP
	INNER JOIN dbo.MemberRecIdCon M
	ON MBP.mpi = M.mpi
WHERE memberRecIdCons is null
Group By M.MPI
;


Select Distinct LastProduct.MPI
From [dbo].[MemberBenefitPackageMpSource] MBPS
	Inner Join Xref.Carrier C
	On MBPS.orgId = C.ExternalValue
	Inner Join [dbo].[MemberBenefitPackageMax] LastProduct
	On MBPS.MPI = LastProduct.MPI and MBPS.CreatedOnSrc = LastProduct.LastUpdateOnSrc
	Inner Join dbo.MemberRecIdCon MRIC
	On LastProduct.MPI = MRIC.MPI
	Inner Join dbo.Member M
	On LastProduct.MPI = M.MPI --and M.CarrierMRefId = C.CarrierMRefId
Where 1 = 1
	and memberRecIdCons is null
--MBP.MPI = '0080000078578'
Select *
From dbo.Member M
Where MPI = '0080017109727'

Select *
From [dbo].[MemberBenefitPackageMpSource]
Where MPI = '0080017109727'
--===================================================================
--===========================================================================


Select *
From dbo.MemberBenefitPackageConsolidation M
--Order By M.MPI
Where M.MPI = '0080000580242'

Select Distinct m.mpi, 
--m.CreatedOnSrc, 
--m.MemberRecId,
Count(Distinct m.OrgId)
From dbo.MemberBenefitPackageConsolidation M
Inner Join (
			Select mpi, Count(distinct memberrecid) ac
			From dbo.MemberBenefitPackageConsolidation M
			Group By mpi
			Having Count(distinct memberrecid) > 1
		) A
		on m.mpi = a.mpi
--Where M.MPI in('0080000089728')
Group By m.mpi
Having Count(Distinct m.OrgId) > 1
Order By M.MPI
Select Count(*)
--Count(distinct mpi)
From dbo.MemberBenefitPackageConsolidation M

--=============DuplicatePackages=============
Select mpi, Count(distinct PackageId)
From dbo.MemberBenefitPackageConsolidation M
Group By mpi
Having Count(distinct PackageId) > 1
--===========================================

Select mpi, Count(distinct memberrecid)
From dbo.MemberBenefitPackageConsolidation M
Group By mpi
Having Count(distinct memberrecid) > 1

--=============DuplicateMPI=============
Select memberrecid, Count(distinct mpi)
From dbo.MemberBenefitPackageConsolidation M
Group By memberrecid
Having Count(distinct mpi) > 1
--===========================================
Select *
From dbo.member m
Where m.memberrecid = '2944CDB0-095A-4667-80A6-6C4A4752C5ED'

Select *
From dbo.MemberBenefitPackageConsolidation M
Where m.memberrecid = '2944CDB0-095A-4667-80A6-6C4A4752C5ED'

END--===================CURRENT_RECORD================================



--======================UPDATE_MEMBERRECID============================

SELECT COUNT(DISTINCT MPI)
FROM dbo.Member
;--269,457
SELECT COUNT(DISTINCT MPI)
FROM [dbo].[memberbenefitpackagempsource]
;--269,625

SELECT DISTINCT MPI
FROM dbo.Member
EXCEPT
SELECT DISTINCT MPI
FROM [dbo].[memberbenefitpackagempsource]
;--207: Enviar a Josue


SELECT --COUNT(*)
COUNT(DISTINCT MPI)
FROM dbo.MemberBenefitPackageConsolidation
;--268,601

SELECT *
FROM dbo.MemberBenefitPackageConsolidation
WHERE MPI = '0080000078578'

SELECT COUNT(DISTINCT M.MPI)
FROM dbo.MemberBenefitPackageConsolidation MBP
	INNER JOIN dbo.Member M
	ON MBP.MPI = M.MPI
;--268,601



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
;--858: Enviar a Josue


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

SELECT top 100 *
FROM [dbo].[MemberBenefitPackageConsolidation] 
WHERE MPI = '0080021776807'
;



Select Distinct TOP 100 MM.*
From dbo.MPIMembership MM
Where MM.NAME_ID = 'N00053894188'
;

Select COUNT(Distinct MM.MPI)
From dbo.MPIMembership MM
Where MM.NAME_ID = 'N00053894188'
;


SELECT *
FROM dbo.MemberRecIdCon
WHERE memberRecIdCons is null
ORDER BY MPI
;

SELECT DISTINCT MBP.memberRecId
FROM [dbo].[MemberBenefitPackageMpSource] MBP
	INNER JOIN dbo.MemberRecIdCon M
	ON MBP.MemberRecId = M.MemberRecId
WHERE memberRecIdCons is null
--WHERE MPI = '0080000012261'
;

SELECT DISTINCT MBP.*
FROM [dbo].[MemberBenefitPackageMpSource] MBP
	INNER JOIN dbo.MemberRecIdCon M
	ON MBP.MemberRecId = M.MemberRecId
WHERE memberRecIdCons is null
--WHERE MPI = '0080000012261'
;


SELECT M.MPI, Max(MBP.CreatedOnSrc)
FROM [dbo].[MemberBenefitPackageMpSource] MBP
	INNER JOIN dbo.MemberRecIdCon M
	ON MBP.MemberRecId = M.MemberRecId
WHERE memberRecIdCons is null
Group By M.MPI
--WHERE MPI = '0080000012261'
;


--1. Ver duplicados de MPI y memberrecidcons
--2. Enviar los que sobren.

SELECT top 100 *
FROM [dbo].[MemberBenefitPackageConsolidation] 
WHERE MPI = '0080021776807'
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
	 Inner Join [dbo].[MemberBenefitPackageConsolidation] MBP
	 On MRI.MPI = MBP.MPI
--Where MRI.mpi = '0080021882191'
;--553,429: 4 SEGS


SELECT *
FROM dbo.MemberRecIdCon M
--	Inner Join dbo.MemberBenefitPackageConsolidation MBPC
--	On M.MPI = MBPC.MPI
WHERE memberRecIdCons is null
--======================UPDATE_MEMBERRECID============================


--======================dbo.MemberEnrollmentStatus=====================
--1. Se consolidan los rec id.
--2. Se eliminan los duplicados de sorid por createdonsource date cuando el orgid es nulo. Esto se puede hacer con la tabla dbo.member también.
--3. Eliminar los que no tengan MPI.
SELECT COUNT(*)
FROM dbo.MemberEnrollmentStatus
;--7,802,460

SELECT COUNT(*)
FROM dbo.MemberEnrollmentStatus MES
WHERE MES.MPI is not null
;--3,802,638


SELECT COUNT(*)
FROM dbo.MemberEnrollmentStatus MES
WHERE MES.MPI is null
;--3,999,822

SELECT COUNT(*)
FROM dbo.MemberEnrollmentStatus MES
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MES.MemberRecId = MRIC.MemberRecId
;--3,989,308

--==============================================
--UPDATE dbo.MemberEnrollmentStatus
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.MemberEnrollmentStatus MES
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MES.MemberRecId = MRIC.MemberRecId
--WHERE MRIC.MPI = '0080021882191'
;--3,989,308--1:16

SELECT *
FROM dbo.MemberEnrollmentStatus MES
WHERE MES.MPI = '0080021776807'
	--and OrgId = 'H4004'
;


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
;--166,096

--SE ELIMINAN MPI NULOS
--DELETE dbo.MemberEnrollmentStatus
WHERE MPI IS NULL
;--3,835,378
--==============================================
--======================dbo.MemberEnrollmentStatus=====================


--======================dbo.MemberPCP==================================
--1. Se consolidan los rec id.
--2. Se eliminan los duplicados de sorid por createdonsource date cuando el orgid es nulo. Esto se puede hacer con la tabla dbo.member también.
--3. Eliminar los que no tengan MPI
SELECT COUNT(*)
FROM dbo.MemberPCP
;--1,705,592

SELECT COUNT(*)
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON PCP.MemberRecId = MRIC.memberRecId
;--907,669

SELECT COUNT(*)
FROM dbo.MemberPCP PCP
WHERE PCP.MPI IS NOT NULL
;--908,170

SELECT COUNT(Distinct MPI)
FROM dbo.MemberPCP PCP
WHERE PCP.MPI IS NOT NULL
;--268,900


Select Count(*)
From dbo.MemberExtrPCP
--Where 
--831,154

SELECT COUNT(DISTINCT PCP.MemberRecId)
FROM dbo.MemberPCP PCP
WHERE PCP.MPI IS NULL
;--454,154



SELECT COUNT(DISTINCT MRIC.MemberRecId)
FROM dbo.MemberRecIdCon MRIC
;--563,386

SELECT TOP 100 *
FROM dbo.MemberPCP PCP
WHERE MPI = '0080021882191'
;

SELECT TOP 100 *
FROM dbo.MemberExtrPCP MEP
WHERE MPI = '0080021882191'
;

Select MEP.*
From dbo.MemberPCP PCP
	Inner Join dbo.MemberExtrPCP MEP
	On MEP.MPI = PCP.MPI and PCP.CreatedOnSrc = MEP.CREATEDON--MEES.ORG_ID = C.ExternalValue 
WHERE mep.MPI = '0080021882191'
;




SELECT *
FROM dbo.MemberExtrPCP
WHERE MPI = '0080021882191'
;

SELECT *
FROM dbo.MemberPCP PCP
WHERE MPI = '0080021882191'
;

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

SELECT DISTINCT *
--DISTINCT top 100 PCP.*
FROM dbo.memberextrpcp ExtrPcp
WHERE 1 = 1
	--and MPI = '0080000008470'
	and ORG_ID is null
--903,987
--371,999

SELECT *
FROM dbo.MemberPCP PCP
WHERE 1 = 1
	and MPI = '0080000008470'
	--and OrgId is null
;

Select *
From dbo.memberextrpcp ExtrPcp
Where MemberRecId = '2D1B8346-0BE5-4E0B-939F-B068B0148758'


Select *
From dbo.member
Where --MPI = '0080000008470'
--SORId in('N00090625260','N00090625260')
MemberRecId = '2D1B8346-0BE5-4E0B-939F-B068B0148758'


Select *
From dbo.MPIMembership MEP
	--Inner Join dbo.Member M
	--On MEP.MPI = M.MPI
Where MEP.MPI = '0080000008470'
;

Select pcp.*
From dbo.MPIMembership MEP
	Inner Join dbo.Member M
	On MEP.MPI = M.MPI
	Inner Join dbo.MemberPCP PCP
	On PCP.MemberRecId = M.MemberRecId
WHERE 1 = 1
	and M.MPI = '0080000008470'
--PCP.MemberRecId = '2D1B8346-0BE5-4E0B-939F-B068B0148758'


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

--======================================================

--Delete dbo.MemberPCP
Where orgId is null;

--Delete dbo.MemberPCP
Where mpi is null;

--UPDATE dbo.MemberPCP
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON PCP.MemberRecId = MRIC.MemberRecId
;--886,973--0:32



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



