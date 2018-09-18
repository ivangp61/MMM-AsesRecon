USE ASES;

Delete From dbo.MemberHealthCareAdmin
Where [MemberRecId] In(
							Select MRD.[MemberRecId]
							FROM dbo.MemberHealthCareAdmin MHCA1
								Inner Join dbo.MemberRecIdDelete MRD
								On MRD.MemberRecId = MHCA1.MemberRecId
)
;

Delete From dbo.MemberHealthCareAdminCurrent
Where [MemberRecId] In(
							Select MRD.[MemberRecId]
							FROM dbo.MemberHealthCareAdminCurrent MHCA1
								Inner Join dbo.MemberRecIdDelete MRD
								On MRD.MemberRecId = MHCA1.MemberRecId
)
;

Delete From dbo.Member
Where [MemberRecId] In(
							Select MRD.[MemberRecId]
							FROM dbo.Member M
								Inner Join dbo.MemberRecIdDelete MRD
								On MRD.MemberRecId = M.MemberRecId
)
;


