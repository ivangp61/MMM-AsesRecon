USE ASES;

Delete dbo.MemberPCP
Where orgId is null
;

Delete dbo.MemberPCP
Where mpi is null
;

UPDATE dbo.MemberPCP
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.MemberPCP PCP
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON PCP.MemberRecId = MRIC.MemberRecId
;

