SELECT CASE
		WHEN datediff(dd,getdate(),curr.ProcessDate) <= 30 THEN N'V' 
		ELSE N'C'
	END AS  TranID      ,CAST(CAST(CASE
       WHEN MBP.EffectiveDate < MBP.LastUpdateOnSrc
           THEN DATEADD( D ,-1 ,dbo.DayFirstOfMonth( MBP.EffectiveDate ))
           ELSE MBP.LastUpdateOnSrc
       END  as date) as datetime)             'CarrierProcessDate'
      ,CAST(CAST(MBP.EffectiveDate as date) as datetime)   'CarrierEffectiveDate'
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
      ,Ver.AsesBenefitPackageType
      ,Ver.AsesBenefitPackageVersion
      ,Curr.ContractNumber
      ,Curr.PCP1
      ,Curr.PCP1EffDate
      ,Curr.Carrier
      ,Curr.CoverageCode
      ,MBP.EffectiveDate
      ,MBP.TerminationDate
  FROM
       dbo.MemberBenefitPackage MBP
       
	   JOIN dbo.vw_BenefitPackageCurrent Lastest
            ON Lastest.MemberRecId = MBP.MemberRecId
           AND Lastest.CreatedOnSrc = MBP.CreatedOnSrc
       
	   JOIN dbo.Member Memb
            ON Memb.MemberRecId = MBP.MemberRecId
       
	   JOIN dbo.MemberHealthcareAdmin HCFA
            ON HCFA.MemberRecId = Memb.MemberRecId
       
	   JOIN XRef.Carrier Carrier
            ON Carrier.CarrierMRefId = Memb.CarrierMRefId
           AND Carrier.ExternalValue = HCFA.Carrier
       
	   JOIN MRef.Carrier CarrierM
            ON CarrierM.CarrierMRefId = Carrier.CarrierMRefId
			
       JOIN stg.EligibilityMemberCurrent Curr
            ON Curr.MPI = Memb.MPI
           AND Curr.Carrier = HCFA.Carrier
		   
       JOIN dbo.vw_BenefitPackageVersion Ver
            ON Ver.BenefitPackageMRefid = MBP.BenefitPackageMRefid
           AND Ver.AsesCoverageCode = Curr.CoverageCode
  

		LEFT JOIN stg.EnrollmentDetail stgDet
		ON stgDet.AsesCarrier = Curr.Carrier
		AND  stgdet.MPI = Curr.MPI

WHERE 1 = 1
	--Future pkg
	AND (((MBP.EffectiveDate > GETDATE() AND DATEDIFF(dd, GETDATE(), MBP.EffectiveDate) <= 90)
	AND (MBP.TerminationDate IS NULL OR MBP.TerminationDate >= DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0,GETDATE())+ 2, 0)))))


    AND Carrier.ExternalTypeMRefId = dbo.ExternalTypeASES( )
    AND CarrierM.CarrierCode = 'PMC'
    AND Curr.PlanVersion != Ver.AsesBenefitPackageVersion
    AND Curr.HcreElegibilityInd = 'Y'  AND stgDet.MemberRecId IS NULL

