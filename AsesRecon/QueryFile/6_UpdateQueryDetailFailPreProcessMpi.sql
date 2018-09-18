
--====================UpdateMpi=======================
Update dbo.QueryDetailFailPreProcess
Set mpi = MRIC.mpi
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.QueryDetailFailPreProcess QDFPP
	On Mric.memberRecIdCons = QDFPP.MemberRecId
;
--====================================================