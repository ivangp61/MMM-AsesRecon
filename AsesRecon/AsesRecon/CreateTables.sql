USE [ASES]
GO


CREATE TABLE dbo.MemberExtrEnrollmentStatus(
	[STATUS_ID] [nchar](12) NULL,	
	[NAME_ID] [nvarchar](20) NULL,
	[MPI] [nvarchar](13) NULL,
	[ORG_ID] [nchar](5) NULL,
	[STATUS] [nvarchar](3) NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[CREATEDBY] [nvarchar](60) NULL,
	[CREATEDON] [datetime] NULL,
	[LASTUPDATEBY] [nvarchar](60) NULL,
	[LASTUPDATEON] [datetime] NULL	
) ON [PRIMARY]

--Drop Table dbo.MemberExtrEnrollmentStatusError;
CREATE TABLE dbo.MemberExtrEnrollmentStatusError(
	[STATUS_ID] [nchar](12) NULL,	
	[NAME_ID] [nvarchar](20) NULL,
	[MPI] [nvarchar](13) NULL,
	[ORG_ID] [nchar](5) NULL,
	[STATUS] [nvarchar](3) NULL,
	[START_DATE] [datetime] NULL,
	[END_DATE] [datetime] NULL,
	[CREATEDBY] [nvarchar](60) NULL,
	[CREATEDON] [datetime] NULL,
	[LASTUPDATEBY] [nvarchar](60) NULL,
	[LASTUPDATEON] [datetime] NULL,
	errorDescription varchar(200)
) ON [PRIMARY]



CREATE TABLE [dbo].[MemberExtrPCP](
	[NAME_ID] [nvarchar](20) NULL,
	[PROVIDER_ID] [nchar](12) NULL,
	[ORG_ID] [nchar](5) NULL,
	[EFF_DATE] [datetime] NULL,
	[TERM_DATE] [datetime] NULL,
	[CREATEDBY] [nvarchar](60) NULL,
	[CREATEDON] [datetime] NULL,
	[MPI] [nvarchar](13) NULL
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[MemberExtrPCPError](
	[NAME_ID] [nvarchar](20) NULL,
	[PROVIDER_ID] [nchar](12) NULL,
	[ORG_ID] [nchar](5) NULL,
	[EFF_DATE] [datetime] NULL,
	[TERM_DATE] [datetime] NULL,
	[CREATEDBY] [nvarchar](60) NULL,
	[CREATEDON] [datetime] NULL,
	[MPI] [nvarchar](13) NULL,
	errorDescription VARCHAR(500)
) ON [PRIMARY]

GO


BEGIN--=============================CONSOLIDATION================================
--=============================CONSOLIDATION_LAST_MEMBER_PACKAGE================================
--Drop Table [dbo].[MemberBenefitPackageMpSource];
CREATE TABLE [dbo].[MemberBenefitPackageMpSource](
	[MemberBenefitPackageRecId] [uniqueidentifier] null,
	[MemberRecId] [uniqueidentifier] NULL,
	[BenefitPackageMRefId] [int] NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminationDate] [datetime] NULL,
	[SORId] [nchar](12) NULL,
	[CreatedBySrc] [nvarchar](60) NULL,
	[CreatedOnSrc] [datetime] NULL,
	[LastUpdateBySrc] [nvarchar](60) NULL,
	[LastUpdateOnSrc] [datetime] NULL,
	[JobLoadDate] [datetime] NULL,
	[MPI] [nvarchar](13) NULL,
	[PackageId] [nvarchar](12) NULL,
	[OrgId] [nvarchar](5) NULL,
	[Pbp] [nvarchar](20) NULL
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX IX_MemberBenefitPackageMpSource_mpi
    ON [dbo].[MemberBenefitPackageMpSource] (MPI); 

CREATE NONCLUSTERED INDEX IX_MemberBenefitPackageMpSource_lastUpdate
    ON [dbo].[MemberBenefitPackageMpSource] (LastUpdateOnSrc); 


--Drop Table [dbo].[MemberBenefitPackageMax];
CREATE TABLE [dbo].[MemberBenefitPackageMax](
	[MPI] [nvarchar](13) NULL,
	[LastUpdateOnSrc] [datetime] NULL
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX IX_MemberBenefitPackageMax_mpi
    ON [dbo].[MemberBenefitPackageMax] (MPI); 

CREATE NONCLUSTERED INDEX IX_MemberBenefitPackageMax_lastUpdate
    ON [dbo].[MemberBenefitPackageMax] (LastUpdateOnSrc); 


--Drop Table [dbo].[MemberBenefitPackageMpSourceError];
CREATE TABLE [dbo].[MemberBenefitPackageMpSourceError](
	[MemberBenefitPackageRecId] [uniqueidentifier] null,
	[MemberRecId] [uniqueidentifier] NULL,
	[BenefitPackageMRefId] [int] NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminationDate] [datetime] NULL,
	[SORId] [nchar](12) NULL,
	[CreatedBySrc] [nvarchar](60) NULL,
	[CreatedOnSrc] [datetime] NULL,
	[LastUpdateBySrc] [nvarchar](60) NULL,
	[LastUpdateOnSrc] [datetime] NULL,
	[JobLoadDate] [datetime] NULL,
	[MPI] [nvarchar](13) NULL,
	[PackageId] [nvarchar](12) NULL,
	[OrgId] [nvarchar](5) NULL,
	[Pbp] [nvarchar](20) NULL,
	errorCode varchar(30),
	errorDesc varchar(200)
) ON [PRIMARY]


--==================================================================
--dbo.MemberRecIdCon: Contiene los la ultima vigencia por la cual se va 
--					  a consolidar los afiliados.
--Drop Table [dbo].[MemberBenefitPackageConsolidation];
CREATE TABLE [dbo].[MemberBenefitPackageConsolidation](
	[MemberBenefitPackageRecId] [uniqueidentifier],
	[MemberRecId] [uniqueidentifier] NULL,
	[BenefitPackageMRefId] [int] NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminationDate] [datetime] NULL,
	[SORId] [nchar](12) NULL,
	[CreatedBySrc] [nvarchar](60) NULL,
	[CreatedOnSrc] [datetime] NULL,
	[LastUpdateBySrc] [nvarchar](60) NULL,
	[LastUpdateOnSrc] [datetime] NULL,
	[JobLoadDate] [datetime] NULL,
	[MPI] [nvarchar](13) NULL,
	[PackageId] [nvarchar](12) NULL,
	[OrgId] [nvarchar](5) NULL,
	[Pbp] [nvarchar](20) NULL
) ON [PRIMARY]

