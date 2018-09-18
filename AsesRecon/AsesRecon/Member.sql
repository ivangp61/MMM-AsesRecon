Use ASES;

Select Top 100 *
From dbo.Member
Where mpi ='0080002366737'
--mpi is null
;


Select Count(Distinct mpi)
From dbo.Member
Where mpi is null
;--272,749


Select SORId, Count(Distinct MemberRecId) As recIdCount
From dbo.Member
Group By SORId
Having Count(Distinct MemberRecId) > 1
;

Select mpi, Count(Distinct MemberRecId) As recIdCount
From dbo.Member
Group By mpi
Having Count(Distinct MemberRecId) > 1
;


Select mpi, Count(Distinct MemberRecId) As recIdCount
From dbo.Member
Group By mpi
Having Count(Distinct MemberRecId) > 1
;


Select Sum(recIdCount)
From (
		Select SORId, Count(Distinct MemberRecId) As recIdCount
		From dbo.Member
		Group By SORId
		Having Count(Distinct MemberRecId) > 1
	 ) as d
;


Select Sum(recIdCount)
From (
			Select mpi, Count(Distinct MemberRecId) As recIdCount
			From dbo.Member
			Group By mpi
			Having Count(Distinct MemberRecId) > 1
) as d
;


Select *
From dbo.Member M
Where M.SORId = 'N00044327040'--'N00023236833'--
;


Select Top 100 *
From stg.MemberSyncError M
Where M.SORId = 'N00044327040'--'N00023236833'--
;


Select SORId, Count(Distinct MemberRecId) As recIdCount
From dbo.Member
Where sorid = 'N00374498295'
Group By SORId
Having Count(Distinct MemberRecId) > 1
Order By SORId
;



--Insert Into dbo.MemberRecIdDelete(MPI, memberRecId)
Select M.MPI, M.MemberRecId
From dbo.Member M
	Left Join dbo.MemberRecIdCon MRIC
	On M.MemberRecId = MRIC.memberRecIdCons
WHERE 1 = 1
	and MRIC.memberRecIdCons is null
	and M.MemberRecId Not in(Select Distinct MRD.MemberRecId From dbo.MemberRecIdDelete MRD)
	--and sorid = 'N00374498295'
;


Select *
From dbo.MemberRecIdCon MRIC
--Where 
;


--Delete From dbo.MemberRecIdDelete
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


SELECT Distinct M2.mpi
FROM dbo.Member M2
	Left Join dbo.MemberRecIdCon MRIC2
	On M2.MPI = MRIC2.MPI
WHERE MRIC2.MPI is null


Select M.*
From dbo.Member M
	Inner Join (
					Select SORId, Count(Distinct MemberRecId) As recIdCount
					From dbo.Member
					--Where sorid = 'N00374498295'
					Group By SORId
					Having Count(Distinct MemberRecId) > 1	
	) As DUP
	On M.SORId = DUP.SORId
	Inner Join dbo.MemberRecIdCon MRIC
	On M.MPI = MRIC.MPI
Where 1 = 1
	and M.mpi ='0080021776807'
;


Select SORId, Count(Distinct MemberRecId) As recIdCount
From dbo.Member
Where sorid = 'N00374498295'
Group By SORId
Having Count(Distinct MemberRecId) > 1
Order By SORId
;


Select Top 100 *
From dbo.Member
Where mpi ='0080012709787'
--mpi is null
;


Select Top 100*
From dbo.MemberRecIdCon MRIC
Where mpi ='0080012709787'
;

Select Distinct MM.MPI, M.SORId, M.MemberRecId, M.CarrierMRefId
From dbo.MPIMembership MM
	INNER JOIN dbo.Member M
	On MM.MPI = M.MPI
Where M.mpi ='0080012709787'
;

Select *
From dbo.MPIMembership MM
Where MM.mpi ='0080012709787'
;

Select *
From dbo.MemberBenefitPackage MBP
Where MBP.MPI = '0080012709787'
;

Select *
From EnterpriseHub.dbo.MemberIndicator MI
Where MI.IndicatorRecId = 24
	and 
;

