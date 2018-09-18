--=================MEMBER_KEYS==========
USE EnterpriseHub;

SELECT TOP 100 M.MemberRecId, M.FirstName, M.JobLoadDate, xm.ExternalValue, XM.ExternalTypeMRefId,ET.Code, ET.[Desc], m.CreationDate, m.ModificationDate
FROM MemberCompany M
	INNER JOIN Xref.Member XM
	ON M.MemberRecId = XM.MemberRecId AND M.CompanyMRefId = XM.CompanyMRefId
	INNER JOIN mref.ExternalType ET
	ON XM.ExternalTypeMRefId = ET.ExternalTypeMRefId --AND ET.Code = 'AVETA'--ET.Code = 'MP'--
WHERE 1 = 1
	AND M.MemberRecId  IN(
								SELECT M.MemberRecId
								FROM MemberCompany M
									INNER JOIN Xref.Member XM
									ON M.MemberRecId = XM.MemberRecId AND M.CompanyMRefId = XM.CompanyMRefId
									INNER JOIN mref.ExternalType ET
									ON XM.ExternalTypeMRefId = ET.ExternalTypeMRefId --AND ET.Code = 'MP'--ET.Code = 'AVETA'--
								WHERE 1 = 1
									AND xm.ExternalValue IN('030236315')
									--and M.MemberRecId = 239212
							)
;
--=================MEMBER_KEYS==========
--030047445
--030245070
--030119370




SELECT ET.Code,XM.*
FROM MemberCompany M
	INNER JOIN Xref.Member XM
	ON M.MemberRecId = XM.MemberRecId AND M.CompanyMRefId = XM.CompanyMRefId
	INNER JOIN mref.ExternalType ET
	ON XM.ExternalTypeMRefId = ET.ExternalTypeMRefId --AND ET.Code = 'MP'--ET.Code = 'AVETA'--
WHERE 1 = 1
	AND xm.ExternalValue IN('0080021776807')
	--and M.MemberRecId = 41207


Select *
From dbo.HcfaArchTrr
Where MemberRecId = 380272
;


Select Count(*),
MRIC.MPI,
QD.MPI
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.QueryDetail QD
	On Mric.memberRecId = QD.MemberRecId
Where QD.MPI is null;