GO

--==================================================================
--dbo.MemberRecIdCon: Contiene los id's de los records que se van a
--					  a consolidar los afiliados.
--Drop Table dbo.MemberRecIdCon;
CREATE TABLE dbo.MemberRecIdCon
(
	MPI varchar(13) NULL,
	NAME_ID varchar(20) NULL,
	memberRecIdCons uniqueidentifier NULL,
	memberRecId uniqueidentifier NULL,
	carrierMrefId int NULL
)

GO
--==================================================================

--==================================================================
--dbo.MemberRecIdDelete: Contiene los id's de los records que se van a
--					     a consolidar los afiliados.
--Drop Table dbo.MemberRecIdDelete;
CREATE TABLE dbo.MemberRecIdDelete
(
	MPI varchar(13) NULL,
	memberRecId uniqueidentifier NULL
)

GO
--==================================================================



--=====================================================================================
--dbo.MemberHealthCareAdminArchive: Contiene los records eliminados 
--									de la tabla dbo.MemberHealthCareAdmin
--									como parte del proceso de reconciliacion.
CREATE TABLE [dbo].[MemberHealthCareAdminArchive](
	[MemberHealthCareAdminRecId] [uniqueidentifier] NULL,
	[MemberRecId] [uniqueidentifier] NULL,
	[SignatureDate] [datetime] NULL,
	[CompletionDate] [datetime] NULL,
	[EnrollDate] [datetime] NULL,
	[DisenrollDate] [datetime] NULL,
	[HasPartA] [nchar](1) NULL,
	[HasPartB] [nchar](1) NULL,
	[MemberId] [nvarchar](20) NULL,
	[EnrollmentStatusMRefId] [int] NULL,
	[EnrollmentStatusEffDate] [datetime] NULL,
	[EnrollmentStatusEndDate] [datetime] NULL,
	[BenefitPackageMRefId] [int] NULL,
	[BenefitPackageEffDate] [datetime] NULL,
	[BenefitPackageEndDate] [datetime] NULL,
	[PCPAssign] [nvarchar](15) NULL,
	[PCPEffectiveDate] [datetime] NULL,
	[PCPEndDate] [datetime] NULL,
	[CmsEffectiveDate] [datetime] NULL,
	[CmsExpirationDate] [datetime] NULL,
	[MA10EffectiveDate] [datetime] NULL,
	[MA10ExpirationDate] [datetime] NULL,
	[CreatedBySrc] [nvarchar](60) NULL,
	[CreatedOnSrc] [datetime] NULL,
	[LastUpdateBySrc] [nvarchar](60) NULL,
	[LastUpdateOnSrc] [datetime] NULL,
	[MemberSuffix] [nchar](2) NULL,
	[MPI] [nvarchar](13) NULL,
	[HicNumber] [nvarchar](12) NULL,
	[OdsiNumber] [nvarchar](11) NULL,
	[ContractNumber] [nvarchar](13) NULL,
	[CurrEligibility] [nchar](1) NULL,
	[Carrier] [nchar](2) NULL,
	[CarrierEffectiveDate] [datetime] NULL,
	[BenefitPackageType] [nchar](2) NULL,
	[BenefitPackageTypeEffDate] [datetime] NULL,
	[BenefitPackageVersion] [nchar](3) NULL,
	[BenefitPackageVersionEffDate] [datetime] NULL,
	[AsesRegion] [nchar](1) NULL,
	[AsesCoverageCode] [nchar](3) NULL,
	[AsesLastEligibilityProcessDate] [datetime] NULL,
	[AsesEligibilityEffectiveDate] [datetime] NULL,
	[AsesEligibilityExpirationDate] [datetime] NULL,
	[AsesLastEligibilityUpdateDate] [datetime] NULL,
	[AsesMedicaidEligible] [nchar](1) NULL,
	[AsesLastQueryResponseProcessDate] [datetime] NULL,
	[JobLoadDate] [datetime] NULL
) ON [PRIMARY]

