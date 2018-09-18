
--======================dbo.MemberBenefitPackage=====================
--1. Se consolidan los rec id.
--2. Se eliminan los duplicados de sorid por createdonsource date cuando el orgid es nulo. Esto se puede hacer con la tabla dbo.member también.
--3. Eliminar los que no tengan MPI.
SELECT COUNT(*)
FROM dbo.MemberBenefitPackage
;--2,205,788

SELECT COUNT(*)
FROM dbo.MemberBenefitPackage MBP
WHERE MBP.MPI is not null
;--808,768

SELECT COUNT(*)
FROM dbo.MemberBenefitPackage MBP
WHERE MBP.MPI is null
;--1,397,020


SELECT Top 100 *
FROM dbo.MemberBenefitPackage MBP
WHERE MBP.MPI is null
;--1,397,020


SELECT COUNT(*)
FROM dbo.MemberBenefitPackage MBP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MBP.MemberRecId = MRIC.MemberRecId
;--1,073,880

SELECT COUNT(Distinct MBP.mpi)
FROM dbo.MemberBenefitPackage MBP
WHERE MBP.MPI is not null
;--269,252

SELECT COUNT(Distinct MRIC.mpi)
FROM dbo.MemberRecIdCon MRIC
WHERE MRIC.MPI is not null
;--268,907

SELECT Top 100 MRIC.*
FROM dbo.MemberRecIdCon MRIC
	Left Join dbo.MemberBenefitPackage MBP
	ON MBP.MemberRecId = MRIC.MemberRecId
Where MBP.MPI is null
	and MRIC.MPI = '0080007744543'
Order By MBP.MPI
;--1,073,880

Select *
From dbo.MemberRecIdCon MRIC
Where mric.MPI = '0080007744543'

Select *
From dbo.MPIMembership M
Where M.MPI = '0080007744543'


Select *
From dbo.Member
Where mpi = '0080007744543'

SELECT Top 100 mbp.*
FROM dbo.MemberBenefitPackage MBP	
Where MBP.MPI = '0080007744543'--'0080007744543'
;--1,073,880

--Faltan 23,500 records.


SELECT COUNT(Distinct MBP.mpi)
FROM dbo.MemberBenefitPackage MBP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MBP.MemberRecId = MRIC.MemberRecId
;--245,346


SELECT *
FROM dbo.MemberBenefitPackage MBP
WHERE MBP.MPI = '0080017109727'
	--and OrgId = 'H4004'
;

SELECT Top 100 *
FROM dbo.MemberBenefitPackage MBP
WHERE 1 = 1
	and MBP.MemberRecId is null
	--= '0AA5D5A6-512D-4383-8DF3-CCE7521E9A46'
	--MBP.MPI = '0080017109727'
	--and OrgId = 'H4004'
;

SELECT Count(*)
FROM dbo.MemberBenefitPackage MBP
WHERE 1 = 1
	and MBP.MemberRecId is null

Update [dbo].[memberbenefitpackagempsource]
Set MemberRecId = M.MemberRecId 
From [dbo].[memberbenefitpackagempsource] MBPS
 Inner Join Xref.Carrier C
 On MBPS.orgId = C.ExternalValue
 Inner Join dbo.Member M
 On MBPS.MPI = M.MPI and M.CarrierMRefId = C.CarrierMRefId
;

--==============================================
--UPDATE dbo.MemberBenefitPackage
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.MemberBenefitPackage MBP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MBP.MemberRecId = MRIC.MemberRecId
--WHERE MRIC.MPI = '0080021882191'
;--3,989,308--1:16

Update dbo.MemberRecIdCon
	SET memberRecIdCons = MBP.MemberRecId
From dbo.MemberRecIdCon MRI
	 Inner Join [dbo].[MemberBenefitPackageConsolidation] MBP
	 On MRI.MPI = MBP.MPI
;


----DELETE dbo.MemberEnrollmentStatus
--FROM dbo.MemberEnrollmentStatus MES1
--	INNER JOIN (
--					SELECT MES.SORId, MES.CreatedOnSrc, COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) AS MemberEnrollmentStatusRecId
--					FROM dbo.MemberEnrollmentStatus MES
--						INNER JOIN dbo.MemberRecIdCon MRIC
--						ON MES.MemberRecId = MRIC.MemberRecId
--					WHERE 1 = 1
--						--and MRIC.MPI = '0080021882191'
--						--and OrgId is null
--					Group By MES.SORId, MES.CreatedOnSrc
--					Having COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) > 1
--			   ) AS DUP
--	ON MES1.SORId = DUP.SORId AND MES1.CreatedOnSrc = DUP.CreatedOnSrc
--WHERE MES1.OrgId IS NULL
--;--166,096

--SE ELIMINAN MPI NULOS
--DELETE dbo.MemberBenefitPackage
WHERE MPI IS NULL
;--3,835,378
--==============================================
--======================dbo.MemberEnrollmentStatus=====================


