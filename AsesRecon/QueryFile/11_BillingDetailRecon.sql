UPDATE dbo.BillingDetail
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.BillingDetail BD
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON BD.MemberRecId = MRIC.MemberRecId
Where MRIC.MemberRecIdCons Is Not Null
;