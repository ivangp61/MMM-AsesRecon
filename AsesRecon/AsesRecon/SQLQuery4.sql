CREATE TABLE [dbo].[MemberEnrollmentStatusRef](
	[MemberEnrollmentStatusRecId] [uniqueidentifier],
	[MemberRecId] [uniqueidentifier]
	)
;



Select *
From [dbo].[MemberEnrollmentStatusRef]
;


Select Count(Distinct [MemberRecId])
From [dbo].[MemberEnrollmentStatusRef]
;

Select Count(Distinct [MemberRecId])
From dbo.MemberEnrollmentStatus MES
;

Select Count(Distinct MPI)
From dbo.MemberEnrollmentStatus MES
;

Select Count(Distinct [MemberRecId])
From [dbo].[MemberEnrollmentStatusRef]
;



Select Count(*)
From [dbo].[MemberEnrollmentStatusRef] MEES
	Inner Join dbo.MemberEnrollmentStatus MES
	On MEES.MemberEnrollmentStatusRecId = MES.MemberEnrollmentStatusRecId
;

Select Count(Distinct MEES.MemberRecId)
From [dbo].[MemberEnrollmentStatusRef] MEES
	Inner Join dbo.MemberEnrollmentStatus MES
	On MEES.MemberEnrollmentStatusRecId = MES.MemberEnrollmentStatusRecId
;


Select *
From [dbo].[MemberEnrollmentStatusRef] MEES
	Inner Join dbo.MemberEnrollmentStatus MES
	On MEES.MemberEnrollmentStatusRecId = MES.MemberEnrollmentStatusRecId
;

--Update dbo.MemberEnrollmentStatus
Set MemberRecId = MEES.MemberRecId
From [dbo].[MemberEnrollmentStatusRef] MEES
	Inner Join dbo.MemberEnrollmentStatus MES
	On MEES.MemberEnrollmentStatusRecId = MES.MemberEnrollmentStatusRecId
;
