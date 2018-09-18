Select Distinct [MemberEnrollmentStatusRecId],
				[MemberRecId]
From dbo.MemberEnrollmentStatus MES
;

Select Count(Distinct [MemberRecId])
From dbo.MemberEnrollmentStatus MES


Select Top 100 *
From dbo.QueryDetail 
;


Select Count(*)
From dbo.QueryDetail 
;



Select Count(*)
From dbo.QueryDetailFailPreProcess
;

Select Top 100 *
From dbo.QueryDetailFailPreProcess
;



Select Top 100 *
From failed.PreProcessStatusCode
;

Select Count(*)
From dbo.MemberEnrollmentStatus MES
;

Select Top 100 *
From dbo.QueryUserDefinedQueue Q
;

Select Count(*)
From dbo.QueryUserDefinedQueue Q
;


Select Count(*)
From dbo.QueryUserDefinedQueue
;

Select Top 100 *
From dbo.QueryUserDefinedQueue
;

--==================Backup_Tables=========
Select Top 100 *
From [dbo].[QueryUserDefinedQueueBkp]
;

Select Count(*)
From [dbo].[QueryUserDefinedQueueBkp]
;

Select Count(*)
From [dbo].[QueryResponseDetailBkp]
;
Select Count(*)
From [dbo].[QueryDetailFailPreProcessBkp]
;

Select Count(*)
From [dbo].[QueryDetailBkp]
;
--========================================

