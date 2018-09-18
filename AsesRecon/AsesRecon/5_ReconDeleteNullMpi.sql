USE ASES;

Delete From dbo.MemberHealthCareAdmin
WHERE MPI is null
;

Delete From dbo.MemberHealthCareAdminCurrent
WHERE MPI is null
;

Delete From dbo.Member
WHERE MPI is null
;