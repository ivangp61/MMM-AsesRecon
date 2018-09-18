USE [ASES]


--Drop Table [dbo].[QueryDetailBkp];

CREATE TABLE [dbo].[QueryDetailBkp](
	[QueryDetailRecId] [uniqueidentifier] NOT NULL,
	[QueryFileLogRecId] [uniqueidentifier] NULL,
	[QueryResponseDetailRecId] [uniqueidentifier] NULL,
	[QueryResponseDate] [datetime] NULL,
	[RecordType] [nchar](1) NULL,
	[MemberRecId] [uniqueidentifier] NULL,
	[Firstname] [nvarchar](20) NULL,
	[Lastname] [nvarchar](15) NULL,
	[SecLastname] [nvarchar](15) NULL,
	[AsesGender] [int] NULL,
	[BirthDate] [datetime] NULL,
	[MemberSSN] [nvarchar](9) NULL,
	[AsesCarrier] [nchar](2) NULL,
	[AsesRegion] [nchar](1) NULL,
	[CarrierProcessDate] [datetime] NOT NULL,
	[CarrierEffectiveDate] [datetime] NULL,
	[QuerySource] [nchar](3) NULL,
	[CreatedBy] [nvarchar](100) NULL ,
	[CreatedOn] [datetime] NULL,
	[QueueStatusMRefId] [int] NULL,
	[QueueStatusDate] [smalldatetime] NULL,
	[QueueStatusBy] [nvarchar](60) NULL,
	[QueueStatusNote] [nvarchar](200) NULL,
	[MPI] [nvarchar](13) NULL,
	[CarrierFutureEffectiveDate] [datetime] NULL
) ON [PRIMARY]

GO

--Drop Table [dbo].[QueryResponseDetailBkp];

CREATE TABLE [dbo].[QueryResponseDetailBkp](
	[QueryResponseDetailRecId] [uniqueidentifier] NOT NULL,
	[QueryResponseFileLogRecId] [uniqueidentifier] NULL,
	[RecordType] [nvarchar](1) NOT NULL,
	[MemberSSN] [nvarchar](9) NULL,
	[CarrierProcessDate] [datetime] NOT NULL,
	[CarrierEffectiveDate] [datetime] NULL,
	[CarrierFirstName] [nvarchar](50) NULL,
	[CarrierLastName] [nvarchar](50) NULL,
	[CarrierSecLastName] [nvarchar](50) NULL,
	[CarrierGender] [nvarchar](1) NULL,
	[CarrierBirthDate] [datetime] NULL,
	[CarrierRegionCode] [nvarchar](1) NULL,
	[AsesCarrier] [int] NULL,
	[AsesProcessDate] [datetime] NULL,
	[AsesElegibilityEffectiveDate] [datetime] NULL,
	[AsesElegibilityExpirationDate] [datetime] NULL,
	[AsesFirstName] [nvarchar](50) NULL,
	[AsesLastName] [nvarchar](50) NULL,
	[AsesSecLastName] [nvarchar](50) NULL,
	[AsesGender] [nvarchar](1) NULL,
	[AsesBirthDate] [datetime] NULL,
	[AsesMunicipalCode] [nvarchar](4) NULL,
	[AsesRegionCode] [nvarchar](1) NULL,
	[AsesDeductibleLevel] [nvarchar](1) NULL,
	[AsesCoverageCode] [nvarchar](3) NULL,
	[AsesElegibilityIndicator] [nvarchar](1) NULL,
	[MedicaidIndicator] [nvarchar](1) NULL,
	[MemberSuffix] [nvarchar](2) NULL,
	[ODSIFamilyID] [nvarchar](11) NULL,
	[MPI] [nvarchar](13) NULL,
	[MessageCode] [nvarchar](6) NULL,
	[CreatedBy] [nvarchar](60) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[QueueStatusMRefId] [int] NULL,
	[QueueStatusDate] [smalldatetime] NULL,
	[QueueStatusBy] [nvarchar](60) NULL,
	[QueueStatusNote] [nvarchar](200) NULL,
	[FamilyIDBk] [nvarchar](11) NULL,
	[SuffixBk] [nvarchar](2) NULL,
	[MemberRecId] [uniqueidentifier] NULL
) ON [PRIMARY]

