
--======================dbo.MemberHealthCareAdmin=====================
--1. No se consolidan los rec id ya que se van a eliminar los rec id que no sea el consolidado.
--2. Eliminar los que no tengan MPI.
--3. Enviar las restas a Josue: Esta resta es los que estan en dbo.Member y no en HealthCareAdmin y no en dbo.MemberRecIdCon.


Select COUNT(*)
From dbo.MemberHealthCareAdmin
;--1,020,987


Select COUNT(*)
From dbo.MemberHealthCareAdmin MHCA
WHERE MHCA.MPI is not null
;--423,557

Select COUNT(*)
From dbo.MemberHealthCareAdmin MHCA
WHERE MHCA.MPI is null
;--597,431

Select COUNT(Distinct MHCA.MPI)
From dbo.MemberHealthCareAdmin MHCA
WHERE MHCA.MPI is not null
;--269,258



SELECT COUNT(*)
FROM dbo.MemberHealthCareAdmin MHCA
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MHCA.MemberRecId = MRIC.MemberRecId
;--563,385


SELECT COUNT(Distinct M.mpi)
FROM dbo.Member M
WHERE M.MPI is not null
;--269,478


SELECT COUNT(Distinct MHCA.mpi)
FROM dbo.MemberHealthCareAdmin MHCA
WHERE MHCA.MPI is not null
;--269,258

SELECT COUNT(Distinct MRIC.mpi)
FROM dbo.MemberRecIdCon MRIC
WHERE MRIC.MPI is not null
;--268,907


SELECT Count(Distinct MRIC.mpi)
FROM dbo.MemberRecIdCon MRIC
	Inner Join dbo.MemberHealthCareAdmin MHCA
	On MRIC.MPI = MHCA.MPI
;--268,905

SELECT Count(Distinct MRIC.memberRecIdCons)
FROM dbo.MemberRecIdCon MRIC
	Inner Join dbo.MemberHealthCareAdmin MHCA
	On MRIC.memberRecIdCons = MHCA.MemberRecId
;--268,482



SELECT Distinct MHCA.mpi
FROM dbo.MemberHealthCareAdmin MHCA
	Left Join dbo.MemberRecIdCon MRIC
	On MHCA.MPI = MRIC.MPI
WHERE MRIC.MPI is null
;--355

SELECT Distinct MHCA.mpi
FROM dbo.MemberHealthCareAdmin MHCA
	Left Join dbo.MemberRecIdCon MRIC
	On MHCA.MPI = MRIC.MPI
WHERE MRIC.MPI is null
;--355

Select Count(*)
From dbo.MemberHealthCareAdminCurrent MHCA
--Where 
--1,021,067
--===========================================

Select *
From dbo.MemberRecIdDelete D
Where D.mpi in(
				SELECT Distinct MHCA1.mpi
				FROM dbo.MemberHealthCareAdmin MHCA1
					Left Join dbo.MemberRecIdCon MRIC1
					On MHCA1.MPI = MRIC1.MPI
				WHERE MRIC1.MPI is null
)

Select *
From dbo.MemberRecIdDelete D
Where D.mpi in(
				SELECT Distinct MHCA1.mpi
				FROM dbo.MemberHealthCareAdmin MHCA1
					Left Join dbo.MemberRecIdCon MRIC1
					On MHCA1.MPI = MRIC1.MPI
				WHERE MRIC1.MPI is null
)

--========================================================
--1. Guardar los nulos a eliminar


--Truncate Table [dbo].[MemberHealthCareAdminArchive];

