SELECT DISTINCT db_TA7.v8_reference118.V8_Fld312
FROM db_TA7.v8_accumreg845
    INNER JOIN db_TA7.v8_reference118
    ON db_TA7.v8_accumreg845.V8_Fld5206 = db_TA7.v8_reference118.V8_ID
        INNER JOIN db_TA7.v8_reference118_vt119
        ON db_TA7.v8_reference118.V8_ID = db_TA7.v8_reference118_vt119.V8_ID
            INNER JOIN db_TA7.v8_reference168
            ON db_TA7.v8_reference118_vt119.V8_Fld345 = db_TA7.v8_reference168.V8_ID
WHERE
    db_TA7.v8_accumreg845.V8_Fld5210 > 0 AND
    db_TA7.v8_reference168.V8_Code     = 1
ORDER BY db_TA7.v8_reference118.V8_Description ASC