GO
--=====================================================================================

--=====================================================================================
--dbo.MemberHealthCareAdminCurrentArchive: Contiene los records eliminados 
--										   de la tabla dbo.MemberHealthCareAdminCurrent
--										   como parte del proceso de reconciliacion.
--Drop Table [dbo].[MemberHealthCareAdminCurrentArchive];
CREATE TABLE [dbo].[MemberHealthCareAdminCurrentArchive](
	[MemberHealthCareAdminCurrentRecId] [uniqueidentifier] NULL,
	[MemberRecId] [uniqueidentifier] NULL,
	[CarrierMRefId] [int] NULL,
	[SignatureDate] [datetime] NULL,
	[CompletionDate] [datetime] NULL,
	[EnrollDate] [datetime] NULL,
	[DisenrollDate] [datetime] NULL,
	[HasPartA] [nchar](1) NULL,
	[HasPartB] [nchar](1) NULL,
	[MemberId] [nvarchar](20) NULL,
	[EnrollmentStatusMRefId] [int] NULL,
	[EnrollmentStatusEffDate] [datetime] NULL,
	[EnrollmentStatusEndDate] [datetime] NULL,
	[BenefitPackageMRefId] [int] NULL,
	[BenefitPackageEffDate] [datetime] NULL,
	[BenefitPackageEndDate] [datetime] NULL,
	[BenefitPackageType] [nchar](2) NULL,
	[BenefitPackageTypeEffDate] [datetime] NULL,
	[BenefitPackageVersion] [nchar](3) NULL,
	[BenefitPackageVersionEffDate] [datetime] NULL,
	[PCPAssign] [nvarchar](15) NULL,
	[PCPEffectiveDate] [datetime] NULL,
	[PCPEndDate] [datetime] NULL,
	[CmsEffectiveDate] [datetime] NULL,
	[CmsExpirationDate] [datetime] NULL,
	[MA10EffectiveDate] [datetime] NULL,
	[MA10ExpirationDate] [datetime] NULL,
	[CreatedBySrc] [nvarchar](60) NULL,
	[CreatedOnSrc] [datetime] NULL,
	[LastUpdateBySrc] [nvarchar](60) NULL,
	[LastUpdateOnSrc] [datetime] NULL,
	[Carrier] [nchar](2) NULL,
	[CarrierEffectiveDate] [datetime] NULL,
	[MemberSuffix] [nchar](2) NULL,
	[MPI] [nvarchar](13) NULL,
	[HicNumber] [nvarchar](12) NULL,
	[OdsiNumber] [nvarchar](11) NULL,
	[ContractNumber] [nvarchar](13) NULL,
	[AsesRegion] [nchar](1) NULL,
	[AsesCoverageCode] [nchar](3) NULL,
	[CurrEligibility] [nchar](1) NULL,
	[AsesMedicaidEligible] [nchar](1) NULL,
	[AsesLastEligibilityProcessDate] [datetime] NULL,
	[AsesEligibilityEffectiveDate] [datetime] NULL,
	[AsesEligibilityExpirationDate] [datetime] NULL,
	[AsesLastQueryResponseProcessDate] [datetime] NULL,
	[EligibilityMemberRecId] [uniqueidentifier] NULL,
	[AsesLastEligibilityUpdateSource] [nvarchar](30) NULL,
	[AsesLastEligibilityUpdateDate] [datetime] NULL,
	[QueryResponseDetailRecId] [uniqueidentifier] NULL,
	[CreatedON] [datetime] NULL ,
	[LastUpdateON] [datetime] NULL
) ON [PRIMARY]
GO

