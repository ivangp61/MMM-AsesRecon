WITH A AS (
SELECT
N'C' 'TranID',Resp.AsesElegibilityIndicator,Resp.QueryResponseDetailRecId,Resp.MemberSSN,Resp.CarrierGender
,Resp.CarrierBirthDate,Resp.AsesCarrier,Resp.AsesElegibilityEffectiveDate,Resp.AsesElegibilityExpirationDate,Resp.AsesGender
,Resp.AsesBirthDate,Resp.AsesRegionCode,CAST(CAST(Resp.CarrierFutureEffectiveDate AS date) AS datetime) AS 'CarrierEffectiveDate',Resp.QuerySource,Resp.AsesCoverageCode,Resp.MemberSuffix,Resp.ODSIFamilyID,Resp.MPI,Resp.MessageCode
,M.MemberRecId,CAST(CAST(HCFA.SignatureDate AS date)AS datetime)'CarrierProcessDate',HCFA.MemberId 'ContractNumber'
,CASE WHEN Resp.CarrierEffectiveDate IS NOT NULL THEN MES.EnrollmentStatusMRefId ELSE HCFA.EnrollmentStatusMRefId 
END AS EnrollmentStatusMRefId,MMBP.BenefitPackageMRefId,CAST(CAST(MMBP.EffectiveDate AS date) AS datetime)'BenefitPackageEffDate',
CAST(CAST(MMBP.TerminationDate AS date)AS datetime)'BenefitPackageEndDate'       
,HCFA.PCPAssign,HCFA.PCPEffectiveDate,HCFA.CmsEffectiveDate,HCFA.CmsExpirationDate,HCFA.HicNumber
,Ver.AsesBenefitPackageType,Ver.AsesBenefitPackageVersion,Ver.BenefitPackageMRefId as VerBenefitPackageMRefId,Ver.AsesCoverageCode as VerAsesCoverageCode,Curr.NewCarrier,CASE WHEN RESP.CarrierEffectiveDate IS NOT NULL 
THEN HIS.Carrier ELSE Curr.Carrier END AS Carrier,CASE WHEN RESP.CarrierEffectiveDate IS NOT NULL 
THEN HIS.CarrierEffDate ELSE Curr.CarrierEffDate END AS OtherCarrierEffDate,CASE WHEN RESP.CarrierEffectiveDate 
IS NOT NULL THEN HIS.NewCarrierEffDate ELSE CURR.NewCarrierEffDate END AS NewCarrierEffDate,Curr.CreatedOn
,ROW_NUMBER() OVER (PARTITION BY M.MEMBERRECID ORDER BY MES.EFFECTIVEDATE DESC) RN 

FROM dbo.vw_QueryResponseMemberCurrent Resp
	JOIN XRef.Carrier XC ON RTRIM(XC.ExternalValue)=RTRIM(Resp.AsesCarrier)
	JOIN MRef.Carrier MC ON MC.CarrierMRefId = XC.CarrierMRefId
	JOIN dbo.Member M ON M.CarrierMRefId = XC.CarrierMRefId AND  M.MPI = Resp.MPI
	JOIN dbo.MemberHealthcareAdmin HCFA ON HCFA.MemberRecId = M.MemberRecId
	JOIN dbo.MemberBenefitPackage MMBP ON M.MemberRecId = MMBP.MemberRecId
	 AND  CAST(Resp.CarrierFutureEffectiveDate AS date) BETWEEN MMBP.EffectiveDate AND ISNULL(CONVERT(date, MMBP.TerminationDate), '20781231') LEFT JOIN dbo.vw_BenefitPackageVersion Ver ON Ver.BenefitPackageMRefId = MMBP.BenefitPackageMRefId AND CAST(MMBP.EffectiveDate AS date) BETWEEN Ver.AsesVersionEffectiveDate AND ISNULL(CONVERT(date, Ver.AsesVersionExpirationDate), '20781231')  AND Ver.AsesCoverageCode = Resp.AsesCoverageCode LEFT JOIN stg.EligibilityMemberCurrent Curr ON  Curr.MPI = Resp.MPI
	LEFT JOIN dbo.MemberEnrollmentStatus MES ON MES.MemberRecId = M.MemberRecId AND Resp.CarrierEffectiveDate IS NOT NULL
	AND CONVERT(DATE,MES.EffectiveDate) <> ISNULL(CONVERT(DATE,MES.TerminationDate),GETDATE())
	AND CONVERT(DATE,Resp.CarrierEffectiveDate) BETWEEN CONVERT(DATE,MES.EffectiveDate) AND ISNULL(CONVERT(DATE,MES.TerminationDate),GETDATE())
	LEFT JOIN STG.ELIGIBILITYMEMBERHISTORY HIS ON HIS.MPI = RESP.MPI AND HIS.OdsiFamilyNumber = Resp.ODSIFamilyID 
	AND HIS.Carrier = Resp.AsesCarrier AND CONVERT(DATE,MMBP.EffectiveDate)<>ISNULL(CONVERT(DATE,MMBP.TerminationDate),GETDATE())
	AND CONVERT(DATE,HIS.CreatedOn) BETWEEN CONVERT(DATE,MMBP.EffectiveDate) AND ISNULL(CONVERT(DATE,MMBP.TerminationDate),GETDATE()) 
	AND RESP.CarrierEffectiveDate IS NOT NULL 
WHERE 1=1 
AND Resp.CarrierFutureEffectiveDate IS NOT NULL
AND Resp.QuerySource = 'AHC'
AND Resp.CreatedOn >='20180702'
AND MMBP.EffectiveDate<>ISNULL(MMBP.TerminationDate,GETDATE())
/*Carrier information filter */
AND XC.ExternalTypeMRefId=dbo.ExternalTypeASES()
AND MC.CarrierCode= 'PMC' 

) SELECT * FROM A WHERE 1=1 AND RN = 1