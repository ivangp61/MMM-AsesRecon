UPDATE dbo.EnrollmentDetail
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.EnrollmentDetail ED
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON ED.MemberRecId = MRIC.MemberRecId
;