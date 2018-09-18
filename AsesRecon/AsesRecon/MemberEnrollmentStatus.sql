Select Count(*) as count
From dbo.MemberExtrEnrollmentStatus
--Where org_id is null
;--1442841

Select Top 100 *
From dbo.MemberExtrEnrollmentStatus MEES
	Inner Join dbo.MemberEnrollmentStatus MES
	On MEES.
--Where org_id is null
;

Select Count(*)
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
;

Update dbo.MemberPCP
	Set mpi = MM.MPI
From [dbo].[MPIMembership] MM
	Inner Join dbo.Member M
	On MM.mpi = M.MPI
	Inner Join dbo.MemberPCP PCP
	On PCP.MemberRecId = M.MemberRecId
;

Select *
From dbo.Member M
Where 1 = 1
	--and M.MemberRecId in('215AA1D1-5831-4BE9-951F-0DC3B5AC0BD5', 'F795ACF1-D77A-4683-A15F-7061EBE58569')--
	and mpi in('0080007402235','0080021776807')--
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

Select Distinct Top 100 
--memberRecId
*
From dbo.MemberEnrollmentStatus
Where 1 = 1
	and mpi in('0080021776807')--,'0080007402235'
	and OrgId = 'H4003'
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
	Inner Join dbo.Member M
	On MM.name_id = M.SORId
	Inner Join dbo.MemberEnrollmentStatus MES
	On MES.MemberRecId = M.MemberRecId
;--00:02:24


--Update dbo.MemberEnrollmentStatus
Set OrgId = MEES.ORG_ID
From dbo.MemberEnrollmentStatus MES
	Inner Join dbo.Member M
	On m.MemberRecId = MES.MemberRecId
	Inner Join [XRef].[Carrier] C
	On	M.CarrierMRefId = C.CarrierMRefId
	Inner Join dbo.MemberExtrEnrollmentStatus MEES
	On MES.SORId = MEES.status_id
		and MEES.ORG_ID = C.ExternalValue 
		and MES.MPI is not null
;--38 segundos--1443850 records
--==============



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




SELECT *
FROM dbo.MemberEnrollmentStatus
;
-- BUSCAR EL CREATEDON DE HCFA_DATE PARA ACTUALIZAR EL CARRIER DE ENROLLMENT STATUS

Select *
From dbo.Member 
Where SORId = 
;

Select *
From [dbo].[MPIMembership]
Where org_id = 'S0043'
;

