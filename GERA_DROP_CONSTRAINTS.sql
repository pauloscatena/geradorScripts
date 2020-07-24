DECLARE @PREFIXO VARCHAR(10) = 'OPF'

select 'IF(EXISTS(SELECT 1 FROM SYSOBJECTS WHERE ID = OBJECT_ID(''' + CONSTRAINT_NAME + '''))) ALTER TABLE [' + TABLE_NAME + '] DROP CONSTRAINT [' + CONSTRAINT_NAME + '];'
from information_schema.TABLE_CONSTRAINTS 
WHERE TABLE_NAME LIKE '%' + @PREFIXO + '%'
--WHERE TABLE_NAME = 'CRK_OPF_CONTRATO_BLOQUEIO'
order by CONSTRAINT_TYPE, TABLE_NAME