

select 
	'IF(NOT EXISTS(SELECT 1 FROM SYS.SYNONYMS WHERE NAME = ''' + name + ''')) CREATE SYNONYM DBO.' + name + ' FOR ' + base_object_name
from sys.synonyms