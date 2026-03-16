SELECT
    NULL        AS ID,
    V8_Fld559 AS Characteristic1,
    V8_Fld560 AS Characteristic2,
    V8_Fld561 AS Characteristic3,
    V8_Fld562 AS Characteristic4,
    V8_Fld563 AS Characteristic5,
    V8_Fld564 AS Characteristic6,
    V8_Fld565 AS Characteristic7,
    V8_Fld566 AS Characteristic8,
    V8_Fld567 AS Characteristic9,
    V8_Fld568 AS Characteristic10,
    V8_Fld569 AS Characteristic11,
    V8_Fld570 AS Characteristic12,
    V8_Fld571 AS Characteristic13,
    V8_Fld572 AS Characteristic14,
    V8_Fld573 AS Characteristic15
FROM db_TA3.v8_reference165
WHERE V8_Code = 1
UNION ALL
SELECT
    V8_ID        AS ID,
    V8_Description AS Characteristic1,
    V8_Fld560 AS Characteristic2,
    V8_Fld561 AS Characteristic3,
    V8_Fld562 AS Characteristic4,
    V8_Fld563 AS Characteristic5,
    V8_Fld564 AS Characteristic6,
    V8_Fld565 AS Characteristic7,
    V8_Fld566 AS Characteristic8,
    V8_Fld567 AS Characteristic9,
    V8_Fld568 AS Characteristic10,
    V8_Fld569 AS Characteristic11,
    V8_Fld570 AS Characteristic12,
    V8_Fld571 AS Characteristic13,
    V8_Fld572 AS Characteristic14,
    V8_Fld573 AS Characteristic15
 FROM db_TA3.razn
 WHERE V8_118_ID =
 (
    SELECT V8_ID
    FROM db_TA3.v8_reference118
    WHERE V8_Code = 67
    LIMIT 1
 )
 ORDER BY ID ASC