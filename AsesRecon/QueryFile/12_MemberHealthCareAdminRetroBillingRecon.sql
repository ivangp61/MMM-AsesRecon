UPDATE dbo.MemberHealthCareAdminRetroBilling
SET MemberRecId = MRIC.MemberRecIdCons
From dbo.MemberHealthCareAdminRetroBilling MHCARB
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON MHCARB.MemberRecId = MRIC.MemberRecId
Where MRIC.MemberRecIdCons Is Not Null
;
