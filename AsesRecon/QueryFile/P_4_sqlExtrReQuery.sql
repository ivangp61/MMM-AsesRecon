--Hay que comentar el carrierMrefId 
--en el join con la tabla member. Marcado en
--asterisco.


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
      ,N'RQY'    'QuerySource'
	  ,MEM.MPI
  FROM
       dbo.QueryResponseDetail resp
       JOIN XRef.Carrier carrier
            ON carrier.ExternalValue = resp.AsesCarrier
       JOIN MRef.Carrier MC
            ON MC.CarrierMRefId = carrier.CarrierMRefId
       JOIN dbo.Member MEM
            ON MEM.CarrierMRefId = carrier.CarrierMRefId--******
           AND MEM.MPI = resp.MPI
       JOIN dbo.MemberHealthcareAdmin HCFA
            ON HCFA.MemberRecId = MEM.MemberRecId
       JOIN dbo.vw_ActiveMembersCms CMS
            ON CMS.EnrollmentStatusMRefId = HCFA.EnrollmentStatusMRefId
           AND CMS.CarrierMRefId = MEM.CarrierMRefId
      JOIN dbo.vw_BenefitPackageActiveAndFuturePlatino BPAFP
            ON BPAFP.BenefitPackageMRefId = HCFA.BenefitPackageMRefId
  WHERE 1 = 1
 And resp.AsesElegibilityIndicator = 'N'
 And resp.CreatedOn >=  '20180712'
 And carrier.ExternalTypeMRefId = dbo.ExternalTypeASES()
 And  MC.CarrierCode = 'MMM' 
 And HCFA.BenefitPackageEndDate IS NULL
 ;



