DROP VIEW IF EXISTS AP_NAME_MAPPING_TABLES;

CREATE VIEW AP_NAME_MAPPING_TABLES AS
SELECT
	DD02T.TABNAME AS TABLE_NAME,
	DD02T.DDLANGUAGE AS LANGUAGE,
	DD02T.DDTEXT AS PRETTY_NAME
FROM
	DD02T
	
UNION
 
SELECT
	'_CEL_AP_ACTIVITIES',
	'D',
	'AktivitÃ¤ten'
	
UNION

SELECT
	'_CEL_AP_ACTIVITIES',
	'E',
	'Activities'
;