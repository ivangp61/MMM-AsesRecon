--====================================
--1. Reporte MPI nulos.
--2. Reporte de los member rec id que
--   que no hicieron match.Estos son los
--	 que estan en querydetail y no en
--   MRIC.
--3. Totales QueryDetail.
--4. Backup QueryDetail.
--5. Ver si se quedan huerfanos por lo
--	 de FP.
--====================================

USE ASES;

Select Top 100 *
From dbo.QueryDetail 
Where mpi is null
;


Select MPI, Count(Distinct memberrecid)
From dbo.QueryDetail 
--Where mpi is null
Group By MPI
Having Count(Distinct memberrecid) > 1
;

Select Count(Distinct MemberSSN)
From dbo.QueryDetail 
Where mpi is null
Group By MPI
Having Count(Distinct memberrecid) > 1
;



Select Count(*)
From dbo.QueryDetail 
Where mpi is null
;

Select Count(*)
From dbo.QueryDetail QD
;

Select Top 100 *
From dbo.MemberRecIdCon MRIC
Order By mpi
;
	
Select Top 100	QD.MemberRecId,
				MRIC.memberRecIdCons,
				QD.Firstname,
				QD.Lastname,
				QD.MPI
From dbo.QueryDetail QD
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON QD.MemberRecId = MRIC.MemberRecId
Where QD.MPI = '0080019119571'
Order By QD.MPI
;


--UPDATE dbo.QueryDetail
SET MemberRecId = MRIC.MemberRecIdCons
FROM dbo.QueryDetail QD
	INNER JOIN dbo.MemberRecIdCon MRIC
	ON QD.MemberRecId = MRIC.MemberRecId
;

