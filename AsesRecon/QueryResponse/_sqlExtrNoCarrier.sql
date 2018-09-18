SELECT N'C'                                             'TranID'
      ,Memb.MemberRecId
      ,Memb.SocialSecurity
      ,HCFA.MemberId                                    'ContractNumber'
      ,HCFA.EnrollmentStatusMRefId
      ,HCFA.BenefitPackageMRefId
      ,HCFA.PCPAssign                                   'PCP1'
      ,dbo.DayFirstOfMonth( '20180702' )'PCP1EffDate'
      ,HCFA.CmsEffectiveDate
      ,HCFA.CmsExpirationDate
      ,HCFA.MemberSuffix
      ,HCFA.MPI
      ,HCFA.HicNumber
      ,HCFA.OdsiNumber
      ,HCFA.AsesRegion
      ,HCFA.AsesCoverageCode
      ,HCFA.AsesEligibilityEffectiveDate
      ,HCFA.AsesEligibilityExpirationDate
      ,Carrier.ExternalValue                            'AsesCarrier'
      ,Ver.AsesBenefitPackageType
      ,Ver.AsesBenefitPackageVersion
      ,CAST(CAST(DATEADD( D ,-1 ,dbo.DayFirstOfMonth( '20180702' ))AS date )AS datetime ) 'CarrierProcessDate'
      ,CAST(CAST(dbo.DayFirstOfMonth( '20180702' )AS date )AS datetime )                 'CarrierEffectiveDate'
  FROM
       stg.EligibilityMemberCurrent Curr
       JOIN dbo.Member Memb
            ON Memb.MPI = Curr.MPI
       JOIN dbo.MemberHealthcareAdmin HCFA
            ON HCFA.MemberRecId = Memb.MemberRecId
       JOIN XRef.Carrier Carrier
            ON Carrier.CarrierMRefId = Memb.CarrierMRefId
       JOIN MRef.Carrier CarrierM
            ON CarrierM.CarrierMRefId = Carrier.CarrierMRefId
       JOIN stg.BenefitPackageActiveVersion Ver
            ON Ver.BenefitPackageMRefid = HCFA.BenefitPackageMRefid
           AND Ver.AsesCoverageCode = HCFA.AsesCoverageCode

LEFT JOIN stg.EnrollmentDetail stgDet
ON stgDet.AsesCarrier = Curr.Carrier
AND  stgdet.MPI = Curr.MPI


  WHERE 1 = 1
    AND Curr.HcreElegibilityInd = 'Y'
    AND Curr.CarrierEffDate IS NULL
    AND Curr.NewCarrierEffDate IS NULL  
    AND Curr.CreatedOn >= '20180702'
    AND Carrier.ExternalTypeMRefId = dbo.ExternalTypeASES( )
    AND CarrierM.CarrierCode = 'PMC'
    AND (HCFA.BenefitPackageEndDate IS NULL
      OR HCFA.BenefitPackageEndDate > '20180702') AND stgDet.MemberRecId IS NULL