--Drop Table [dbo].[QueryDetailFailPreProcessBkp];

CREATE TABLE [dbo].[QueryDetailFailPreProcessBkp](
	[QueryDetailFailPreProcessRecId] [uniqueidentifier] NOT NULL,
	[MemberRecId] [uniqueidentifier] NULL,
	[Firstname] [nvarchar](20) NULL,
	[Lastname] [nvarchar](15) NULL,
	[SecLastname] [nvarchar](15) NULL,
	[GenderMRefId] [int] NULL,
	[BirthDate] [datetime] NULL,
	[MemberSSN] [nvarchar](9) NULL,
	[CarrierMRefId] [int] NULL,
	[AsesRegion] [nchar](1) NULL,
	[CarrierProcessDate] [datetime] NULL,
	[CarrierEffectiveDate] [datetime] NULL,
	[QuerySource] [nchar](3) NULL,
	[QueryUserDefinedQueueRecId] [uniqueidentifier] NULL,
	[PreProcessStatusCode] [nchar](1) NULL,
	[PreProcessStatusCodeOn] [datetime] NULL,
	[QueryErrorCodes] [nvarchar](10) NULL,
	[CreatedBy] [nvarchar](100) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[QueueStatusMRefId] [int] NULL,
	[QueueStatusDate] [smalldatetime] NULL,
	[QueueStatusBy] [nvarchar](60) NULL,
	[QueueStatusNote] [nvarchar](200) NULL,
	[MPI] [nvarchar](13) NULL,
	[CarrierFutureEffectiveDate] [datetime] NULL
) ON [PRIMARY]

GO


--Drop Table [dbo].[QueryUserDefinedQueueBkp];

CREATE TABLE [dbo].[QueryUserDefinedQueueBkp](
	[QueryUserDefinedQueueRecId] [uniqueidentifier] NOT NULL,
	[MemberRecId] [uniqueidentifier] NULL,
	[Firstname] [nvarchar](20) NULL,
	[Lastname] [nvarchar](15) NULL,
	[SecLastname] [nvarchar](15) NULL,
	[GenderMRefId] [int] NULL,
	[BirthDate] [datetime] NULL,
	[MemberSSN] [nvarchar](9) NULL,
	[SORId] [nvarchar](20) NULL,
	[CarrierMRefId] [int] NULL,
	[AsesRegion] [nchar](1) NULL,
	[CarrierEffectiveDate] [datetime] NULL,
	[QuerySource] [nchar](3) NULL,
	[PriorityRecId] [int] NOT NULL,
	[CreatedBy] [nvarchar](60) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[QueueStatusMRefId] [int] NULL,
	[QueueStatusDate] [smalldatetime] NULL,
	[QueueStatusBy] [nvarchar](60) NULL,
	[QueueStatusNote] [nvarchar](200) NULL,
	[MPI] [nvarchar](13) NULL,
	[CarrierFutureEffectiveDate] [datetime] NULL
) ON [PRIMARY]

GO

--Drop Table [dbo].[EnrollmentDetailFailPreProcessBkp]

