--1. Ultima Vigencia:
Truncate Table dbo.MemberRecIdCon;
Truncate Table dbo.MemberBenefitPackageConsolidation;
Truncate Table [dbo].[MemberBenefitPackageMax];

Insert Into dbo.MemberRecIdCon(mpi, NAME_ID, memberRecId, carrierMrefId)
Select Distinct MM.MPI, M.SORId, M.MemberRecId, M.CarrierMRefId
From dbo.MPIMembership MM
	INNER JOIN dbo.Member M
	On MM.MPI = M.MPI
;

Insert Into [dbo].[MemberBenefitPackageMax](MPI,LastUpdateOnSrc)
Select Distinct M.MPI, Max(MBPS.CreatedOnSrc) as srcDate
From dbo.Member M
	Inner Join dbo.MPIMembership MM
	On M.MPI = MM.MPI
	Inner Join [dbo].[MemberBenefitPackageMpSource] MBPS
	On M.MPI = MBPS.MPI
Group By M.MPI
;


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

Select	Distinct 
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
;


Update dbo.MemberRecIdCon
	SET memberRecIdCons = MBP.MemberRecId
From dbo.MemberRecIdCon MRI
	 Inner Join [dbo].[MemberBenefitPackageConsolidation] MBP
	 On MRI.MPI = MBP.MPI
;

UPDATE dbo.MemberBenefitPackage
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.MemberBenefitPackage MBP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MBP.MemberRecId = MRIC.MemberRecId
;
