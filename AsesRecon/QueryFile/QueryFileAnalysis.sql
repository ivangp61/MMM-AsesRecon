Select Top 100 *
From DBO.QueryResponseDetail
;

Select Top 100 *
From dbo.QueryDetail
Where mpi is null
;

Select Count(*)
From dbo.QueryDetail
Where mpi is null
;

Select Count(Distinct qd.MemberRecId)
From dbo.QueryDetail qd
Where mpi is null
;

Select Count(*),
MRIC.MPI,
QD.MPI
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.QueryDetail QD
	On Mric.memberRecId = QD.MemberRecId
Where QD.MPI is null
;

--Update dbo.QueryDetail
Set MPI = MRIC.MPI
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.QueryDetail QD
	On Mric.memberRecId = QD.MemberRecId
Where QD.MPI is null;


--Update dbo.QueryDetail
Set MPI = m.MPI
From dbo.Member M
	Inner Join dbo.QueryDetail QD
	On M.SocialSecurity = QD.MemberSSN
Where 1 = 1
	--and M.SocialSecurity = ''
	and QD.MPI is null
;

Select Count(*)
From dbo.QueryDetail
--Where mpi is not null
Where mpi is null
;


--==============================
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
       JOIN dbo.vw_BenefitPackageCurrent Curr--Se puede eliminar ya que healthcareAdmin trae la cubierta actual
            ON Curr.MemberRecId = Benefit.MemberRecId
           AND Curr.CreatedOnSrc = Benefit.CreatedOnSrc
       JOIN dbo.Member MEM
            ON MEM.MemberRecId = Benefit.MemberRecId
       JOIN dbo.MemberHealthCareAdmin HCFA
            ON HCFA.MemberRecId = MEM.MemberRecId
       JOIN dbo.vw_BenefitPackageActiveAndFuturePlatino Platino
            ON Platino.BenefitPackageMRefId = Benefit.BenefitPackageMRefId
           AND Platino.CarrierMRefId = MEM.CarrierMRefId--Puede que cambie
       JOIN dbo.vw_ActiveMembers Active
            ON Active.EnrollmentStatusMRefid = HCFA.EnrollmentStatusMRefid
           AND Active.CarrierMRefId = MEM.CarrierMRefId
WHERE 1=1
And (Benefit.TerminationDate IS NULL
  Or Benefit.TerminationDate > '20180712')
 And Benefit.LastUpdateOnSrc > '20180712'
 And Active.CarrierCode = 'MMM' 
 AND (
	 Benefit.EffectiveDate >=  '20180712'  AND  DATEDIFF(dd, '20180712', Benefit.EffectiveDate) <= 90
 	or 
	(Benefit.EffectiveDate between DATEADD(mm, DATEDIFF(m,0,GETDATE())+0,0) and (DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)))		and hcfa.EnrollmentStatusMRefId = 24)
	)
--==============================

--Get members with program modified since last process run 
 --members should be in a CMS Active program
WITH CTE AS 
( 
 SELECT 
     ROW_NUMBER() OVER(PARTITION BY MES.MemberRecId ORDER BY MES.CreatedOnSrc DESC) AS RowNum 
     ,MES.MemberRecId
     ,CASE ISNULL(Active.EnrollmentStatusMRefId,0) WHEN 0 THEN 0 ELSE 1 END AS IsCMSActive
FROM dbo.MemberEnrollmentStatus MES WITH(NOLOCK)
INNER JOIN dbo.Member M WITH(NOLOCK)
ON MES.MemberRecId = M.MemberRecId
INNER JOIN dbo.MemberHealthCareAdmin HCFA WITH(NOLOCK)
ON MES.MemberRecId = HCFA.MemberRecId
LEFT JOIN dbo.vw_ActiveMembersCms Active WITH(NOLOCK)
ON MES.EnrollmentStatusMRefId = Active.EnrollmentStatusMRefId
AND M.CarrierMRefId = Active.CarrierMRefId
WHERE 1=1
AND Active.CarrierCode = 'MMM'
AND MES.LastUpdateOnSrc >= '20180712'
AND (CASE ISNULL(Active.EnrollmentStatusMRefId,0) WHEN 0 THEN 0 ELSE 1 END) = 1--Program is CMS ACTIVE 
)   




--Get additional data and make sure member is in an active package
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
      ,N'PGM'    'QuerySource'
	  ,MEM.MPI
      ,MBP.TerminationDate FROM
       (SELECT * 
        FROM CTE 
        WHERE RowNum = 1 ) Stat
       JOIN dbo.Member MEM WITH(NOLOCK)
            ON MEM.MemberRecId = Stat.MemberRecId
       JOIN dbo.MemberHealthCareAdmin HCFA WITH(NOLOCK)
            ON HCFA.MemberRecId = MEM.MemberRecId
	   JOIN dbo.MemberBenefitPackage MBP
			ON MBP.MemberRecId = MEM.MemberRecId
       JOIN dbo.vw_BenefitPackageCurrent Curr
			ON Curr.MemberRecId = MEM.MemberRecId
			AND Curr.CreatedOnSrc = MBP.CreatedOnSrc
       --Current member package is active at least until the end of next month (from getdate())
       JOIN dbo.vw_BenefitPackageActiveAndFuturePlatino Platino WITH(NOLOCK)
            ON Platino.BenefitPackageMRefId = MBP.BenefitPackageMRefId
           AND Platino.CarrierMRefId = MEM.CarrierMRefId
           AND (MBP.TerminationDate IS NULL
                  OR MBP.TerminationDate >= 
                   DATEADD(MM, DATEDIFF(MM, -1, '20180712') + 1, 0) - 1 )
           AND DATEDIFF(dd, '20180712', MBP.EffectiveDate) <= 90

OPTION (maxrecursion 0) --No limit on recursion
