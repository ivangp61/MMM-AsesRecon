UPDATE dbo.QueryDetail
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.QueryDetail QD
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON QD.MemberRecId = MRIC.MemberRecId
;

