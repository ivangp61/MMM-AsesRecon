Select Distinct Top 100
						M.MemberRecId,
						Convert(varchar,Aveta.ExternalValue) as memberId,
						Convert(varchar,M.ExternalValue) as SSN,
						MC.FirstName,
						MC.LastName,	
						Package.contractId,
						Convert(varchar,Package.PBP) as PBP,
						MBP.SignatureDate,
						Package.effectiveDate,
						Package.termDate,
						Package.[Desc]						
From EnterpriseHub.XRef.Member M
	Inner Join EnterpriseHub.dbo.MemberCompany MC
	On M.MemberRecId = MC.MemberRecId and M.ExternalTypeMRefId = 9
	Inner Join dbo.QueryDetail QD
	On M.ExternalValue = QD.MemberSSN
	Inner Join EnterpriseHub.XRef.Member Aveta
	On MC.MemberRecId = Aveta.MemberRecId  and Aveta.ExternalTypeMRefId = 5
	Left Join
	(
		SELECT Distinct ind.MemberRecId,				
					ind.IndEffectiveDate as effectiveDate,				
					ind.IndEndDate as termDate
					,pkg.[Desc]
					, sor.CompanyContract as contractId
					, sor.BenefitPkgContractId as PBP
		FROM
			EnterpriseHub.dbo.MemberIndicator ind WITH ( nolock )
			JOIN EnterpriseHub.XRef.BenefitPackage sor WITH ( nolock )
				ON sor.ExternalValue = ind.IndValue
			JOIN EnterpriseHub.MRef.BenefitPackage pkg WITH ( nolock )
				ON pkg.BenefitPkgMRefId = sor.BenefitPkgMRefId
			JOIN (
					SELECT Distinct ind.MemberRecId,
									Max(ind.CreationDate) as creationDate
					FROM
						EnterpriseHub.dbo.MemberIndicator ind WITH ( nolock )
					WHERE 1 = 1
					--AND ind.MemberRecId = 537416
					AND ind.IndMRefId = 24
					AND IND.IndEffectiveDate <> Isnull(IND.IndEndDate, IND.IndEffectiveDate + 1)
					Group By ind.MemberRecId
				 ) as MaxProduct
				ON ind.MemberRecId = MaxProduct.MemberRecId
					and ind.CreationDate = MaxProduct.creationDate
		WHERE 1 = 1
			--AND ind.MemberRecId = 537416
			AND ind.IndMRefId = 24
			AND IND.IndEffectiveDate <> Isnull(IND.IndEndDate, IND.IndEffectiveDate + 1)
	) as Package
	On M.MemberRecId = Package.MemberRecId
	Left Join EnterpriseHub.dbo.MemberBenefitPackage MBP WITH ( nolock )
	On M.MemberRecId = MBP.MemberRecId
Where 1 = 1
	--and M.ExternalTypeMRefId = 9
	--and M.ExternalValue = '581610106'
	and QD.MPI is null
;


Select *
From dbo.QueryDetail QD
Where QD.MemberSSN = '010004582'
Order By QD.MemberSSN Desc
;

Select Count(Distinct QD.MPI)
From dbo.QueryDetail QD
Where 1 = 1
	and QD.MPI is NOT null
;

Select Count(*)
From dbo.QueryDetail QD
Where 1 = 1
	and QD.MPI is NOT null
;


Select Top 100 *
From dbo.Member M
	Inner Join dbo.MemberRecIdCon MRIC
	On M.MemberRecId = MRIC.memberRecIdCons
	Inner Join dbo.QueryDetail QD
	On M.SocialSecurity = QD.MemberSSN
Where 1 = 1
	--and M.SocialSecurity = ''
	and QD.MPI is null
;


Select Count(Distinct M.MPI)
--Top 100 MPI,M.*
From dbo.Member M
	Inner Join dbo.QueryDetail QD
	On M.SocialSecurity = QD.MemberSSN
Where 1 = 1
	--and M.SocialSecurity = ''
	and QD.MPI is null
;

--

Select Top 100 *
From dbo.Member M
Where m.MPI = '0080016086169'
--mpi = '0080016086169'



Select Top 100 *
From dbo.EnrollmentRejectDetail E
Where E.MemberSSN= '075600658'
--E.MPI = '0080008900236'
;


Select *
From dbo.EnrollmentDetail ED
Where Ed.MPI = '0080008900236'
	and ED.EnrollmentRejectRecId = 'DBDBF25C-9111-4263-9B47-DAF0543DBF88'
;

Select Top 100  *
From XRef.BenefitPackage sor WITH ( nolock )

Select Top 100 *
From MRef.BenefitPackage 
Where 
;

