UPDATE dbo.EnrollmentDetailFailPreProcess
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.EnrollmentDetailFailPreProcess QD
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON QD.MemberRecId = MRIC.MemberRecId
;
