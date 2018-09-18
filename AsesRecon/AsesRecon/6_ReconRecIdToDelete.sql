USE ASES;

Insert Into dbo.MemberRecIdDelete(MPI, memberRecId)
Select MHCA.MPI, MHCA.MemberRecId
From dbo.MemberHealthCareAdmin MHCA
	Left Join dbo.MemberRecIdCon MRIC
	On MHCA.MemberRecId = MRIC.memberRecIdCons
WHERE 1 = 1
	and MRIC.memberRecIdCons is null
;

Insert Into dbo.MemberRecIdDelete(MPI, memberRecId)
Select MHCA.MPI, MHCA.MemberRecId
From dbo.MemberHealthCareAdminCurrent MHCA
	Left Join dbo.MemberRecIdCon MRIC
	On MHCA.MemberRecId = MRIC.memberRecIdCons
WHERE 1 = 1
	and MRIC.memberRecIdCons is null
	and MHCA.MemberRecId Not in(Select Distinct MRD.MemberRecId From dbo.MemberRecIdDelete MRD)
;

Insert Into dbo.MemberRecIdDelete(MPI, memberRecId)
Select M.MPI, M.MemberRecId
From dbo.Member M
	Left Join dbo.MemberRecIdCon MRIC
	On M.MemberRecId = MRIC.memberRecIdCons
WHERE 1 = 1
	and MRIC.memberRecIdCons is null
	and M.MemberRecId Not in(Select Distinct MRD.MemberRecId From dbo.MemberRecIdDelete MRD)
;


Delete From dbo.MemberRecIdDelete
Where mpi in(
				SELECT Distinct MHCA1.mpi
				FROM dbo.MemberHealthCareAdmin MHCA1
					Left Join dbo.MemberRecIdCon MRIC1
					On MHCA1.MPI = MRIC1.MPI
				WHERE MRIC1.MPI is null
				UNION
				SELECT Distinct M2.mpi
				FROM dbo.Member M2
					Left Join dbo.MemberRecIdCon MRIC2
					On M2.MPI = MRIC2.MPI
				WHERE MRIC2.MPI is null
				UNION
				SELECT Distinct MHCA3.mpi
				FROM dbo.MemberHealthCareAdminCurrent MHCA3
					Left Join dbo.MemberRecIdCon MRIC1
					On MHCA3.MPI = MRIC1.MPI
				WHERE MRIC1.MPI is null
			)
;
