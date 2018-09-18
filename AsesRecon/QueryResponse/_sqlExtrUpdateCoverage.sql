SELECT N'V'                                             'TranID'
      ,Memb.MemberRecId
      ,Memb.SocialSecurity
      ,HCFA.EnrollmentStatusMRefId
      ,HCFA.BenefitPackageMRefId
      ,HCFA.CmsEffectiveDate
      ,HCFA.CmsExpirationDate
      ,HCFA.MemberSuffix
      ,HCFA.MPI
      ,HCFA.HicNumber
      ,HCFA.OdsiNumber
      ,HCFA.AsesRegion
      ,HCFA.AsesEligibilityEffectiveDate
      ,HCFA.AsesEligibilityExpirationDate
      ,Curr.ContractNumber
      ,Curr.PCP1
      ,Curr.PCP1EffDate
      ,Curr.Carrier
      ,Curr.PlanType
      ,Curr.CoverageCode
      ,Ver.AsesBenefitPackageVersion
      ,CAST( '20180702' AS datetime )                   'CarrierProcessDate'
      ,CAST( CAST( dbo.DayFirstOfMonth( DATEADD( M ,1 ,'20180702' ))AS date )AS datetime )'CarrierEffectiveDate'
  FROM stg.EligibilityMemberCurrent Curr
       JOIN dbo.Member Memb
            ON Memb.MPI = Curr.MPI
       JOIN dbo.MemberHealthcareAdmin HCFA
            ON HCFA.MemberRecId = Memb.MemberRecId
           AND HCFA.Carrier = Curr.Carrier
       JOIN XRef.Carrier Carrier
            ON Carrier.CarrierMRefId = Memb.CarrierMRefId
           AND Carrier.ExternalValue = HCFA.Carrier
       JOIN MRef.Carrier CarrierM
            ON CarrierM.CarrierMRefId = Carrier.CarrierMRefId
       JOIN stg.BenefitPackageActiveVersion Ver
            ON Ver.BenefitPackageMRefid = HCFA.BenefitPackageMRefid
           AND Ver.AsesCoverageCode = Curr.CoverageCode
  
LEFT JOIN stg.EnrollmentDetail stgDet
ON stgDet.AsesCarrier = Curr.Carrier
AND  stgdet.MPI = Curr.MPI
WHERE 1 = 1
    AND Curr.HcreElegibilityInd = 'Y'
    AND Curr.PlanVersion != Ver.AsesBenefitPackageVersion
    AND Curr.CreatedOn >= '20180702'
    AND Carrier.ExternalTypeMRefId = dbo.ExternalTypeASES( )
    AND CarrierM.CarrierCode = 'PMC'  AND stgDet.MemberRecId IS NULL 