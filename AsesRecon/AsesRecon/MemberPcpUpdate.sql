--================STEPS=======================
--Update dbo.MemberPCP
	Set mpi = MM.MPI
From [dbo].[MPIMembership] MM
	Inner Join dbo.Member M
	On MM.mpi = M.mpi
	Inner Join dbo.MemberPCP PCP
	On PCP.MemberRecId = M.MemberRecId
;--840,505: Sin el cambio
--903,585:Con el cambio

--Update dbo.MemberPCP
	SET OrgId = MEP.ORG_ID
From dbo.MemberPCP PCP
	Inner Join dbo.Member M
	On m.MemberRecId = PCP.MemberRecId
	Inner Join [dbo].[MemberExtrPCP] MEP
	On PCP.MPI = MEP.MPI
		and MEP.CreatedOn = PCP.CreatedOnSrc
		and MEP.MPI is not null
;--884,444

--Update dbo.MemberPCP
	SET OrgId = MEP.ORG_ID
From dbo.MemberPCP PCP
	Inner Join dbo.Member M
	On m.MemberRecId = PCP.MemberRecId
	Inner Join [dbo].[MemberExtrPCP] MEP
	On PCP.MPI = MEP.MPI
		and PCP.SORID = MEP.PROVIDER_ID
		and PCP.EffectiveDate = MEP.EFF_DATE
		and ISNULL(PCP.TerminationDate,GETDATE()) = ISNULL(MEP.TERM_DATE, GETDATE())
		and MEP.MPI is not null
		and PCP.OrgId is null
;

--================STEPS=======================

Select Top 100 *
From [dbo].[MemberPCP] PCP
Where 1 = 1
	and PCP.MPI is not null
	and CreatedOnSrc = '2014-11-21 01:52:00.000'
;

Select Top 100 *
From [dbo].[MemberExtrPCP]
;

--Truncate Table [dbo].[MemberExtrPCP];
--Truncate Table [dbo].[MemberExtrPCPError];

Select Count(*)
From [dbo].[MemberPCP]
Where mpi is null
;--1705593--A eliminarse de la membresia cerca de un millon de records por afiliados sin MPI que no son parte de la membresia.

Select Count(*)
From [dbo].[MPIMembership] MM
	Inner Join dbo.MemberPCP PCP
	On PCP.MemberRecId = MM.MemberRecId
Where PCP.mpi is null
;--840505--Este es mi numero porque son los afiliados con MPI que tienen su MPI en la tabla de PCP en nulo, pero
--que son parte de la membresia que terminaria dentro de esta tabla.

Select Top 100 *
From [dbo].[MemberExtrPCP]

Select Distinct Top 100 
--memberRecId
*
From dbo.MemberPCP
Where 1 = 1
	and mpi in('0080007402235')--'0080021776807',
	--and OrgId = 'H4003'
;

--Oracle MP MMM: 627649
--Oracle MP PMC: 627649

--Update dbo.MemberPCP
	Set OrgId = MEES.ORG_ID
From dbo.MemberPCP PCP
	Inner Join dbo.Member M
	On m.MemberRecId = PCP.MemberRecId
	Inner Join [XRef].[Carrier] C
	On	M.CarrierMRefId = C.CarrierMRefId
	Inner Join dbo.MemberExtrEnrollmentStatus MEES
	On MES.SORId = MEES.status_id 
		and MEES.ORG_ID = C.ExternalValue 
		and MES.MPI is not null
;

Select Top 100 *
From [dbo].[MemberExtrPCP]
;


Select Count(*)
From dbo.MemberPCP PCP
	Inner Join dbo.Member M
	On m.MemberRecId = PCP.MemberRecId
	Inner Join [dbo].[MemberExtrPCP] MEP
	On PCP.MPI = MEP.MPI
		and MEP.CreatedOn = PCP.CreatedOnSrc
		and MEP.MPI is not null		
;--822332
--840505
--Faltan: 18173
--Ver si lo hago por sorid, mpi y effectiveDate donde sea nulo org_id, pero tenga MPI:
	--1. Hay records a añadirse, cuidado con estos. Validar con los 600 afiliados de Bezabeth:
	--2. Intentar hacer matching por los tres campos señalados.
--====================RECON=========================

Select *
From dbo.MemberPCP PCP
Where 1 = 1
	and PCP.MPI is not null
	and PCP.OrgId is not null
;