Select Top 100*
From dbo.MemberRecIdCon MRIC
Where mpi ='0080021776807'
;


Select Top 100 *
From [dbo].[MemberBenefitPackageConsolidation]
Where mpi = '0080021776807'
;


--Insert Into dbo.MemberRecIdDelete(MPI, memberRecId)
Select M.MPI, M.MemberRecId
From dbo.Member M
	Left Join dbo.MemberRecIdCon MRIC
	On M.MemberRecId = MRIC.memberRecIdCons
WHERE 1 = 1
	and MRIC.memberRecIdCons is null
	and M.MemberRecId Not in(Select Distinct MRD.MemberRecId From dbo.MemberRecIdDelete MRD)
;


--======================Diff==================
Select Distinct M.MPI
From (
		Select M.MPI, M.SORId, Count(Distinct M.MemberRecId) As recIdCount
		From dbo.Member M
			Left Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
		Where 1 = 1
			and MM.MPI is null
			--and sorid = 'N00374498295'
		Group By M.MPI, M.SORId
		Having Count(Distinct M.MemberRecId) > 1
		) AS D
		Inner Join dbo.Member M
		On M.MPI = D.MPI
;
--======================Diff==================

--1. Buscar company
--Drop dbo.MemberConsNoMPMpi;

Create Table dbo.MemberConsNoMPMpi
(
	mpi nvarchar(13),
	memberRecId uniqueidentifier,
	carrierMrefId int
)
--Insert into dbo.MemberConsNoMPMpi(mpi, memberRecId, carrierMrefId)
Select Distinct M.MPI, M.MemberRecId, M.CarrierMRefId--, MBP.EffectiveDate, MBP.TerminationDate
From (
		Select M.MPI, M.SORId, Count(Distinct M.MemberRecId) As recIdCount
		From dbo.Member M
			Left Join dbo.MPIMembership MM
			On M.MPI = MM.MPI
		Where 1 = 1
			and MM.MPI is null
			--and sorid = 'N00374498295'
		Group By M.MPI, M.SORId
		Having Count(Distinct M.MemberRecId) > 1
		) AS D
Inner Join dbo.Member M
On M.MPI = D.MPI
Inner Join dbo.MemberBenefitPackage MBP
On M.MemberRecId = MBP.MemberRecId
Where MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)--249
--2. Buscar vigencia
Select MBP.MemberRecId,Max(IsNull(MBP.LastUpdateOnSrc, MBP.CreatedOnSrc)) AS maxEligibility--MBP.EffectiveDate, MBP.TerminationDate
From dbo.MemberBenefitPackage MBP
	Inner Join 
	(
		Select Distinct M.MPI, M.MemberRecId--, M.CarrierMRefId--, MBP.EffectiveDate, MBP.TerminationDate
		From (
				Select M.MPI, M.SORId, Count(Distinct M.MemberRecId) As recIdCount
				From dbo.Member M
					Left Join dbo.MPIMembership MM
					On M.MPI = MM.MPI
				Where 1 = 1
					and MM.MPI is null
					--and sorid = 'N00374498295'
				Group By M.MPI, M.SORId
				Having Count(Distinct M.MemberRecId) > 1
				) AS D
		Inner Join dbo.Member M
		On M.MPI = D.MPI
		Inner Join dbo.MemberBenefitPackage MBP
		On M.MemberRecId = MBP.MemberRecId
		Where MBP.EffectiveDate <> IsNull(MBP.TerminationDate, MBP.EffectiveDate + 1)--249
	)AS M
	On MBP.MemberRecId = M.MemberRecId
Group By MBP.MemberRecId
;


--Insert Into dbo.MemberRecIdCon(mpi, NAME_ID, memberRecId, carrierMrefId)
Select Distinct MM.MPI, M.SORId, M.MemberRecId, M.CarrierMRefId
From dbo.MPIMembership MM
	INNER JOIN dbo.Member M
	On MM.MPI = M.MPI
;


Select Top 100 *
From dbo.MPIMembership
;



Select mpi, Count(Distinct memberrecid)
From dbo.MPIMembership
Group By mpi
Having Count(Distinct memberrecid) > 1
;
