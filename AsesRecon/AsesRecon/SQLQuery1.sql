SELECT  
   Q.QueryUserDefinedQueueRecId
  ,Q.MemberRecId
  ,Q.Firstname
  ,Q.Lastname
  ,Q.SecLastname
  ,Q.GenderMRefId
  ,Q.BirthDate
  ,Q.MemberSSN
  ,Q.SORId
  ,Q.CarrierMRefId
  ,Q.AsesRegion
  ,Q.CarrierEffectiveDate
  ,Q.QuerySource
  ,Q.MPI
  ,GETDATE( ) 'CarrierProcessDate'
  , Q.CarrierFutureEffectiveDate FROM
   dbo.QueryUserDefinedQueue Q
   JOIN MRef.Carrier carrier
        ON carrier.CarrierMRefId = Q.CarrierMRefId
WHERE 1 = 1
And  carrier.CarrierCode = 'MMM'
AND  NOT EXISTS (SELECT 1
				 FROM stg.QueryDetailFinal QDF
				 WHERE 1=1
				 AND Q.MemberRecId = QDF.MemberRecId
				 AND Q.CarrierEffectiveDate = QDF.CarrierEffectiveDate)
  ORDER BY Q.PriorityRecId ,Q.CreatedOn DESC
;
