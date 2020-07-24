DECLARE @PREFIXO VARCHAR(10) = 'OPF'
DECLARE @PROC_NAME VARCHAR(500),
		@ROUT_TYPE VARCHAR(50),
		@ROUT_SCHEMA VARCHAR(50)

DECLARE CUR_PROCS CURSOR FAST_FORWARD FOR
SELECT SPECIFIC_NAME, ROUTINE_TYPE, ROUTINE_SCHEMA FROM INFORMATION_SCHEMA.ROUTINES
WHERE (ISNULL(@PREFIXO, '') = '' OR SPECIFIC_NAME LIKE '%' + @PREFIXO + '%')
AND ROUTINE_TYPE = 'FUNCTION'

OPEN CUR_PROCS
FETCH NEXT FROM CUR_PROCS INTO @PROC_NAME, @ROUT_TYPE, @ROUT_SCHEMA
WHILE @@FETCH_STATUS = 0
BEGIN


SET NOCOUNT ON;

DECLARE
   @objName varchar(128);
SET @objName = @PROC_NAME;
/* Script out objects if they exist*/
IF  EXISTS (SELECT *
              FROM sys.objects
              WHERE object_id  = OBJECT_ID(@objName))
                --AND type IN (N'FN', N'IF', N'TF', N'FS', N'FT',N'P'))
    BEGIN
        DECLARE
           @t TABLE(id bigint identity(1,1), line text)
    END;
    
INSERT INTO @t(line) VALUES('/*In�cio da ' + @ROUT_TYPE + ' ' + @PROC_NAME + '*/')
INSERT INTO @t(line) VALUES('IF(EXISTS(SELECT 1 FROM SYSOBJECTS WHERE ID = OBJECT_ID(''' + @PROC_NAME + ''')))')
INSERT INTO @t(line) VALUES('DROP ' + @ROUT_TYPE + ' ' + @ROUT_SCHEMA + '.' + @PROC_NAME )
INSERT INTO @t(line) VALUES('GO')    
INSERT INTO @t
EXEC sp_helptext @objName;

INSERT INTO @t(line) VALUES('GO')
INSERT INTO @t(line) VALUES('/* Fim da ' + @ROUT_TYPE + ' ' + @PROC_NAME +  '*/')

--DECLARE
--   @ddl text = '',
--   @DDL1 text = '';

--SELECT @DDL1 = @DDL1 + line
--  FROM @t;
  
--PRINT @ddl1;


FETCH NEXT FROM CUR_PROCS INTO @PROC_NAME, @ROUT_TYPE, @ROUT_SCHEMA

END
CLOSE CUR_PROCS
DEALLOCATE CUR_PROCS

SELECT line 
FROM @T
order by id
