SELECT db_TA7.v8_reference168.V8_Description
FROM db_TA7.v8_reference168
WHERE db_TA7.v8_reference168.V8_ID =
(
    SELECT db_TA7.v8_reference118_vt119.V8_Fld345
    FROM db_TA7.v8_reference118_vt119
    WHERE db_TA7.v8_reference118_vt119.V8_ID =
    (
        SELECT db_TA7.v8_reference118.V8_ID
        FROM db_TA7.v8_reference118
        WHERE v8_reference118.V8_Fld312 = 60
        LIMIT 1
    )
    LIMIT 1
)
LIMIT 1