SELECT
    db_TA7.v8_reference165.V8_Fld559,
    db_TA7.v8_reference165.V8_Fld560,
    db_TA7.v8_reference165.V8_Fld561,
    db_TA7.v8_reference165.V8_Fld562,
    db_TA7.v8_reference165.V8_Fld563,
    db_TA7.v8_reference165.V8_Fld564,
    db_TA7.v8_reference165.V8_Fld565,
    db_TA7.v8_reference165.V8_Fld566,
    db_TA7.v8_reference165.V8_Fld567,
    db_TA7.v8_reference165.V8_Fld568,
    db_TA7.v8_reference165.V8_Fld569,
    db_TA7.v8_reference165.V8_Fld570,
    db_TA7.v8_reference165.V8_Fld571,
    db_TA7.v8_reference165.V8_Fld572,
    db_TA7.v8_reference165.V8_Fld573
FROM db_TA7.v8_reference165
    INNER JOIN db_TA7.v8_inforeg793
    ON db_TA7.v8_reference165.V8_ID = db_TA7.v8_inforeg793.V8_Fld4745
WHERE db_TA7.v8_inforeg793.V8_Fld4743 =
(
    SELECT V8_ID
    FROM db_TA7.v8_reference118
    WHERE V8_Fld312 = 1
    LIMIT 1
)
GROUP BY db_TA7.v8_inforeg793.V8_Fld4744 
ORDER BY db_TA7.v8_inforeg793.V8_Fld4744 ASC
