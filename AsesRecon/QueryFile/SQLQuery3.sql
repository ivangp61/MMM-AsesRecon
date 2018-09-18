Select *
From dbo.Member M
Where M.MemberRecId = '815AFDA7-349A-41F5-8BC7-0490E95DD10B'
;


Select m.*
FROM dbo.BillingDetail BD
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON BD.MemberRecId = MRIC.MemberRecId
	Inner Join dbo.Member M
	On BD.MemberRecId = M.MemberRecId
Where MRIC.MemberRecIdCons Is Null
;
