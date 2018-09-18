SELECT MEM.MemberRecId
      ,MEM.CarrierMRefId
      ,MEM.SORId
      ,MEM.Firstname
      ,MEM.Lastname
      ,MEM.SecLastname
      ,MEM.GenderMRefId
      ,MEM.BirthDate
      ,MEM.SocialSecurity
      ,HCFA.AsesRegion
      ,GETDATE( )'CarrierProcessDate'
      ,NULL      'CarrierEffectiveDate'
      ,N'EXP'    'QuerySource'
	,MEM.MPI
  FROM
       dbo.Member MEM
       JOIN dbo.MemberHealthCareAdmin HCFA
            ON HCFA.MemberRecId = MEM.MemberRecId
       JOIN dbo.vw_BenefitPackageActivePlatino Platino
            ON Platino.BenefitPackageMRefId = HCFA.BenefitPackageMRefId
           AND Platino.CarrierMRefId = MEM.CarrierMRefId
       JOIN dbo.vw_ActiveMembers Active
            ON Active.EnrollmentStatusMRefid = HCFA.EnrollmentStatusMRefid
           AND Active.CarrierMRefId = MEM.CarrierMRefId
WHERE 1=1
    And (HCFA.BenefitPackageEffDate < '20180712'
    And (HCFA.BenefitPackageEndDate IS NULL
	   OR HCFA.BenefitPackageEndDate >= '20180712'))
    And HCFA.AsesEligibilityExpirationDate BETWEEN '20180712' And '20180712'
    And Active.CarrierCode = 'MMM'
;


