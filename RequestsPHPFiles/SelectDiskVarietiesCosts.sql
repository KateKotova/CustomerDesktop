SELECT MAX( db_TA7.v8_accumreg845.V8_Fld5211 )
FROM db_TA7.v8_accumreg845
    INNER JOIN db_TA7.v8_inforeg793
    ON
            db_TA7.v8_accumreg845.V8_Fld5206 = db_TA7.v8_inforeg793.V8_Fld4743 AND
            db_TA7.v8_accumreg845.V8_Fld5207 = db_TA7.v8_inforeg793.V8_Fld4744
        INNER JOIN db_TA7.v8_reference165
        ON db_TA7.v8_inforeg793.V8_Fld4745 = db_TA7.v8_reference165.V8_ID            
WHERE db_TA7.v8_accumreg845.V8_Fld5206 =
(
    SELECT db_TA7.v8_reference118.V8_ID
    FROM db_TA7.v8_reference118
    WHERE db_TA7.v8_reference118.V8_Fld312 = 1
)
GROUP BY db_TA7.v8_accumreg845.V8_Fld5207
ORDER BY db_TA7.v8_accumreg845.V8_Fld5207 ASC
