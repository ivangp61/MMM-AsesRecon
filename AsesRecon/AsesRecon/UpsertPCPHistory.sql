MERGE 	dbo.MemberPCP   tgt
USING (
    SELECT  MemberRecId
	   ,SUBSTRING(ProviderId,1,10) 'ProviderId'
	   ,EffectiveDate
	   ,TerminationDate
	   ,SORId
	   ,CreatedBySrc
	   ,CreatedOnSrc
	   ,LastUpdateBySrc
	   ,LastUpdateOnSrc
    FROM  stg.MemberTgtPCPHistory
    WHERE 1=1 
)		    src
ON (
    src.MemberRecId = tgt.MemberRecId 
	   And src.SORId = tgt.SORId
	   And src.CreatedOnSrc = tgt.CreatedOnSrc
)
WHEN MATCHED THEN
UPDATE 
    SET  tgt.EffectiveDate = src.EffectiveDate 
	,tgt.TerminationDate = src.TerminationDate		  
	,tgt.LastUpdateBySrc = src.LastUpdateBySrc
	,tgt.LastUpdateOnSrc = src.LastUpdateOnSrc
	,tgt.JobLoadDate = GETDATE()
	,tgt.ProviderId = src.ProviderId
WHEN NOT MATCHED THEN
INSERT (
			   MemberRecId
		      ,ProviderId
		      ,EffectiveDate
		      ,TerminationDate
		      ,SORId
			 ,CreatedBySrc
			 ,CreatedOnSrc
			 ,LastUpdateBySrc
			 ,LastUpdateOnSrc) 
VALUES (
			  src.MemberRecId
		      ,src.ProviderId
		      ,src.EffectiveDate
		      ,src.TerminationDate
		      ,src.SORId
			 ,src.CreatedBySrc
			 ,src.CreatedOnSrc
			 ,src.LastUpdateBySrc
			 ,src.LastUpdateOnSrc
);