Select TOP 100 MEP.*
From [dbo].[MemberExtrPCP] MEP
Where MEP.MPI IN('0080028305625')
EXCEPT
Select MEP.*
From dbo.MemberPCP PCP
	Inner Join dbo.Member M
	On m.MemberRecId = PCP.MemberRecId
	Inner Join [dbo].[MemberExtrPCP] MEP
	On MEP.CreatedOn = PCP.CreatedOnSrc
		and PCP.MPI = MEP.MPI
		and MEP.MPI is not null
;

Select MEP.*
From dbo.MemberPCP PCP
	Inner Join dbo.Member M
	On m.MemberRecId = PCP.MemberRecId
	Inner Join [dbo].[MemberExtrPCP] MEP
	On MEP.CreatedOn = PCP.CreatedOnSrc
		and PCP.MPI = MEP.MPI
		and MEP.MPI is not null
;
--=====================SECOND_UPDATE_ANALYSIS==============
Select MEP.*
From dbo.MemberPCP PCP
	Inner Join dbo.Member M
	On m.MemberRecId = PCP.MemberRecId
	Inner Join [dbo].[MemberExtrPCP] MEP
	On MEP.CreatedOn = PCP.CreatedOnSrc
		and PCP.MPI = MEP.MPI
		and MEP.MPI is not null
		and PCP.OrgId is null
;

Select MEP.*, PCP.orgId,PCP.EffectiveDate, PCP.SORId
From dbo.MemberPCP PCP
	Inner Join dbo.Member M
	On m.MemberRecId = PCP.MemberRecId
	Inner Join [dbo].[MemberExtrPCP] MEP
	On PCP.MPI = MEP.MPI
		and PCP.SORID = MEP.PROVIDER_ID
		and PCP.EffectiveDate = MEP.EFF_DATE--6817
		and ISNULL(PCP.TerminationDate,GETDATE()) = ISNULL(MEP.TERM_DATE, GETDATE())
		and MEP.MPI is not null
		and PCP.OrgId is null
;

--Update dbo.MemberPCP
	SET OrgId = MEP.ORG_ID
From dbo.MemberPCP PCP
	Inner Join dbo.Member M
	On m.MemberRecId = PCP.MemberRecId
	Inner Join [dbo].[MemberExtrPCP] MEP
	On PCP.MPI = MEP.MPI
		and PCP.SORID = MEP.PROVIDER_ID
		and PCP.EffectiveDate = MEP.EFF_DATE
		and ISNULL(PCP.TerminationDate,GETDATE()) = ISNULL(MEP.TERM_DATE, GETDATE())
		and MEP.MPI is not null
		and PCP.OrgId is null
;

--=====================SECOND_UPDATE_ANALYSIS==============

Select PCP.*
From dbo.MemberPCP PCP
Where mpi IN('0080028305625')
;

SELECT *
FROM dbo.Member M
WHERE 1 = 1
	--and M.MemberRecId IN('AB243C63-D5FD-4C7A-A67E-98D1F6AEC7FB','C1025A23-77D0-4982-8917-686132397BCD')
	and SORId = 'N00033112081'


Select TOP 100 MEP.*
From [dbo].[MemberExtrPCP] MEP
Where MEP.MPI IN('0080028305625')
;

--====================RECON=========================
Select Count(*)
From
(
	Select MEP.*
	From [dbo].[MemberExtrPCP] MEP
	--Where MEP.MPI IN('0080028305625')
	EXCEPT
	Select MEP.*
	From dbo.MemberPCP PCP
		Inner Join dbo.Member M
		On m.MemberRecId = PCP.MemberRecId
		Inner Join [dbo].[MemberExtrPCP] MEP
		On MEP.CreatedOn = PCP.CreatedOnSrc
			and PCP.MPI = MEP.MPI
			--Commented: 18855
			--Uncommented: 20228
			and MEP.MPI is not null
) AS R;




--======================MODEL==================
Select TOP 100 PCP.*, MEP.ORG_ID, MEP.NAME_ID
From dbo.MemberPCP PCP
	Inner Join dbo.Member M
	On m.MemberRecId = PCP.MemberRecId
	Inner Join [dbo].[MemberExtrPCP] MEP
	On PCP.MPI = MEP.MPI
		and MEP.CreatedOn = PCP.CreatedOnSrc
		and MEP.MPI is not null
;
--======================MODEL==================

--=================COMPARE========================
--src.MPI = tgt.MPI
--And src.CreatedOn = tgt.CreatedOnSrc
--=================COMPARE=========================