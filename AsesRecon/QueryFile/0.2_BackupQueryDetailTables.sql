--Truncate Table [dbo].[QueryDetailBkp];
--Truncate Table [dbo].[QueryDetailFailPreProcessBkp]
--Truncate Table [dbo].[QueryUserDefinedQueueBkp]
--Truncate Table [dbo].[QueryResponseDetailBkp]

INSERT INTO [dbo].[QueryDetailBkp]([QueryDetailRecId],[QueryFileLogRecId],[QueryResponseDetailRecId],[QueryResponseDate],[RecordType],[MemberRecId],[Firstname],[Lastname],[SecLastname],[AsesGender],[BirthDate],[MemberSSN],[AsesCarrier],[AsesRegion],[CarrierProcessDate],[CarrierEffectiveDate],[QuerySource],[CreatedBy],[CreatedOn],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote],[MPI],[CarrierFutureEffectiveDate])
Select [QueryDetailRecId],[QueryFileLogRecId],[QueryResponseDetailRecId],[QueryResponseDate],[RecordType],[MemberRecId],[Firstname],[Lastname],[SecLastname],[AsesGender],[BirthDate],[MemberSSN],[AsesCarrier],[AsesRegion],[CarrierProcessDate],[CarrierEffectiveDate],[QuerySource],[CreatedBy],[CreatedOn],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote],[MPI],[CarrierFutureEffectiveDate]
From [dbo].[QueryDetail]
;


INSERT INTO [dbo].[QueryDetailFailPreProcessBkp]([QueryDetailFailPreProcessRecId],[MemberRecId],[Firstname],[Lastname],[SecLastname],[GenderMRefId],[BirthDate],[MemberSSN],[CarrierMRefId],[AsesRegion],[CarrierProcessDate],[CarrierEffectiveDate],[QuerySource],[QueryUserDefinedQueueRecId],[PreProcessStatusCode],[PreProcessStatusCodeOn],[QueryErrorCodes],[CreatedBy],[CreatedOn],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote],[MPI],[CarrierFutureEffectiveDate])
Select [QueryDetailFailPreProcessRecId],[MemberRecId],[Firstname],[Lastname],[SecLastname],[GenderMRefId],[BirthDate],[MemberSSN],[CarrierMRefId],[AsesRegion],[CarrierProcessDate],[CarrierEffectiveDate],[QuerySource],[QueryUserDefinedQueueRecId],[PreProcessStatusCode],[PreProcessStatusCodeOn],[QueryErrorCodes],[CreatedBy],[CreatedOn],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote],[MPI],[CarrierFutureEffectiveDate]
From [dbo].[QueryDetailFailPreProcess]
;

INSERT INTO [dbo].[QueryResponseDetailBkp]([QueryResponseDetailRecId],[QueryResponseFileLogRecId],[RecordType],[MemberSSN],[CarrierProcessDate],[CarrierEffectiveDate],[CarrierFirstName],[CarrierLastName],[CarrierSecLastName],[CarrierGender],[CarrierBirthDate],[CarrierRegionCode],[AsesCarrier],[AsesProcessDate],[AsesElegibilityEffectiveDate],[AsesElegibilityExpirationDate],[AsesFirstName],[AsesLastName],[AsesSecLastName],[AsesGender],[AsesBirthDate],[AsesMunicipalCode],[AsesRegionCode],[AsesDeductibleLevel],[AsesCoverageCode],[AsesElegibilityIndicator],[MedicaidIndicator],[MemberSuffix],[ODSIFamilyID],[MPI],[MessageCode],[CreatedBy],[CreatedOn],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote],[FamilyIDBk],[SuffixBk],[MemberRecId])
Select [QueryResponseDetailRecId],[QueryResponseFileLogRecId],[RecordType],[MemberSSN],[CarrierProcessDate],[CarrierEffectiveDate],[CarrierFirstName],[CarrierLastName],[CarrierSecLastName],[CarrierGender],[CarrierBirthDate],[CarrierRegionCode],[AsesCarrier],[AsesProcessDate],[AsesElegibilityEffectiveDate],[AsesElegibilityExpirationDate],[AsesFirstName],[AsesLastName],[AsesSecLastName],[AsesGender],[AsesBirthDate],[AsesMunicipalCode],[AsesRegionCode],[AsesDeductibleLevel],[AsesCoverageCode],[AsesElegibilityIndicator],[MedicaidIndicator],[MemberSuffix],[ODSIFamilyID],[MPI],[MessageCode],[CreatedBy],[CreatedOn],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote],[FamilyIDBk],[SuffixBk],[MemberRecId]
From [dbo].[QueryResponseDetail]

