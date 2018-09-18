USE ASES;

UPDATE dbo.MemberEnrollmentStatus
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.MemberEnrollmentStatus MES
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MES.MemberRecId = MRIC.MemberRecId
;

DELETE dbo.MemberEnrollmentStatus
FROM dbo.MemberEnrollmentStatus MES1
	INNER JOIN (
					SELECT MES.SORId, MES.CreatedOnSrc, COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) AS MemberEnrollmentStatusRecId
					FROM dbo.MemberEnrollmentStatus MES
						INNER JOIN dbo.MemberRecIdCon MRIC
						ON MES.MemberRecId = MRIC.MemberRecId
					Group By MES.SORId, MES.CreatedOnSrc
					Having COUNT(DISTINCT MES.MemberEnrollmentStatusRecId) > 1
			   ) AS DUP
	ON MES1.SORId = DUP.SORId AND MES1.CreatedOnSrc = DUP.CreatedOnSrc
WHERE MES1.OrgId IS NULL
;

DELETE dbo.MemberEnrollmentStatus
WHERE MPI IS NULL
;