CREATE TABLE [dbo].[EnrollmentDetailFailPreProcessBkp](
	[EnrollmentDetailFailPreProcessRecId] [uniqueidentifier],
	[MemberRecId] [uniqueidentifier] NULL,
	[QueryResponseDetailRecId] [uniqueidentifier] NULL,
	[TranID] [nchar](1) NULL,
	[ContractNumber] [nvarchar](13) NULL,
	[MemberSSN] [nchar](9) NULL,
	[HICNumber] [nchar](12) NULL,
	[MPI] [nchar](13) NULL,
	[ODSIFamilyID] [nchar](11) NULL,
	[MemberSuffix] [nchar](2) NULL,
	[PCP1] [nvarchar](15) NULL,
	[PCP1EffectiveDate] [datetime] NULL,
	[EnrollmentStatusMRefId] [int] NULL,
	[CmsEffectiveDate] [datetime] NULL,
	[CmsExpirationDate] [datetime] NULL,
	[CarrierProcessDate] [datetime] NULL,
	[CarrierEffectiveDate] [datetime] NULL,
	[AsesCarrier] [nchar](2) NULL,
	[AsesRegion] [nchar](1) NULL,
	[BenefitPackageMRefId] [int] NULL,
	[AsesBenefitPackageType] [nchar](2) NULL,
	[AsesBenefitPackageVersion] [nchar](3) NULL,
	[AsesCoverageCode] [nchar](3) NULL,
	[AsesElegibilityEffectiveDate] [datetime] NULL,
	[AsesElegibilityExpirationDate] [datetime] NULL,
	[PreProcessStep] [nchar](1) NULL,
	[ErrorCode1] [nvarchar](3) NULL,
	[ErrorCode2] [nvarchar](3) NULL,
	[ErrorCode3] [nvarchar](3) NULL,
	[ErrorCode4] [nvarchar](3) NULL,
	[ErrorCode5] [nvarchar](3) NULL,
	[ErrorCode6] [nvarchar](3) NULL,
	[ErrorCode7] [nvarchar](3) NULL,
	[ErrorCode8] [nvarchar](3) NULL,
	[ErrorCode9] [nvarchar](3) NULL,
	[ErrorCode10] [nvarchar](3) NULL,
	[CreatedBy] [nvarchar](60) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[EnrollmentRejectDetailRecId] [uniqueidentifier] NULL,
	[QueueStatusMRefId] [int] NULL,
	[QueueStatusDate] [smalldatetime] NULL,
	[QueueStatusBy] [nvarchar](60) NULL,
	[QueueStatusNote] [nvarchar](200) NULL
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[EnrollmentDetailBkp](
	[EnrollmentDetailRecId] [uniqueidentifier] NOT NULL,
	[EnrollmentFileLogRecId] [uniqueidentifier] NULL,
	[MemberRecId] [uniqueidentifier] NULL,
	[QueryResponseDetailRecId] [uniqueidentifier] NULL,
	[EnrollmentRejectRecId] [uniqueidentifier] NULL,
	[TranID] [nchar](1) NULL,
	[RecordType] [nchar](1) NULL,
	[ContractNumber] [nvarchar](13) NULL,
	[MemberSSN] [nchar](9) NULL,
	[HICNumber] [nchar](12) NULL,
	[MPI] [nchar](13) NULL,
	[ODSIFamilyID] [nchar](11) NULL,
	[MemberSuffix] [nchar](2) NULL,
	[PCP1] [nvarchar](15) NULL,
	[PCP1EffectiveDate] [datetime] NULL,
	[MedicareIndicator] [nchar](1) NULL,
	[EnrollmentStatusMRefId] [int] NULL,
	[CmsEffectiveDate] [datetime] NULL,
	[CmsExpirationDate] [datetime] NULL,
	[CarrierProcessDate] [datetime] NOT NULL,
	[CarrierEffectiveDate] [datetime] NULL,
	[AsesCarrier] [nchar](2) NULL,
	[AsesRegion] [nchar](1) NULL,
	[BenefitPackageMRefId] [int] NULL,
	[BenefitPackageType] [nchar](2) NULL,
	[BenefitPackageVersion] [nchar](3) NULL,
	[AsesCoverageCode] [nchar](3) NULL,
	[AsesEligibilityEffectiveDate] [datetime] NULL,
	[AsesExpirationExpirationDate] [datetime] NULL,
	[CreatedBy] [nvarchar](60) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[QueueStatusMRefId] [int] NULL DEFAULT ((1)),
	[QueueStatusDate] [smalldatetime] NULL,
	[QueueStatusBy] [nvarchar](60) NULL,
	[QueueStatusNote] [nvarchar](200) NULL,
	[QueryResponseDate] [datetime] NULL,
	[EnrollmentRejectDate] [datetime] NULL,
	[EnrollmentRejectFlagOn] [datetime] NULL,
	[EligibilityMemberRecId] [uniqueidentifier] NULL,
	[EligibilityMemberDate] [datetime] NULL,
	[EligibilityMemberFlagOn] [datetime] NULL,
	[FamilyIDBk] [nvarchar](11) NULL,
	[SuffixBk] [nvarchar](2) NULL
) ON [PRIMARY]

GO