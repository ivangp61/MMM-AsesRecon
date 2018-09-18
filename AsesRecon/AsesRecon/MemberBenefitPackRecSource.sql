select --count(distinct mpi)
count(*)
from [dbo].[memberbenefitpackagempsource]
;--1,082,753

Select *
From [dbo].[memberbenefitpackagempsource] MBPS
Where MBPS.MemberRecId is null
;

Select Distinct Top 100
				M.MemberRecId,
				MBP.BenefitPackageMRefId,
				MBPS.*,
				C.ExternalValue,
				c.CarrierMRefId
From [dbo].[memberbenefitpackagempsource] MBPS
	Inner Join Xref.Carrier C
	On MBPS.orgId = C.ExternalValue
	Inner Join dbo.Member M
	On MBPS.MPI = M.MPI and M.CarrierMRefId = C.CarrierMRefId
	Inner Join Mref.BenefitPackage MBP
	On MBPS.PackageId = MBP.SorId and C.CarrierMRefId = MBP.CarrierMRefId
Where 1 = 1
	--AND orgId  = 'H4003'
	AND M.mpi = '0080021776807'
;
--4:4004
--8:4003

Select *
From Mref.BenefitPackage

Select Count(*)
From (
		Select DISTINCT M.MemberRecId,
						MBP.BenefitPackageMRefId,
						MBPS.EffectiveDate, 
						MBPS.TerminationDate, 
						MBPS.SORId, 
						MBPS.CreatedBySrc, 
						MBPS.CreatedOnSrc, 
						MBPS.LastUpdateBySrc, 
						MBPS.LastUpdateOnSrc, 
						MBPS.JobLoadDate, 
						MBPS.MPI, 
						MBPS.PackageId, 
						MBPS.OrgId, 
						MBPS.Pbp,
						C.ExternalValue,
						c.CarrierMRefId
		From [dbo].[memberbenefitpackagempsource] MBPS
			Inner Join Xref.Carrier C
			On MBPS.orgId = C.ExternalValue
			Inner Join dbo.Member M
			On MBPS.MPI = M.MPI and M.CarrierMRefId = C.CarrierMRefId
			Inner Join Mref.BenefitPackage MBP
			On MBPS.PackageId = MBP.SorId and C.CarrierMRefId = MBP.CarrierMRefId AND C.ExternalValue = MBP.CompanyContract
		Where 1 = 1
) as A
;


Select Count(*)
From (
		Select DISTINCT M.MemberRecId,
						MBP.BenefitPackageMRefId,
						MBPS.EffectiveDate, 
						MBPS.TerminationDate, 
						MBPS.SORId, 
						MBPS.CreatedBySrc, 
						MBPS.CreatedOnSrc, 
						MBPS.LastUpdateBySrc, 
						MBPS.LastUpdateOnSrc, 
						MBPS.JobLoadDate, 
						MBPS.MPI, 
						MBPS.PackageId, 
						MBPS.OrgId, 
						MBPS.Pbp,
						C.ExternalValue,
						c.CarrierMRefId
		From [dbo].[memberbenefitpackagempsource] MBPS
			Inner Join Xref.Carrier C
			On MBPS.orgId = C.ExternalValue
			Inner Join dbo.Member M
			On MBPS.MPI = M.MPI and M.CarrierMRefId = C.CarrierMRefId
			Inner Join Mref.BenefitPackage MBP
			On MBPS.PackageId = MBP.SorId and C.CarrierMRefId = MBP.CarrierMRefId AND C.ExternalValue = MBP.CompanyContract
		Where 1 = 1
) as A
;

Select Distinct MemberRecId, mpi
From [dbo].[memberbenefitpackagempsource]

Select DISTINCT M.MemberRecId,
MBPS.MemberRecId,
						MBPS.EffectiveDate, 
						MBPS.TerminationDate, 
						MBPS.SORId, 
						MBPS.CreatedBySrc, 
						MBPS.CreatedOnSrc, 
						MBPS.LastUpdateBySrc, 
						MBPS.LastUpdateOnSrc, 
						MBPS.JobLoadDate, 
						MBPS.MPI, 
						MBPS.PackageId, 
						MBPS.OrgId, 
						MBPS.Pbp,
						C.ExternalValue,
						c.CarrierMRefId
From [dbo].[memberbenefitpackagempsource] MBPS
	Inner Join Xref.Carrier C
	On MBPS.orgId = C.ExternalValue
	Inner Join dbo.Member M
	On MBPS.MPI = M.MPI and M.CarrierMRefId = C.CarrierMRefId
Where 1 = 1
	--and M.MemberRecId = '2944CDB0-095A-4667-80A6-6C4A4752C5ED'
	and m.mpi in(
				Select Distinct MPI
				From dbo.MemberBenefitPackageConsolidation M
				Where m.memberrecid = '2944CDB0-095A-4667-80A6-6C4A4752C5ED'
			)
	and m.mpi = '0080021188669'
;


--Update [dbo].[memberbenefitpackagempsource]
Set MemberRecId = M.MemberRecId	
From [dbo].[memberbenefitpackagempsource] MBPS
	Inner Join Xref.Carrier C
	On MBPS.orgId = C.ExternalValue
	Inner Join dbo.Member M
	On MBPS.MPI = M.MPI and M.CarrierMRefId = C.CarrierMRefId
;

Select *
From Xref.Carrier



--

Select *
From 
	(
		Select *
		From dbo.member
	) as M
Where 1 = 1
	and M.SORId = 
	and M.CarrierMRefId = 