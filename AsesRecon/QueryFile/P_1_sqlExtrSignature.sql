--============================================
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
      ,N'SIG'    'QuerySource'
	  ,MEM.MPI
  FROM
       dbo.MemberBenefitPackage Benefit
       JOIN dbo.vw_BenefitPackageCurrent Curr
            ON Curr.MemberRecId = Benefit.MemberRecId
           AND Curr.CreatedOnSrc = Benefit.CreatedOnSrc
       JOIN dbo.Member MEM
            ON MEM.MemberRecId = Benefit.MemberRecId
       JOIN dbo.MemberHealthCareAdmin HCFA
            ON HCFA.MemberRecId = MEM.MemberRecId
       JOIN dbo.vw_BenefitPackageActiveAndFuturePlatino Platino
            ON Platino.BenefitPackageMRefId = Benefit.BenefitPackageMRefId
           AND Platino.CarrierMRefId = MEM.CarrierMRefId
       JOIN dbo.vw_ActiveMembers Active
            ON Active.EnrollmentStatusMRefid = HCFA.EnrollmentStatusMRefid
           AND Active.CarrierMRefId = MEM.CarrierMRefId
WHERE 1=1
And (Benefit.TerminationDate IS NULL
  Or Benefit.TerminationDate > '20180601')
 And Benefit.LastUpdateOnSrc > '20180601'
 And Active.CarrierCode = 'MMM' 
 AND (
	 Benefit.EffectiveDate >=  '20180601'  AND  DATEDIFF(dd, '20180601', Benefit.EffectiveDate) <= 90
 	or 
	(Benefit.EffectiveDate between DATEADD(mm, DATEDIFF(m,0,GETDATE())+0,0) and (DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)))		and hcfa.EnrollmentStatusMRefId = 24)
	)
--========================================================================================
--1. Consolidar los rec Id.
--2. Los carrier al existir el header uno solo con actualizarlo se sabe cual es.
--3. Elaina va a confirmar si hay que eliminar records de QueryDetail ya que hay records sin MPI.


