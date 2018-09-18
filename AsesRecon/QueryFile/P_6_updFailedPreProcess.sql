UPDATE failed
SET failed.PreProcessStatusCode = 'R'
FROM stg.QueryDetail query 
JOIN dbo.QueryDetailFailPreProcess failed
    ON 
    failed.Firstname = query.Firstname And
    failed.Lastname = query.Lastname And
    failed.GenderMRefId = query.GenderMRefId And
    failed.BirthDate = query.BirthDate And 
    failed.CarrierMRefId = query.CarrierMRefId And 
    failed.AsesRegion = query.AsesRegion
JOIN (
    SELECT MAX(CarrierProcessDate) 'CarrierProcessDate'  , MemberRecId
    FROM dbo.QueryDetailFailPreProcess
    GROUP BY MemberRecId
) Latest    
    ON 
    Latest.MemberRecId = failed.MemberRecId And
    Latest.CarrierProcessDate = failed.CarrierProcessDate
  WHERE 1 = 1
    AND failed.PreProcessStatusCode =  'F';
