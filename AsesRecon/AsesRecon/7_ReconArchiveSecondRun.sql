USE ASES;

INSERT INTO [dbo].[MemberHealthCareAdminArchive]([MemberHealthCareAdminRecId],[MemberRecId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[MemberSuffix],[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[CurrEligibility],[Carrier],[CarrierEffectiveDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[AsesRegion],[AsesCoverageCode],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastEligibilityUpdateDate],[AsesMedicaidEligible],[AsesLastQueryResponseProcessDate],[JobLoadDate])
Select [MemberHealthCareAdminRecId],MRD.[MemberRecId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[MemberSuffix],MRD.[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[CurrEligibility],[Carrier],[CarrierEffectiveDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[AsesRegion],[AsesCoverageCode],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastEligibilityUpdateDate],[AsesMedicaidEligible],[AsesLastQueryResponseProcessDate],[JobLoadDate]
FROM dbo.MemberHealthCareAdmin MHCA1
	Inner Join dbo.MemberRecIdDelete MRD
	On MRD.MemberRecId = MHCA1.MemberRecId

INSERT INTO [dbo].[MemberHealthCareAdminCurrentArchive]([MemberHealthCareAdminCurrentRecId],[MemberRecId],[CarrierMRefId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[Carrier],[CarrierEffectiveDate],[MemberSuffix],[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[AsesRegion],[AsesCoverageCode],[CurrEligibility],[AsesMedicaidEligible],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastQueryResponseProcessDate],[EligibilityMemberRecId],[AsesLastEligibilityUpdateSource],[AsesLastEligibilityUpdateDate],[QueryResponseDetailRecId],[CreatedON],[LastUpdateON])
Select [MemberHealthCareAdminCurrentRecId],MHCA1.[MemberRecId],[CarrierMRefId],[SignatureDate],[CompletionDate],[EnrollDate],[DisenrollDate],[HasPartA],[HasPartB],[MemberId],[EnrollmentStatusMRefId],[EnrollmentStatusEffDate],[EnrollmentStatusEndDate],[BenefitPackageMRefId],[BenefitPackageEffDate],[BenefitPackageEndDate],[BenefitPackageType],[BenefitPackageTypeEffDate],[BenefitPackageVersion],[BenefitPackageVersionEffDate],[PCPAssign],[PCPEffectiveDate],[PCPEndDate],[CmsEffectiveDate],[CmsExpirationDate],[MA10EffectiveDate],[MA10ExpirationDate],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[Carrier],[CarrierEffectiveDate],[MemberSuffix],MHCA1.[MPI],[HicNumber],[OdsiNumber],[ContractNumber],[AsesRegion],[AsesCoverageCode],[CurrEligibility],[AsesMedicaidEligible],[AsesLastEligibilityProcessDate],[AsesEligibilityEffectiveDate],[AsesEligibilityExpirationDate],[AsesLastQueryResponseProcessDate],[EligibilityMemberRecId],[AsesLastEligibilityUpdateSource],[AsesLastEligibilityUpdateDate],[QueryResponseDetailRecId],[CreatedON],[LastUpdateON]
FROM dbo.MemberHealthCareAdminCurrent MHCA1
	Inner Join dbo.MemberRecIdDelete MRD
	On MRD.MemberRecId = MHCA1.MemberRecId


INSERT INTO [dbo].[MemberArchive]([MemberRecId],[CarrierMRefId],[FirstName],[MiddleInitial],[LastName],[SecLastName],[GenderMRefId],[BirthDate],[DeathDate],[SocialSecurity],[SORId],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[JobLoadDate],[MPI])
Select M.[MemberRecId],[CarrierMRefId],[FirstName],[MiddleInitial],[LastName],[SecLastName],[GenderMRefId],[BirthDate],[DeathDate],[SocialSecurity],[SORId],[CreatedBySrc],[CreatedOnSrc],[LastUpdateBySrc],[LastUpdateOnSrc],[JobLoadDate],M.[MPI]
From [dbo].[Member] M
	Inner Join dbo.MemberRecIdDelete MRD
	On MRD.MemberRecId = M.MemberRecId
;