--=====================================================================================
--dbo.MemberArchive: Contiene los records eliminados 
--					 de la tabla dbo.Member
--					 como parte del proceso de reconciliacion.

CREATE TABLE dbo.MemberArchive(
	[MemberRecId] [uniqueidentifier] NULL,
	[CarrierMRefId] [int] NULL,
	[FirstName] [nvarchar](20) NULL,
	[MiddleInitial] [nvarchar](20) NULL,
	[LastName] [nvarchar](15) NULL,
	[SecLastName] [nvarchar](15) NULL,
	[GenderMRefId] [int] NULL,
	[BirthDate] [datetime] NULL,
	[DeathDate] [datetime] NULL,
	[SocialSecurity] [nvarchar](9) NULL,
	[SORId] [nvarchar](13) NULL,
	[CreatedBySrc] [nvarchar](60) NULL,
	[CreatedOnSrc] [datetime] NULL,
	[LastUpdateBySrc] [nvarchar](60) NULL,
	[LastUpdateOnSrc] [datetime] NULL,
	[JobLoadDate] [datetime] NULL,
	[MPI] [nvarchar](13) NULL
) ON [PRIMARY]

GO

--===============================================================================
--[dbo].[MemberPCPBkp]: Contiene todos los records antes de la reconciliación.

CREATE TABLE [dbo].[MemberPCPBkp](
	[MemberPCPRecId] [uniqueidentifier] NOT NULL,
	[MemberRecId] [uniqueidentifier] NULL,
	[ProviderId] [nvarchar](15) NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminationDate] [datetime] NULL,
	[SORId] [nchar](12) NULL,
	[CreatedBySrc] [nvarchar](60) NULL,
	[CreatedOnSrc] [datetime] NULL,
	[LastUpdateBySrc] [nvarchar](60) NULL,
	[LastUpdateOnSrc] [datetime] NULL,
	[JobLoadDate] [datetime] NOT NULL
) ON [PRIMARY]

GO

--===============================================================================
--[dbo].[MemberEnrollmentStatusBkp]: Contiene todos los records antes de la reconciliación.
CREATE TABLE [dbo].[MemberEnrollmentStatusBkp](
	[MemberEnrollmentStatusRecId] [uniqueidentifier] NOT NULL,
	[MemberRecId] [uniqueidentifier] NULL,
	[EnrollmentStatusMRefId] [int] NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminationDate] [datetime] NULL,
	[SORId] [nchar](12) NULL,
	[CreatedBySrc] [nvarchar](60) NULL,
	[CreatedOnSrc] [datetime] NULL,
	[LastUpdateBySrc] [nvarchar](60) NULL,
	[LastUpdateOnSrc] [datetime] NULL,
	[JobLoadDate] [datetime] NOT NULL
) ON [PRIMARY]

GO

--===============================================================================
--[dbo].[MemberBenefitPackageBkp]: Contiene todos los records antes de la reconciliación.
CREATE TABLE [dbo].[MemberBenefitPackageBkp](
	[MemberBenefitPackageRecId] [uniqueidentifier] NOT NULL,
	[MemberRecId] [uniqueidentifier] NULL,
	[BenefitPackageMRefId] [int] NULL,
	[EffectiveDate] [datetime] NULL,
	[TerminationDate] [datetime] NULL,
	[SORId] [nchar](12) NULL,
	[CreatedBySrc] [nvarchar](60) NULL,
	[CreatedOnSrc] [datetime] NULL,
	[LastUpdateBySrc] [nvarchar](60) NULL,
	[LastUpdateOnSrc] [datetime] NULL,
	[JobLoadDate] [datetime] NOT NULL
) ON [PRIMARY]

GO



--=====================================================================================


--=============================CONSOLIDATION_LAST_MEMBER_PACKAGE================================
END--=============================CONSOLIDATION================================
