Begin--==================SYNC_TABLES========================
SELECT TOP 100 *
FROM dbo.Member 
WHERE 1 = 1
	--and mpi is not null
	and mpi = '0008000032375'
	--and CONVERT(varchar,JobLoadDate, 23) = '2018-07-03' 
	--and SocialSecurity = '582669532'
ORDER BY CreatedOnSrc DESC
;

SELECT *
FROM dbo.MemberHealthCareAdmin
WHERE 1 = 1
	and mpi is not null
	and mpi = '0008000032375'
	--and CONVERT(varchar,JobLoadDate, 23) >= '2018-07-02' 
;

SELECT Top 100 *
FROM dbo.MemberBenefitPackage
WHERE 1 = 1
	and mpi is not null
	and mpi = '0008000032375'
	--and CONVERT(varchar,JobLoadDate, 23) >= '2018-07-02' 
;

SELECT Top 100 *
FROM dbo.MemberPCP
WHERE 1 = 1
	and mpi is not null
	--and CONVERT(varchar,JobLoadDate, 23) >= '2018-07-02' 
;

SELECT Top 100 *
FROM dbo.MemberEnrollmentStatus
WHERE 1 = 1
	and mpi is not null
	--and CONVERT(varchar,JobLoadDate, 23) >= '2018-07-02' 
;
End--==================SYNC_TABLES========================

--787-759-7070
--=====================RECON_TABLES=======================
SELECT *
FROM [dbo].[MemberBenefitPackageMpSource]
;

select --count(distinct mpi)
count(*)
from [dbo].[memberbenefitpackagempsource]

SELECT MPI, COUNT(MPI) 
FROM EligibilityMember
GROUP BY MPI
HAVING COUNT(MPI) > 1 
;

SELECT COUNT(*) 
FROM EligibilityMember
;


--=====================RECON_TABLES=======================
Select *
From dbo.MemberExtrEnrollmentStatusError
;
--ErrorCode + ": " + ErrorColumn

Select Top 100 *
From dbo.Member M
Where m.MemberRecId = 'FB6D83D8-780D-4AA0-AC52-99831D25DBBB'--'339DAE7D-A5E9-49B8-BC8E-7AD97A3A2B54'--
Where M.SocialSecurity = '222369884'
;


Select Top 100 *
From stg.MemberExtrEnrollHeader

Select Top 100 *
From dbo.MemberHealthCareAdmin H
Where H.MemberRecId = 'FB6D83D8-780D-4AA0-AC52-99831D25DBBB'
;

Select Count(*)
From dbo.MemberHealthCareAdmin H
Where mpi is not null
;





--Velar por el AsesCoverageCode: Hablar con Bezabeth. Se ve el mismo por los dos company.

Select Top 50 *
From dbo.MemberBenefitPackage BP
Where BP.MemberRecId = 'FB6D83D8-780D-4AA0-AC52-99831D25DBBB'
;




Select Top 100 *
From dbo.MemberEnrollmentStatus E
Where E.MemberRecId = 'FB6D83D8-780D-4AA0-AC52-99831D25DBBB'
;

Select Top 100 *
From dbo.MemberPCP P
Where P.MemberRecId = 'FB6D83D8-780D-4AA0-AC52-99831D25DBBB'--'EAABB375-98B6-45CE-898D-E2E5E8CAEFFD'--
;




Select Top 100 *
From stg.MemberExtrEnrollHeader
;

Select Top 100 *
From stg.MemberTgtEnrollHeader
;


Select Top 100 *
From stg.MemberExtrBenefitHistory
;


Select Top 100 *
From stg.MemberTgtBenefitHistory
;


Select Top 100 *
From stg.MemberExtrPCPHistory
;

Select Top 100 *
From stg.MemberExtrEnrollHistory
;

Select Top 100 *
From stg.MemberTgtEnrollHistory
;

Select Top 100 *
From stg.MemberExtrPCPHistory
;

Select Top 100 *
From stg.MemberTgtPCPHistory
;


SELECT b.BenefitPackageMRefId  
    , x.CarrierMRefId
    , x.ExternalValue
FROM   mref.benefitpackage b 
join xref.benefitpackage  x on 
    x.BenefitPackageMRefId = b.BenefitPackageMRefId
join mref.externalType t on 
    t.ExternalTypeMRefId = x.ExternalTypeMRefId
join mref.carrier c on c.CarrierMRefId = x.CarrierMRefId
where 1=1 
 and t.ExternalTypeMRefId = dbo.ExternalTypeEnrollment()
 and x.BenefitPackageMRefId = 208


select *
from xref.benefitpackage

--mpi = '0080021882191'
--identifierId = 'N00140203040'
--identifierCode = 'MPPMC'


--identifierId = 'N00372502057'
--identifierCode = 'MPMMMFP'

--identifierId = 'N00372502057'
--identifierCode = 'MPFL'
