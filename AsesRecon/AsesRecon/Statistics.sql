USE ASES;

SELECT s.object_id, s.name, s.auto_created, COL_NAME(s.object_id, sc.column_id) AS col_name, s.user_created
FROM sys.stats AS s
	INNER JOIN sys.stats_columns AS sc
	ON s.stats_id = s.stats_id AND s.object_id = sc.object_id
WHERE s.object_id = OBJECT_ID('dbo.Member')
	and s.auto_created = 1
;

DBCC SHOW_STATISTICS(N'dbo.Member', _WA_Sys_0000000B_45BE5BA9)
WITH STAT_HEADER;
GO

DBCC SHOW_STATISTICS(N'dbo.Member', _WA_Sys_0000000B_45BE5BA9)
WITH DENSITY_VECTOR;
GO

DBCC SHOW_STATISTICS(N'dbo.Member', _WA_Sys_0000000B_45BE5BA9)
WITH HISTOGRAM;
GO

Select Distinct M.*
From [dbo].[Member] M
Where Convert(Varchar, m.JobLoadDate, 112) = '20180428'
	and MPI Is Not Null
;
--Corrida del 28 de abril de 2018: 1322 records
--con MPI: 765

Select Top 100 *
--Select Distinct m.JobLoadDate
From [dbo].[Member] M
;

Select Top 100 *
From [dbo].[QueryResponseDetail]
;

Select Top 100 *
From dbo.MemberBenefitPackage
;


