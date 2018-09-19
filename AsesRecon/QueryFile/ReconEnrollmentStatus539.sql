INSERT INTO [dbo].[MemberEnrollmentStatus]
           ([MemberEnrollmentStatusRecId]
           ,[MemberRecId]
           ,[EnrollmentStatusMRefId]
           ,[EffectiveDate]
           ,[TerminationDate]
           ,[SORId]
           ,[CreatedBySrc]
           ,[CreatedOnSrc]
           ,[LastUpdateBySrc]
           ,[LastUpdateOnSrc]
           ,[JobLoadDate]
           ,[MPI]
           ,[OrgId])
     Select [MemberEnrollmentStatusRecId]
           ,MES.[MemberRecId]
           ,[EnrollmentStatusMRefId]
           ,[EffectiveDate]
           ,[TerminationDate]
           ,[SORId]
           ,[CreatedBySrc]
           ,[CreatedOnSrc]
           ,[LastUpdateBySrc]
           ,[LastUpdateOnSrc]
           ,[JobLoadDate]
           ,MES.[MPI]
           ,[OrgId]
From [1PACIFIC1-MA\IA3PACIFIC6].ases.dbo.MemberEnrollmentStatus MES
	Inner Join dbo.MemberConsNoMPMpi MCNMM	
	On MCNMM.memberRecId = MES.memberRecId
;




Select Distinct *
From dbo.MemberEnrollmentStatus
WHERE 1 = 1
	and MPI IS NULL
	and
;

Select *
From mref.BenefitPackage


Select Distinct P.asescarrier, B.CompanyContract
From [dbo].[vw_BenefitPackageVersion] P
	Inner Join mref.BenefitPackage B
	On P.BenefitPackageMRefId = B.BenefitPackageMRefId