--INSERT INTO [dbo].[MemberHealthCareAdminArchive]([MemberHealthCareAdminRecId],[MemberRecId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[MemberSuffix],[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[CurrEligibility],[Carrier],[CarrierEffectiveDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[AsesRegion],[AsesCoverageCode],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastEligibilityUpdateDate],[AsesMedicaidEligible],[AsesLastQueryResponseProcessDate],[JobLoadDate])
Select [MemberHealthCareAdminRecId],MHCA1.[MemberRecId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[MemberSuffix],MHCA1.[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[CurrEligibility],[Carrier],[CarrierEffectiveDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[AsesRegion],[AsesCoverageCode],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastEligibilityUpdateDate],[AsesMedicaidEligible],[AsesLastQueryResponseProcessDate],[JobLoadDate]
FROM dbo.MemberHealthCareAdmin MHCA1
Where MPI IS NULL

--Truncate Table [dbo].[MemberHealthCareAdminCurrentArchive];

--INSERT INTO [dbo].[MemberHealthCareAdminCurrentArchive]([MemberHealthCareAdminCurrentRecId],[MemberRecId],[CarrierMRefId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[Carrier],[CarrierEffectiveDate],[MemberSuffix],[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[AsesRegion],[AsesCoverageCode],[CurrEligibility],[AsesMedicaidEligible],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastQueryResponseProcessDate],[EligibilityMemberRecId],[AsesLastEligibilityUpdateSource],[AsesLastEligibilityUpdateDate],[QueryResponseDetailRecId],[CreatedON],[LastUpdateON])
Select [MemberHealthCareAdminCurrentRecId],MHCA1.[MemberRecId],[CarrierMRefId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[Carrier],[CarrierEffectiveDate],[MemberSuffix],MHCA1.[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[AsesRegion],[AsesCoverageCode],[CurrEligibility],[AsesMedicaidEligible],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastQueryResponseProcessDate],[EligibilityMemberRecId],[AsesLastEligibilityUpdateSource],[AsesLastEligibilityUpdateDate],[QueryResponseDetailRecId],[CreatedON],[LastUpdateON]
FROM dbo.MemberHealthCareAdminCurrent MHCA1
Where MHCA1.mpi is null

--Truncate Table [dbo].[MemberArchive];

--INSERT INTO [dbo].[MemberArchive]([MemberRecId],[CarrierMRefId],[FirstName],[MiddleInitial],[LastName],[SecLastName],[GenderMRefId],[BirthDate],[DeathDate],[SocialSecurity],[SORId],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[JobLoadDate],[MPI])
Select [MemberRecId],[CarrierMRefId],[FirstName],[MiddleInitial],[LastName],[SecLastName],[GenderMRefId],[BirthDate],[DeathDate],[SocialSecurity],[SORId],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[JobLoadDate],[MPI]
From [dbo].[Member] M
Where M.mpi is null
;


--========================================================
--1. Delete MPI nulos
--Delete From dbo.MemberHealthCareAdmin
WHERE MPI is null;

--Delete From dbo.MemberHealthCareAdminCurrent
WHERE MPI is null;

--Delete From dbo.Member
WHERE MPI is null;



Select COUNT(*)
From dbo.MemberHealthCareAdmin MHCA
WHERE MHCA.MPI is null
;--597,431
--======================

--2. Obtener MPI a eliminar
--Insert Into dbo.MemberRecIdDelete(MPI, memberRecId)
Select MHCA.MPI, MHCA.MemberRecId
From dbo.MemberHealthCareAdmin MHCA
	Left Join dbo.MemberRecIdCon MRIC
	On MHCA.MemberRecId = MRIC.memberRecIdCons
WHERE 1 = 1
	and MRIC.memberRecIdCons is null
;

Select *
From dbo.MemberHealthCareAdminCurrent MHCA


--Insert Into dbo.MemberRecIdDelete(MPI, memberRecId)
Select MHCA.MPI, MHCA.MemberRecId
From dbo.MemberHealthCareAdminCurrent MHCA
	Left Join dbo.MemberRecIdCon MRIC
	On MHCA.MemberRecId = MRIC.memberRecIdCons
WHERE 1 = 1
	and MRIC.memberRecIdCons is null
	and MHCA.MemberRecId Not in(Select Distinct MRD.MemberRecId From dbo.MemberRecIdDelete MRD)
;

--Insert Into dbo.MemberRecIdDelete(MPI, memberRecId)
Select M.MPI, M.MemberRecId
From dbo.Member M
	Left Join dbo.MemberRecIdCon MRIC
	On M.MemberRecId = MRIC.memberRecIdCons
WHERE 1 = 1
	and MRIC.memberRecIdCons is null
	and M.MemberRecId Not in(Select Distinct MRD.MemberRecId From dbo.MemberRecIdDelete MRD)
;


Select Count(Distinct MemberRecId)
From dbo.MemberRecIdDelete

Select Distinct M.MPI, M.MemberRecId
From dbo.Member M
WHERE 1 = 1
	and M.MemberRecId Not in(Select Distinct MRD.MemberRecId From dbo.MemberRecIdDelete MRD)

;

--====================ValidacionTodosIguales===============
Select Distinct M.MPI, M.MemberRecId
From dbo.Member M
	Inner Join dbo.MemberRecIdCon MRIC
	On M.MemberRecId = MRIC.memberRecIdCons
Order By M.MPI--268,601
Select Distinct MHCA.MPI, MHCA.MemberRecId
From dbo.MemberHealthCareAdmin MHCA
	Inner Join dbo.MemberRecIdCon MRIC
	On MHCA.MemberRecId = MRIC.memberRecIdCons
Order By MHCA.MPI--268,482

Select Distinct MHCA.MPI, MHCA.MemberRecId
From dbo.Member M
	Inner Join dbo.MemberHealthCareAdmin MHCA
	On MHCA.MemberRecId = MHCA.MemberRecId
	Inner Join dbo.MemberRecIdCon MRIC
	On MHCA.MemberRecId = MRIC.memberRecIdCons
Order By MHCA.MPI--268,482
;

Select Distinct MHCA.MPI, MHCA.MemberRecId
From dbo.Member M
	Inner Join dbo.MemberHealthCareAdmin MHCA
	On MHCA.MemberRecId = MHCA.MemberRecId
	Inner Join dbo.MemberRecIdCon MRIC
	On MHCA.MemberRecId = MRIC.memberRecIdCons
	Inner Join dbo.MemberRecIdDelete MRD
	On MHCA.MemberRecId = MRD.MemberRecId
Order By MHCA.MPI--0

Select Distinct MHCA.MPI, MHCA.MemberRecId
From dbo.Member M
	Inner Join dbo.MemberHealthCareAdminCurrent MHCA
	On MHCA.MemberRecId = MHCA.MemberRecId
	Inner Join dbo.MemberRecIdCon MRIC
	On MHCA.MemberRecId = MRIC.memberRecIdCons
--Where MHCA.MPI is null
Order By MHCA.MPI--0

--====================ValidacionTodosIguales===============


Select M.MPI, M.MemberRecId
From dbo.Member M
	Left Join dbo.MemberRecIdCon MRIC
	On M.MemberRecId = MRIC.memberRecIdCons
WHERE 1 = 1
	and MRIC.memberRecIdCons is null
Except
Select Distinct MRD.MPI, MRD.MemberRecId 
From dbo.MemberRecIdDelete MRD
;


Select Count(*)
From dbo.MemberRecIdDelete
;

Select Count(*)
From dbo.MemberHealthCareAdmin MHCA
Where MemberRecId In (
						Select MemberRecId
						From (
							Select M.MPI, M.MemberRecId
							From dbo.Member M
								Left Join dbo.MemberRecIdCon MRIC
								On M.MemberRecId = MRIC.memberRecIdCons
							WHERE 1 = 1
								and MRIC.memberRecIdCons is null
							Except
							Select Distinct MRD.MPI, MRD.MemberRecId 
							From dbo.MemberRecIdDelete MRD
							) A
)--= '4F5142F6-4B89-4F9D-865B-6C840602A8BB'

Select *
From dbo.MemberRecIdCon 
WHERE 1 = 1
	and memberRecIdCons = 'CEB55156-F076-4522-976C-E8224EB78115'
;



--===================================================
--3. Remove from delete table members not found in Admin
--Delete From dbo.MemberRecIdDelete
Where mpi in(
				SELECT Distinct MHCA1.mpi
				FROM dbo.MemberHealthCareAdmin MHCA1
					Left Join dbo.MemberRecIdCon MRIC1
					On MHCA1.MPI = MRIC1.MPI
				WHERE MRIC1.MPI is null
				UNION
				SELECT Distinct M2.mpi
				FROM dbo.Member M2
					Left Join dbo.MemberRecIdCon MRIC2
					On M2.MPI = MRIC2.MPI
				WHERE MRIC2.MPI is null
				UNION
				SELECT Distinct MHCA3.mpi
				FROM dbo.MemberHealthCareAdminCurrent MHCA3
					Left Join dbo.MemberRecIdCon MRIC1
					On MHCA3.MPI = MRIC1.MPI
				WHERE MRIC1.MPI is null
			)
;

--===================================================

--===================================================
--4. Guardar los records a eliminar
--   de las respectivas tablas.
--Truncate Table [dbo].[MemberHealthCareAdminArchive];

--INSERT INTO [dbo].[MemberHealthCareAdminArchive]([MemberHealthCareAdminRecId],[MemberRecId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[MemberSuffix],[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[CurrEligibility],[Carrier],[CarrierEffectiveDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[AsesRegion],[AsesCoverageCode],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastEligibilityUpdateDate],[AsesMedicaidEligible],[AsesLastQueryResponseProcessDate],[JobLoadDate])
Select [MemberHealthCareAdminRecId],MRD.[MemberRecId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[MemberSuffix],MRD.[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[CurrEligibility],[Carrier],[CarrierEffectiveDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[AsesRegion],[AsesCoverageCode],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastEligibilityUpdateDate],[AsesMedicaidEligible],[AsesLastQueryResponseProcessDate],[JobLoadDate]
FROM dbo.MemberHealthCareAdmin MHCA1
	Inner Join dbo.MemberRecIdDelete MRD
	On MRD.MemberRecId = MHCA1.MemberRecId

--INSERT INTO [dbo].[MemberHealthCareAdminCurrentArchive]([MemberHealthCareAdminCurrentRecId],[MemberRecId],[CarrierMRefId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[Carrier],[CarrierEffectiveDate],[MemberSuffix],[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[AsesRegion],[AsesCoverageCode],[CurrEligibility],[AsesMedicaidEligible],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastQueryResponseProcessDate],[EligibilityMemberRecId],[AsesLastEligibilityUpdateSource],[AsesLastEligibilityUpdateDate],[QueryResponseDetailRecId],[CreatedON],[LastUpdateON])
Select [MemberHealthCareAdminCurrentRecId],MHCA1.[MemberRecId],[CarrierMRefId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[Carrier],[CarrierEffectiveDate],[MemberSuffix],MHCA1.[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[AsesRegion],[AsesCoverageCode],[CurrEligibility],[AsesMedicaidEligible],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastQueryResponseProcessDate],[EligibilityMemberRecId],[AsesLastEligibilityUpdateSource],[AsesLastEligibilityUpdateDate],[QueryResponseDetailRecId],[CreatedON],[LastUpdateON]
FROM dbo.MemberHealthCareAdminCurrent MHCA1
	Inner Join dbo.MemberRecIdDelete MRD
	On MRD.MemberRecId = MHCA1.MemberRecId


--INSERT INTO [dbo].[MemberArchive]([MemberRecId],[CarrierMRefId],[FirstName],[MiddleInitial],[LastName],[SecLastName],[GenderMRefId],[BirthDate],[DeathDate],[SocialSecurity],[SORId],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[JobLoadDate],[MPI])
Select M.[MemberRecId],[CarrierMRefId],[FirstName],[MiddleInitial],[LastName],[SecLastName],[GenderMRefId],[BirthDate],[DeathDate],[SocialSecurity],[SORId],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[JobLoadDate],M.[MPI]
From [dbo].[Member] M
	Inner Join dbo.MemberRecIdDelete MRD
	On MRD.MemberRecId = M.MemberRecId
;


--===================================================

--5. Delete memberRecId que no sea el recon.
--Delete From dbo.MemberHealthCareAdmin
Where [MemberRecId] In(
							Select MRD.[MemberRecId]
							FROM dbo.MemberHealthCareAdmin MHCA1
								Inner Join dbo.MemberRecIdDelete MRD
								On MRD.MemberRecId = MHCA1.MemberRecId
)
;

--Delete From dbo.MemberHealthCareAdminCurrent
Where [MemberRecId] In(
							Select MRD.[MemberRecId]
							FROM dbo.MemberHealthCareAdminCurrent MHCA1
								Inner Join dbo.MemberRecIdDelete MRD
								On MRD.MemberRecId = MHCA1.MemberRecId
)
;

--Delete From dbo.Member
Where [MemberRecId] In(
							Select MRD.[MemberRecId]
							FROM dbo.Member M
								Inner Join dbo.MemberRecIdDelete MRD
								On MRD.MemberRecId = M.MemberRecId
)
;




Select Count(Distinct MHCA.MemberRecId)
From dbo.MemberHealthCareAdmin MHCA
	Left Join dbo.MemberRecIdCon MRIC
	On MHCA.MemberRecId = MRIC.memberRecIdCons
	Left Join (
				SELECT Distinct MHCA1.mpi
				FROM dbo.MemberHealthCareAdmin MHCA1
					Left Join dbo.MemberRecIdCon MRIC1
					On MHCA1.MPI = MRIC1.MPI
				WHERE MRIC1.MPI is null
			  ) A
	On MHCA.MPI = A.MPI
WHERE 1 = 1
	and MRIC.memberRecIdCons is null
	and A.MPI is null
;--752,388
--Poner los ID's en una tabla temporera o de historia para tenerlo guardados.
--O Tener una tabla de records eliminados.
--================================================


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

SELECT *
FROM dbo.MemberBenefitPackage MBP
WHERE 1 = 1
	and MBP.MemberRecId = '0AA5D5A6-512D-4383-8DF3-CCE7521E9A46'
	--MBP.MPI = '0080017109727'
	--and OrgId = 'H4004'
;

--======================dbo.MemberEnrollmentStatus=====================


