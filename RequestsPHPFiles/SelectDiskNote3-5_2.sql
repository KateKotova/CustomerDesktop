SELECT DISTINCT db_TA7.v8_reference88.V8_Description
FROM db_TA7.v8_inforeg715
    INNER JOIN db_TA7.v8_reference88
    ON db_TA7.v8_inforeg715.V8_Fld4280_RRef = db_TA7.v8_reference88.V8_ID
WHERE db_TA7.v8_inforeg715.V8_Fld4278_RRef =
(
    SELECT db_TA7.v8_reference118.V8_ID
    FROM db_TA7.v8_reference118
    WHERE db_TA7.v8_reference118.V8_Fld312 = 1
    LIMIT 1
)