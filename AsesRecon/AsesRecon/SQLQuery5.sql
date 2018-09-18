Select *
From dbo.Member
Where MPI = '0080022982070'
;

Select Top 100 *
From dbo.MemberHealthCareAdmin A
Where A.MPI = '0080022982070'
--A.MemberId =  '010012361'
;

Select Top 100 *
From MemberHealthCareAdminCurrent
;

Select Top 100 XES.CarrierMRefId, XES.ExternalValue, A.*
From dbo.Member M
	INNER JOIN dbo.MemberHealthCareAdmin A
	ON M.CarrierMRefId = A.CA
	INNER JOIN xref.EnrollmentStatus XES
	ON A.EnrollmentStatusMRefId = XES.EnrollmentStatusMRefId
Where A.MPI = '0080022982070'
;

Select *
From MRef.Carrier

Select Top 100 *
From dbo.MemberBenefitPackage BP
;

Select * 
From mref.BenefitPackage MBP
Where MBP.BenefitPackageMRefId = 34
;

Select *
From mref.Company

Select *
From XRef.Carrier

Select Top 100 *
From dbo.MemberPCP P
Where P.SORId = 'N00228014424'
;


Select *
From MRef.BenefitPackage BP
Where BP.BenefitPackageMRefId = 1
;

SELECT b.BenefitPackageMRefId  
    , x.CarrierMRefId
	, x.CompanyContract
    , x.ExternalValue
	,c.CarrierCode
FROM   mref.benefitpackage b 
join xref.benefitpackage  x on 
    x.BenefitPackageMRefId = b.BenefitPackageMRefId
join mref.externalType t on 
    t.ExternalTypeMRefId = x.ExternalTypeMRefId
join mref.carrier c on c.CarrierMRefId = x.CarrierMRefId
where 1=1 
 and t.ExternalTypeMRefId = dbo.ExternalTypeEnrollment()

Select Top 100 *
From mref.EnrollmentStatus

 --El tema es en webapp, las cubiertas estan bajando bien. Hay que añadirle el MPI a las cubiertas.

Select Top 100 *
From dbo.EligibilityMember
Where mpi = '0080022982070'


Select Top 100 *
From dbo.MemberEnrollmentStatus


Select Top 100 *
From dbo.MemberPCP



Select Top 100 *
From dbo.MemberHealthCareAdminCurrent
;


--MERGE 	dbo.MemberBenefitPackage   tgt
USING (
	SELECT  MemberRecId
		  ,BenefitPackageMRefId
		  ,EffectiveDate
		  ,TerminationDate
		  ,SORId
		  ,CreatedBySrc
		  ,CreatedOnSrc
		  ,LastUpdateBySrc
		  ,LastUpdateOnSrc
	FROM stg.MemberTgtBenefitHistory    
	WHERE 1=1)		    src
ON (src.MemberRecId = tgt.MemberRecId And src.SORId = tgt.SORId)
WHEN MATCHED THEN
UPDATE 
    SET   tgt.BenefitPackageMRefId = src.BenefitPackageMRefId
	  ,tgt.EffectiveDate = src.EffectiveDate
	  ,tgt.TerminationDate = src.TerminationDate
	  ,tgt.LastUpdateBySrc = src.LastUpdateBySrc
	  ,tgt.LastUpdateOnSrc = src.LastUpdateOnSrc
	  ,tgt.JobLoadDate = GETDATE()		 
WHEN NOT MATCHED THEN
INSERT (MemberRecId
	,BenefitPackageMRefId
	,EffectiveDate
	,TerminationDate
	, SORId
	,CreatedBySrc
	,CreatedOnSrc
	,LastUpdateBySrc
	,LastUpdateOnSrc) 
VALUES (src.MemberRecId
	,src.BenefitPackageMRefId
	,src.EffectiveDate
	,src.TerminationDate
	,src.SORId
	,src.CreatedBySrc
	,src.CreatedOnSrc
	,src.LastUpdateBySrc
	,src.LastUpdateOnSrc
);




SELECT N'1'                'TranID'
      ,PCP.ProviderId
       ,CAST( CAST( CASE
                   WHEN PCP.EffectiveDate < PCP.LastUpdateOnSrc
                       THEN DATEADD( D ,-1 ,dbo.DayFirstOfMonth( PCP.EffectiveDate ))
                       ELSE PCP.LastUpdateOnSrc
                   END AS date )AS datetime )              'CarrierProcessDate'
      ,CAST( CAST( PCP.EffectiveDate AS date )AS datetime )'CarrierEffectiveDate'
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
      ,Curr.Carrier
      ,Curr.PlanType
      ,Curr.PlanVersion
      ,Curr.CoverageCode
  FROM  dbo.Member Memb

  JOIN stg.EligibilityMemberCurrent Curr
            ON Curr.MPI = Memb.MPI
           AND Curr.Carrier = HCFA.Carrier      

       JOIN dbo.vw_PcpAssignCurrent Lastest
            ON Lastest.MPI = PCP.MPI
           --AND Lastest.CreatedOnSrc = PCP.CreatedOnSrc
		   AND Lastest.Carrier = CURR.Carrier




       JOIN dbo.MemberHealthcareAdmin HCFA
            ON HCFA.MemberRecId = Memb.MemberRecId
       JOIN XRef.Carrier Carrier
            ON Carrier.CarrierMRefId = Memb.CarrierMRefId
           AND Carrier.ExternalValue = HCFA.Carrier
       JOIN MRef.Carrier CarrierM
            ON CarrierM.CarrierMRefId = Carrier.CarrierMRefId

       JOIN stg.BenefitPackageActiveVersion Platino
            ON Platino.BenefitPackageMRefId = HCFA.BenefitPackageMRefId
           AND Platino.AsesCoverageCode = Curr.CoverageCode
  WHERE 1 = 1

    And PCP.EffectiveDate > Curr.PCP1EffDate    

    AND PCP.TerminationDate IS NULL

    AND PCP.LastUpdateOnSrc >= '20180501'

    AND PCP.ProviderId != Curr.PCP1
    AND (HCFA.BenefitPackageEndDate IS NULL

      OR HCFA.BenefitPackageEndDate > '20180501')

    AND Carrier.ExternalTypeMRefId = dbo.ExternalTypeASES( )

    AND CarrierM.CarrierCode = 'MMM'
    AND Curr.HcreElegibilityInd = 'Y'

	--and  runDate Between HCFA.BenefitPackageEffDate and HCFA.BenefitPackageEndDate)
	--and rundate between Between PCP.BenefitPackageEffDate and HCFA.BenefitPackageEndDate)

