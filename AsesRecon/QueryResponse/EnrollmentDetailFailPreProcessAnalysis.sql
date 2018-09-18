--=============================================
--1. Validar MPI.
--2. Consolidar memberRecId
--3. Validar SSN.
--4. 
--=============================================


Select Top 100 *
From dbo.EnrollmentDetailFailPreProcess EM
;


Select Count(*)
From dbo.EnrollmentDetailFailPreProcess
;--9,966,735


Select *
From dbo.EnrollmentDetailFailPreProcess EM
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;

Select Count(*)
From dbo.EnrollmentDetailFailPreProcess EM
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--11,764: No Update
--2,999: Update


Select Count(Distinct EM.MemberSSN)
From dbo.EnrollmentDetailFailPreProcess EM
Where mpi is null
	or Rtrim(Ltrim(mpi))  = ''
;--4,812: No update
--755: Update


Select Count(Distinct EM.MemberSSN)
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.EnrollmentDetailFailPreProcess EM
	On M.SocialSecurity = EM.MemberSSN
Where EM.MPI is null
	or Rtrim(Ltrim(EM.MPI))  = ''
;--4,057

--====================UpdateMpi=======================
--Update dbo.EnrollmentDetailFailPreProcess
Set mpi = MRIC.mpi
From dbo.MemberRecIdCon MRIC
	Inner Join dbo.Member M
	On Mric.memberRecId = M.MemberRecId
	Inner Join dbo.EnrollmentDetailFailPreProcess QUDQ
	On M.SocialSecurity = QUDQ.MemberSSN
;

--UPDATE dbo.EnrollmentDetailFailPreProcess
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.EnrollmentDetailFailPreProcess QD
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON QD.MemberRecId = MRIC.MemberRecId
;
--====================================================

Select *
From dbo.EnrollmentDetailFailPreProcess m
Where m.mpi = '0080026200561'
;

