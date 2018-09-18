Select Count(*),
MRIC.MPI,
QD.MPI
From dbo.Member M
	Inner Join dbo.MemberRecIdCon MRIC
	On M.MemberRecId = MRIC.memberRecId
	Inner Join dbo.QueryDetail QD
	On Mric.memberRecId = QD.MemberRecId
Where QD.MPI is null
;


Select *
From EnterpriseHub.xref.Member M
Where M.ExternalValue = '0080016086169'
;

--10467194
--898194
--1257645

Select Count(Distinct QD.MemberSSN)
From dbo.QueryDetail QD
Where mpi is null
;


Select Top 15 *
From dbo.QueryDetail QD
Where QD.MPI is null;


Select Distinct 
						M.MemberRecId,
						--Aveta.ExternalValue,
						--QD.Firstname,
						--QD.Lastname,
						--QD.SecLastname,
						--M.ExternalValue,						
						--QD.AsesCarrier,
						--QD.AsesGender,
						--QD.AsesRegion,
						--QD.BirthDate,
						--QD.CarrierEffectiveDate,
						--QD.CarrierProcessDate,
						--QD.CreatedBy,
						--QD.CreatedOn,
						--QD.MemberRecId,
						--QD.MemberSSN,
						--QD.QueryDetailRecId,
						QD.QueryFileLogRecId,
						QD.QueryResponseDate,
						QD.QueryResponseDetailRecId--,
						--QD.QuerySource,
						--QD.QueueStatusBy,
						--QD.QueueStatusDate,
						--QD.QueueStatusMRefId,
						--QD.QueueStatusNote,
						--QD.RecordType
From EnterpriseHub.XRef.Member M
	Inner Join EnterpriseHub.dbo.MemberCompany MC
	On M.MemberRecId = MC.MemberRecId
	Inner Join dbo.QueryDetail QD
	On M.ExternalValue = QD.MemberSSN
	Inner Join EnterpriseHub.XRef.Member Aveta
	On MC.MemberRecId = Aveta.MemberRecId  and Aveta.ExternalTypeMRefId = 5
Where M.ExternalTypeMRefId = 9
	and M.ExternalValue = '581610106'
Order By QD.QueryResponseDate Desc
;


Select Distinct 
						M.MemberRecId,
						Aveta.ExternalValue as memberId,
						M.ExternalValue as SSN,
						MC.FirstName,
						MC.LastName,	
						Package.contractId,
						Package.PBP,					
						Package.effectiveDate,
						Package.termDate,
						Package.[Desc]						
From EnterpriseHub.XRef.Member M
	Inner Join EnterpriseHub.dbo.MemberCompany MC
	On M.MemberRecId = MC.MemberRecId
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
			AND ind.MemberRecId = 537416
			AND ind.IndMRefId = 24
			AND IND.IndEffectiveDate <> Isnull(IND.IndEndDate, IND.IndEffectiveDate + 1)
	) as Package
	On M.MemberRecId = Package.MemberRecId
Where M.ExternalTypeMRefId = 9
	and M.ExternalValue = '581610106'
	and QD.MPI is null
;


--Select *
--From EnterpriseHub.mref.ExternalType ET
--Where ET.code = 'SSN'
--	and 
;


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
	AND ind.MemberRecId = 537416
	AND ind.IndMRefId = 24
	AND IND.IndEffectiveDate <> Isnull(IND.IndEndDate, IND.IndEffectiveDate + 1)
;


SELECT Distinct ind.MemberRecId,
				Max(ind.CreationDate)
FROM
    EnterpriseHub.dbo.MemberIndicator ind WITH ( nolock )
WHERE 1 = 1
AND ind.MemberRecId = 537416
AND ind.IndMRefId = 24
AND IND.IndEffectiveDate <> Isnull(IND.IndEndDate, IND.IndEffectiveDate + 1)
Group By ind.MemberRecId
;



SELECT Distinct ind.*,sor.CompanyContract
FROM
    EnterpriseHub.dbo.MemberIndicator ind WITH ( nolock )
    JOIN EnterpriseHub.XRef.BenefitPackage sor WITH ( nolock )
        ON sor.ExternalValue = ind.IndValue
    JOIN EnterpriseHub.MRef.BenefitPackage pkg WITH ( nolock )
        ON pkg.BenefitPkgMRefId = sor.BenefitPkgMRefId
WHERE 1 = 1
	AND ind.MemberRecId = 537416
	AND ind.IndMRefId = 24
	AND IND.IndEffectiveDate <> Isnull(IND.IndEndDate, IND.IndEffectiveDate + 1)
;



Select Top 5 *
From EnterpriseHub.dbo.MemberCompany MC
	Inner Join 

Select Top 5 *
From EnterpriseHub.dbo.MemberIndicator ind WITH ( nolock )


Select Top 5 *
From EnterpriseHub.dbo.MemberBenefitPackage MBP WITH ( nolock )
Where MBP.MemberRecId = 537416
;



Select Top 100 *
From dbo.QueryDetail QD
Where 1 = 1
	and QD.MPI is null
;

Select Count(Distinct QD.MemberSSN)
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