INSERT INTO [dbo].[QueryUserDefinedQueueBkp]([QueryUserDefinedQueueRecId],[MemberRecId],[Firstname],[Lastname],[SecLastname],[GenderMRefId],[BirthDate],[MemberSSN],[SORId],[CarrierMRefId],[AsesRegion],[CarrierEffectiveDate],[QuerySource],[PriorityRecId],[CreatedBy],[CreatedOn],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote],[MPI],[CarrierFutureEffectiveDate])
Select [QueryUserDefinedQueueRecId],[MemberRecId],[Firstname],[Lastname],[SecLastname],[GenderMRefId],[BirthDate],[MemberSSN],[SORId],[CarrierMRefId],[AsesRegion],[CarrierEffectiveDate],[QuerySource],[PriorityRecId],[CreatedBy],[CreatedOn],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote],[MPI],[CarrierFutureEffectiveDate]
From [dbo].[QueryUserDefinedQueue]
;

INSERT INTO [dbo].[EnrollmentDetailFailPreProcessBkp]([EnrollmentDetailFailPreProcessRecId],[MemberRecId],[QueryResponseDetailRecId],[TranID],[ContractNumber],[MemberSSN],[HICNumber],[MPI],[ODSIFamilyID],[MemberSuffix],[PCP1],[PCP1EffectiveDate],[EnrollmentStatusMRefId],[CmsEffectiveDate],[CmsExpirationDate],[CarrierProcessDate],[CarrierEffectiveDate],[AsesCarrier],[AsesRegion],[BenefitPackageMRefId],[AsesBenefitPackageType],[AsesBenefitPackageVersion],[AsesCoverageCode],[AsesElegibilityEffectiveDate],[AsesElegibilityExpirationDate],[PreProcessStep],[ErrorCode1],[ErrorCode2],[ErrorCode3],[ErrorCode4],[ErrorCode5],[ErrorCode6],[ErrorCode7],[ErrorCode8],[ErrorCode9],[ErrorCode10],[CreatedBy],[CreatedOn],[EnrollmentRejectDetailRecId],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote])
Select [EnrollmentDetailFailPreProcessRecId],[MemberRecId],[QueryResponseDetailRecId],[TranID],[ContractNumber],[MemberSSN],[HICNumber],[MPI],[ODSIFamilyID],[MemberSuffix],[PCP1],[PCP1EffectiveDate],[EnrollmentStatusMRefId],[CmsEffectiveDate],[CmsExpirationDate],[CarrierProcessDate],[CarrierEffectiveDate]
           ,[AsesCarrier],[AsesRegion],[BenefitPackageMRefId],[AsesBenefitPackageType],[AsesBenefitPackageVersion],[AsesCoverageCode],[AsesElegibilityEffectiveDate]
           ,[AsesElegibilityExpirationDate],[PreProcessStep],[ErrorCode1],[ErrorCode2],[ErrorCode3],[ErrorCode4],[ErrorCode5],[ErrorCode6],[ErrorCode7],[ErrorCode8]
           ,[ErrorCode9],[ErrorCode10],[CreatedBy],[CreatedOn],[EnrollmentRejectDetailRecId],[QueueStatusMRefId]
           ,[QueueStatusDate],[QueueStatusBy],[QueueStatusNote]
From [dbo].[EnrollmentDetailFailPreProcess]
;

