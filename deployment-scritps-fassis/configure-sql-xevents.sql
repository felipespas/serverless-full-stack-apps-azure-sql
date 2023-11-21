/*
Create a master key to protect the secret of the credential
*/
IF NOT EXISTS (
              SELECT 1
              FROM sys.symmetric_keys
              WHERE name = '##MS_DatabaseMasterKey##'
              )
CREATE MASTER KEY;

/*
(Re-)create a database scoped credential.
The name of the credential must match the URL of the blob container.
*/
IF EXISTS (
          SELECT *
          FROM sys.database_credentials
          WHERE name = 'https://storageaccount255980.blob.core.windows.net/database-xevents'
          )
    DROP DATABASE SCOPED CREDENTIAL [https://storageaccount255980.blob.core.windows.net/database-xevents];

/*
The secret is the SAS token for the container. The Read, Write, and List permissions are set.
*/
CREATE DATABASE SCOPED CREDENTIAL [https://storageaccount255980.blob.core.windows.net/database-xevents]
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
     SECRET = 'sp=rwl&st=2023-11-21T17:45:14Z&se=2023-11-22T01:45:14Z&spr=https&sv=2022-11-02&sr=c&sig=JuQYF%2B2jjOcl0INhlLqWlmt%2BiUdCgQFnsgyZpXt5Uj8%3D';
GO


SELECT
    o.object_type,
    p.name         AS [package_name],
    o.name         AS [db_object_name],
    o.description  AS [db_obj_description]
FROM
                sys.dm_xe_objects  AS o
    INNER JOIN  sys.dm_xe_packages AS p  ON p.guid = o.package_guid
WHERE
    o.object_type in('action',  'event',  'target')
    AND o.name LIKE '%module%'
GO

CREATE EVENT SESSION [executed-commands] ON DATABASE
ADD EVENT sqlserver.module_end
ADD TARGET package0.event_file(SET filename=N'https://storageaccount255980.blob.core.windows.net/database-xevents/bus-db.xel')
GO

ALTER EVENT SESSION [executed-commands] ON DATABASE STATE = START
GO

SELECT * FROM sys.dm_xe_database_sessions
GO

SELECT * FROM sys.dm_xe_database_session_events
GO

SELECT * FROM sys.dm_xe_database_session_targets
GO

ALTER EVENT SESSION [executed-commands] ON DATABASE STATE = STOP
GO

--Verificando se a sessão de evento estendido existe e o respectivo status (ligada, desligada)
SELECT name, startup_state, * FROM sys.database_event_sessions
GO

DROP EVENT SESSION [executed-commands] ON DATABASE 
GO

SELECT TOP 100 
    CAST(f.event_data AS XML)  AS [Event-Data-Cast-To-XML]
    ,CAST(f.event_data AS XML).value('(event/@name)[1]', 'varchar(1000)') AS [EventName]
    ,CAST(f.event_data AS XML).value('(event/@timestamp)[1]', 'datetime2') AS [EventTimestamp]
    ,CAST(f.event_data AS XML).value('(event/data[@name="object_name"]/value)[1]', 'varchar(1000)') AS [Procedure_Executed]
FROM sys.fn_xe_file_target_read_file('https://storageaccount255980.blob.core.windows.net/database-xevents/bus-db', DEFAULT, DEFAULT, DEFAULT) AS f
ORDER BY EventTimestamp DESC

SELECT * FROM
(
    SELECT 
        CAST(f.event_data AS XML)  AS [Event-Data-Cast-To-XML]
        ,CAST(f.event_data AS XML).value('(event/@name)[1]', 'varchar(1000)') AS [EventName]
        ,CAST(f.event_data AS XML).value('(event/@timestamp)[1]', 'datetime2') AS [EventTimestamp]
        ,CAST(f.event_data AS XML).value('(event/data[@name="object_name"]/value)[1]', 'varchar(1000)') AS [ProcedureName]
    FROM sys.fn_xe_file_target_read_file('https://storageaccount255980.blob.core.windows.net/database-xevents/bus-db', DEFAULT, DEFAULT, DEFAULT) AS f
) AS A
WHERE A.[ProcedureName] = 'GetMonitoredBusData'

EXEC [web].[GetMonitoredBusData] 100113, 1