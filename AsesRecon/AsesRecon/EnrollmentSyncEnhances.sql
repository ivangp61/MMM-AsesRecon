Select Count(*) as count
From dbo.MemberExtrEnrollmentStatus
--Where org_id is null
;--1442841

Select Top 100 *
From dbo.MemberExtrEnrollmentStatus
--Where org_id is null
;

Select Top 100 *
From [XRef].[Carrier]
;


Select *
From EnterpriseHub.XRef.Company C
;

Select Top 100 *
From dbo.MemberEnrollmentStatus MES

Select *
From dbo.Member M
Where M.MemberRecId = '09943323-A597-4732-8598-A95194B4F6EC'
;

Select Top 100 MES.MemberRecId, MES.SORId, MES.MPI, MES.OrgId, MES.EnrollmentStatusMRefId
From dbo.MemberEnrollmentStatus MES
	Inner Join dbo.Member M
	On m.MemberRecId = MES.MemberRecId
	Inner Join [XRef].[Carrier] C
	On	M.CarrierMRefId = M.CarrierMRefId
	Inner Join dbo.MemberExtrEnrollmentStatus MEES
	On MES.SORId = MEES.status_id and MEES.ORG_ID = C.ExternalValue
;

Select Top 100 *
From [dbo].[MPIMembership]

Select Top 100 MES.*, MM.MPI AS mmMpi
From [dbo].[MPIMembership] MM
	Inner Join dbo.MemberEnrollmentStatus MES
	On MES.MemberRecId = MM.MemberRecId
;


Select mes.Carrier,
mes.CreatedBySrc,
mes.CreatedOnSrc,
mes.EffectiveDate,
mes.EnrollmentStatusMRefId,
mes.JobLoadDate
From dbo.MemberEnrollmentStatus MES
Where mes.CreatedBySrc


Select mm.memberrecid,
mm.mpi
From [dbo].[MPIMembership] MM	
;

Select Top 100 *
From [dbo].[MPIMembership]

Select Top 100 *
From dbo.MemberEnrollmentStatus
;

Select Count(*)
From dbo.MemberEnrollmentStatus
;

Select Count(*)
From dbo.MemberEnrollmentStatus
Where mpi is null
;

Select Top 100 *
From dbo.MemberEnrollmentStatus
;


Select Count(*)
From dbo.MemberEnrollmentStatus
Where mpi is not null
;--3802642

Select Count(*)
From dbo.MemberExtrEnrollmentStatus
;--1442841

Select MemberEnrollmentStatusRecId, MemberRecId, EnrollmentStatusMRefId, EffectiveDate, TerminationDate, SORId, CreatedBySrc, CreatedOnSrc, LastUpdateBySrc, LastUpdateOnSrc, JobLoadDate, MPI, OrgId
From dbo.MemberEnrollmentStatus E
;--1442841

Select STATUS_ID, NAME_ID, MPI, ORG_ID, STATUS, START_DATE, END_DATE, CREATEDBY, CREATEDON, LASTUPDATEBY, LASTUPDATEON
From [dbo].[MemberExtrEnrollmentStatus]
;

--==============
--Update dbo.MemberEnrollmentStatus
	Set mpi = MM.MPI
From [dbo].[MPIMembership] MM
	Inner Join dbo.MemberEnrollmentStatus MES
	On MES.MemberRecId = MM.MemberRecId
;--00:02:24
--==============

--Update dbo.MemberEnrollmentStatus
Set OrgId = MEES.ORG_ID
From dbo.MemberEnrollmentStatus MES
	Inner Join dbo.Member M
	On m.MemberRecId = MES.MemberRecId
	Inner Join [XRef].[Carrier] C
	On	M.CarrierMRefId = M.CarrierMRefId
	Inner Join dbo.MemberExtrEnrollmentStatus MEES
	On MES.SORId = MEES.status_id 
		and MEES.ORG_ID = C.ExternalValue 
		and MES.MPI is not null
		--and MES.CreatedOnSrc = MEES.CREATEDON
;--38 segundos--1443850 records

Select Top 100 MES.MemberRecId, M.CarrierMRefId, C.ExternalValue, MES.SORId, MES.MPI, MES.OrgId, MES.EnrollmentStatusMRefId,
MES.CreatedOnSrc, MEES.CREATEDON
, MEES.STATUS_ID
, MEES.NAME_ID
From dbo.MemberEnrollmentStatus MES
	Inner Join dbo.Member M
	On m.MemberRecId = MES.MemberRecId
	Inner Join [XRef].[Carrier] C
	On	M.CarrierMRefId = M.CarrierMRefId
	Inner Join dbo.MemberExtrEnrollmentStatus MEES
	On MES.SORId = MEES.status_id and MEES.ORG_ID = C.ExternalValue
Where MES.MPI is not null
;



Select Top 100 MES.MemberRecId, M.CarrierMRefId, C.ExternalValue, MES.SORId, MES.MPI, MES.OrgId, MES.EnrollmentStatusMRefId
, MEES.STATUS_ID
, MEES.NAME_ID
From dbo.MemberEnrollmentStatus MES
	Inner Join dbo.Member M
	On m.MemberRecId = MES.MemberRecId
	Inner Join [XRef].[Carrier] C
	On	M.CarrierMRefId = M.CarrierMRefId
	Inner Join dbo.MemberExtrEnrollmentStatus MEES
	On MES.SORId = MEES.status_id and MEES.ORG_ID = C.ExternalValue
Where MES.MPI is not null
;

