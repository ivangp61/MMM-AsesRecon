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

--010073670

Select *
From dbo.QueryDetail QD
Where QD.MemberRecId = 'A116C9C8-7701-44BC-9281-E768CDD376A0'
