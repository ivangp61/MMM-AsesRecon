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
      ,N'QAS'    'QuerySource'
      ,MBP.EffectiveDate
      ,MBP.TerminationDate
	  ,MEM.MPI
  FROM
       dbo.Member MEM
       JOIN dbo.MemberHealthCareAdmin HCFA
            ON HCFA.MemberRecId = MEM.MemberRecId
            
       JOIN dbo.MemberBenefitPackage MBP
			ON MBP.MemberRecId = MEM.MemberRecId
       JOIN dbo.vw_BenefitPackageCurrent Curr
			ON Curr.MemberRecId = MEM.MemberRecId
		   AND Curr.CreatedOnSrc = MBP.CreatedOnSrc
		   
       JOIN dbo.vw_BenefitPackageActiveAndFuturePlatino Platino
            ON Platino.BenefitPackageMRefId = MBP.BenefitPackageMRefId
           AND Platino.CarrierMRefId = MEM.CarrierMRefId
       JOIN dbo.vw_ActiveMembers Active
            ON Active.EnrollmentStatusMRefid = HCFA.EnrollmentStatusMRefid
           AND Active.CarrierMRefId = MEM.CarrierMRefId
       JOIN dbo.vw_QueryAlwaysSend QAS
            ON QAS.EnrollmentStatusMRefid = HCFA.EnrollmentStatusMRefid
           AND QAS.CarrierMRefId = MEM.CarrierMRefId
  WHERE 1 = 1
     And Active.CarrierCode = 'MMM'       
     And HCFA.BenefitPackageEndDate IS NULL
     AND DATEDIFF(dd, '20180712', MBP.EffectiveDate) <= 90
;


