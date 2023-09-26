--comandos no redshift etl (producer) 
-- reference : https://docs.aws.amazon.com/redshift/latest/dg/within-account.html


SHOW DATASHARES;

-- create datashare 
create datashare ds_raiadrogasil;

-- Delegate permissions to operate on the datashare. 
GRANT ALTER, SHARE ON DATASHARE ds_raiadrogasil TO rdawsuser;

-- add schema to DS
alter datashare ds_raiadrogasil add schema rd_corp;

-- add tables to DS
ALTER DATASHARE ds_raiadrogasil ADD all tables in schema rd_corp;

-- add consumers to DS 
grant usage on datashare ds_raiadrogasil to namespace '9422eaad-988d-443a-86c4-32f4896706ac'; -- consumer cluster namespace

-- (Optional) Add security restrictions to the datashare. The following example shows that the consumer cluster with a public IP access is allowed to read the datashare.
ALTER DATASHARE ds_raiadrogasil SET PUBLICACCESSIBLE = TRUE;

-- Displays the outbound datashares in the producer cluster
DESC DATASHARE ds_raiadrogasil;

-- Check Which namespace or clusters have I granted usage to datashare 
select * from svv_datashare_consumers;


------------inicio comando redshift consumer
-- SHOW DATASHARES;

DESC DATASHARE ds_raiadrogasil OF NAMESPACE '6e012a22-3a14-46e4-8033-f9c5d35dac28';

create database etl2consumer_db from datashare ds_raiadrogasil of namespace '6e012a22-3a14-46e4-8033-f9c5d35dac28'; -- PRODUCER cluster namespace  '6e012a22-3a14-46e4-8033-f9c5d35dac28'

grant usage on database etl2consumer_db to rdawsuser;

-- grant usage on schema rd_corp to rdawsuser;

select * from etl2consumer_db.rd_corp.dim_calendario_mes limit 10;

---ERROR: ----------------------------------------------- error: Producer table not ready for consumption, please retry later. code: 34509 context: query: 0 location: burst_refresh_controller.cpp:460 process: padbmaster [pid=1073996764] ----------------------------------------------- [ErrorId: 1-64f767d8-218c57e46cc3483f01de0d9a]

select * from svv_datashare_consumers;


--- testes
-- data sharing 
teste de tempo para habilitar big tables
teste de criacao de nova tabela
grants 
---  confirmar qualquer tipo de alteracao nao afeta o data sharing 