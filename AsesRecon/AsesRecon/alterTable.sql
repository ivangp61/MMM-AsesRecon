USE [ASES]
GO

--stg.MemberExtrEnrollHeader
ALTER TABLE stg.MemberExtrEnrollHeader
  ADD  MPI NVARCHAR(13) NULL;
GO 

--stg.MemberTgtEnrollHeader
ALTER TABLE stg.MemberTgtEnrollHeader
  ADD  MPI NVARCHAR(13) NULL;
GO 


--stg.MemberExtrBenefitHistory
ALTER TABLE stg.MemberExtrBenefitHistory
  ADD  MPI NVARCHAR(13) NULL;
GO 

--stg.MemberTgtBenefitHistory
ALTER TABLE stg.MemberTgtBenefitHistory
  ADD  MPI NVARCHAR(13) NULL;
GO 

--dbo.MemberBenefitPackage
ALTER TABLE dbo.MemberBenefitPackage
  ADD  MPI NVARCHAR(13) NULL;
GO 

--stg.MemberExtrPCPHistory
ALTER TABLE stg.MemberExtrPCPHistory
  ADD  MPI NVARCHAR(13) NULL,
	   PackageId NVARCHAR(12) NULL,
	   OrgId NVARCHAR(5) NULL,
	   PBPCode NVARCHAR(20) NULL;
GO

--stg.MemberTgtPCPHistory
ALTER TABLE stg.MemberTgtPCPHistory
  ADD  MPI NVARCHAR(13) NULL,
	   PackageId NVARCHAR(12) NULL,
	   OrgId NVARCHAR(5) NULL,
	   PBPCode NVARCHAR(20) NULL;
GO

--dbo.MemberPCP
ALTER TABLE dbo.MemberPCP
  ADD  MPI NVARCHAR(13) NULL,
	   PackageId NVARCHAR(12) NULL,
	   OrgId NVARCHAR(5) NULL,
	   PBPCode NVARCHAR(20) NULL;
GO

--stg.MemberExtrEnrollHistory
ALTER TABLE stg.MemberExtrEnrollHistory
  ADD  MPI NVARCHAR(13) NULL,
  	   PackageId NVARCHAR(12) NULL,
	   OrgId NVARCHAR(5) NULL,
	   Carrier INT NULL
GO

--stg.MemberTgtEnrollHistory
ALTER TABLE stg.MemberTgtEnrollHistory
  ADD  MPI NVARCHAR(13) NULL,
  	   PackageId NVARCHAR(12) NULL,
	   OrgId NVARCHAR(5) NULL,
	   Carrier INT NULL
GO


--dbo.MemberEnrollmentStatus 
ALTER TABLE dbo.MemberEnrollmentStatus
  ADD  MPI NVARCHAR(13) NULL,
  	   PackageId NVARCHAR(12) NULL,
	   OrgId NVARCHAR(5) NULL,
	   Carrier INT NULL
GO

--MRef.Entity (New Table)
CREATE TABLE MRef.Entity (
    EntityId int IDENTITY(1,1) NOT NULL,
    Name nvarchar(30) NULL, 
    CreationDate DateTime NOT NULL,
	ModificationDate DateTime NOT NULL
)
GO

--dbo.MemberIdentifier 
CREATE TABLE dbo.MemberIdentifier (
		MPI NVARCHAR(13) NULL,
		EntityId int NOT NULL,
		Value nvarchar(36) NOT NULL,
		CreationDate DateTime NOT NULL,
		ModificationDate DateTime NOT NULL
	)
GO






