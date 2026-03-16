SELECT
    V8_Fld559,
    V8_Fld560,
    V8_Fld561,
    V8_Fld562,
    V8_Fld563,
    V8_Fld564,
    V8_Fld565,
    V8_Fld566,
    V8_Fld567,
    V8_Fld568,
    V8_Fld569,
    V8_Fld570,
    V8_Fld571,
    V8_Fld572,
    V8_Fld573
FROM db_TA7.v8_reference165
WHERE V8_Description =
(
    SELECT V8_Description
    FROM db_TA7.v8_reference167
    WHERE V8_Code = 1
    LIMIT 1
)
LIMIT 1