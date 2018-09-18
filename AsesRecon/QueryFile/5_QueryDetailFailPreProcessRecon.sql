Update dbo.QueryDetailFailPreProcess
Set memberRecId = MRIC.memberRecIdCons
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.QueryDetailFailPreProcess QDFPP
	On Mric.memberRecId = QDFPP.MemberRecId
;