INSERT INTO [dbo].[EnrollmentDetailBkp]([EnrollmentDetailRecId],[EnrollmentFileLogRecId],[MemberRecId],[QueryResponseDetailRecId],[EnrollmentRejectRecId],[TranID],[RecordType],[ContractNumber],[MemberSSN],[HICNumber],[MPI],[ODSIFamilyID],[MemberSuffix],[PCP1],[PCP1EffectiveDate],[MedicareIndicator],[EnrollmentStatusMRefId],[CmsEffectiveDate],[CmsExpirationDate],[CarrierProcessDate],[CarrierEffectiveDate],[AsesCarrier],[AsesRegion],[BenefitPackageMRefId],[BenefitPackageType],[BenefitPackageVersion],[AsesCoverageCode],[AsesEligibilityEffectiveDate],[AsesExpirationExpirationDate],[CreatedBy],[CreatedOn],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote],[QueryResponseDate],[EnrollmentRejectDate],[EnrollmentRejectFlagOn],[EligibilityMemberRecId],[EligibilityMemberDate],[EligibilityMemberFlagOn],[FamilyIDBk],[SuffixBk])
Select [EnrollmentDetailRecId],[EnrollmentFileLogRecId],[MemberRecId],[QueryResponseDetailRecId],[EnrollmentRejectRecId],[TranID],[RecordType],[ContractNumber],[MemberSSN],[HICNumber],[MPI],[ODSIFamilyID],[MemberSuffix],[PCP1],[PCP1EffectiveDate],[MedicareIndicator],[EnrollmentStatusMRefId],[CmsEffectiveDate],[CmsExpirationDate],[CarrierProcessDate],[CarrierEffectiveDate],[AsesCarrier],[AsesRegion],[BenefitPackageMRefId],[BenefitPackageType],[BenefitPackageVersion],[AsesCoverageCode],[AsesEligibilityEffectiveDate],[AsesExpirationExpirationDate],[CreatedBy],[CreatedOn],[QueueStatusMRefId],[QueueStatusDate],[QueueStatusBy],[QueueStatusNote],[QueryResponseDate],[EnrollmentRejectDate],[EnrollmentRejectFlagOn],[EligibilityMemberRecId],[EligibilityMemberDate],[EligibilityMemberFlagOn],[FamilyIDBk],[SuffixBk]
From [dbo].[EnrollmentDetail]
;



USE [ASES]
GO

INSERT INTO [dbo].[MemberPCPBkp]
           ([MemberPCPRecId]
           ,[MemberRecId]
           ,[ProviderId]
           ,[EffectiveDate]
           ,[TerminationDate]
           ,[SORId]
           ,[CreatedBySrc]
           ,[CreatedOnSrc]
           ,[LastUpdateBySrc]
           ,[LastUpdateOnSrc]
           ,[JobLoadDate])

Select [MemberPCPRecId]
           ,[MemberRecId]
           ,[ProviderId]
           ,[EffectiveDate]
           ,[TerminationDate]
           ,[SORId]
           ,[CreatedBySrc]
           ,[CreatedOnSrc]
           ,[LastUpdateBySrc]
           ,[LastUpdateOnSrc]
           ,[JobLoadDate]
From [dbo].[MemberPCP]
;

INSERT INTO [dbo].[MemberEnrollmentStatusBkp]
           ([STATUS_ID]
           ,[NAME_ID]
           ,[MPI]
           ,[ORG_ID]
           ,[STATUS]
           ,[START_DATE]
           ,[END_DATE]
           ,[CREATEDBY]
           ,[CREATEDON]
           ,[LASTUPDATEBY]
           ,[LASTUPDATEON])
Select [STATUS_ID]
       ,[NAME_ID]
       ,[MPI]
       ,[ORG_ID]
       ,[STATUS]
       ,[START_DATE]
       ,[END_DATE]
       ,[CREATEDBY]
       ,[CREATEDON]
       ,[LASTUPDATEBY]
       ,[LASTUPDATEON]
From [dbo].[MemberEnrollmentStatus]
;


INSERT INTO [dbo].[MemberBenefitPackageBkp]
           ([MemberBenefitPackageRecId]
           ,[MemberRecId]
           ,[BenefitPackageMRefId]
           ,[EffectiveDate]
           ,[TerminationDate]
           ,[SORId]
           ,[CreatedBySrc]
           ,[CreatedOnSrc]
           ,[LastUpdateBySrc]
           ,[LastUpdateOnSrc]
           ,[JobLoadDate]
           ,[MPI]
           ,[PackageId]
           ,[OrgId]
           ,[Pbp])
Select [MemberBenefitPackageRecId]
        ,[MemberRecId]
        ,[BenefitPackageMRefId]
        ,[EffectiveDate]
        ,[TerminationDate]
        ,[SORId]
        ,[CreatedBySrc]
        ,[CreatedOnSrc]
        ,[LastUpdateBySrc]
        ,[LastUpdateOnSrc]
        ,[JobLoadDate]
        ,[MPI]
        ,[PackageId]
        ,[OrgId]
        ,[Pbp]
From [dbo].[MemberBenefitPackage]
;



