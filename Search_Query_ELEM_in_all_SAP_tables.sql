DO
BEGIN

DECLARE L_OBJECT_ID_ARRAY NVARCHAR(30) ARRAY := ARRAY('00O2THU2HDIGQ1YI1PRR2D3J9','00O2THU2HDIIJKU4498043LB4');
DECLARE COUNTER INT := 0;
DECLARE COL_NAME NVARCHAR(20) := 'COMPUID';
DECLARE CURSOR l_cur FOR 
SELECT 
  SCHEMA_NAME, 
  TABLE_NAME,
  COLUMN_NAME
FROM 
  TABLE_COLUMNS 
WHERE 
  COLUMN_NAME = :COL_NAME 
ORDER BY 
  1, 
  2;

TAB_FROM_ARRAY = UNNEST(:L_OBJECT_ID_ARRAY) as ("OBJECT_ID");

FOR CUR_ROW as l_cur DO

    EXEC 'SELECT COUNT(*) FROM "' || CUR_ROW.SCHEMA_NAME || '"."' || CUR_ROW.TABLE_NAME || '" WHERE ' || CUR_ROW.COLUMN_NAME || ' in ( SELECT "OBJECT_ID" FROM :TAB_FROM_ARRAY );' INTO COUNTER USING :TAB_FROM_ARRAY;
    IF :COUNTER > 0 THEN
    	EXECUTE IMMEDIATE('SELECT '''|| CUR_ROW.TABLE_NAME || ''' as TABLE, * FROM "' || CUR_ROW.SCHEMA_NAME || '"."' || CUR_ROW.TABLE_NAME || '" WHERE ' || CUR_ROW.COLUMN_NAME || ' in ( SELECT "OBJECT_ID" FROM :TAB_FROM_ARRAY );') USING :TAB_FROM_ARRAY;
    END IF;
    
END FOR;

END;