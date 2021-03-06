/*
Copyright (c) 2000-2013 "independIT Integrative Technologies GmbH",
Authors: Ronald Jeninga, Dieter Stubler

schedulix Enterprise Job Scheduling System

independIT Integrative Technologies GmbH [http://www.independit.de]
mailto:contact@independit.de

This file is part of schedulix

schedulix is free software: 
you can redistribute it and/or modify it under the terms of the 
GNU Affero General Public License as published by the 
Free Software Foundation, either version 3 of the License, 
or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
*/
ALTER TABLE DEPENDENCY_DEFINITION
    ADD RESOLVE_MODE integer NOT NULL DEFAULT 0,
    ADD EXPIRED_AMOUNT integer,
    ADD EXPIRED_BASE integer,
    ADD SELECT_CONDITION varchar(1024);
DROP VIEW SCI_C_DEPENDENCY_DEFINITION;
DROP VIEW SCI_V_DEPENDENCY_DEFINITION;
CREATE VIEW SCI_C_DEPENDENCY_DEFINITION AS
SELECT
    ID
    , SE_DEPENDENT_ID                AS SE_DEPENDENT_ID
    , SE_REQUIRED_ID                 AS SE_REQUIRED_ID
    , NAME                           AS NAME
    , CASE UNRESOLVED_HANDLING WHEN 1 THEN 'IGNORE' WHEN 2 THEN 'ERROR' WHEN 3 THEN 'SUSPEND' WHEN 4 THEN 'DEFER' WHEN 5 THEN 'DEFER_IGNORE' END AS UNRESOLVED_HANDLING
    , CASE DMODE WHEN 1 THEN 'ALL_FINAL' WHEN 2 THEN 'JOB_FINAL' END AS DMODE
    , CASE STATE_SELECTION WHEN 0 THEN 'FINAL' WHEN 1 THEN 'ALL_REACHABLE' WHEN 2 THEN 'UNREACHABLE' WHEN 3 THEN 'DEFAULT' END AS STATE_SELECTION
    , CONDITION                      AS CONDITION
    , CASE RESOLVE_MODE WHEN 0 THEN 'INTERNAL' WHEN 1 THEN 'EXTERNAL' WHEN 2 THEN 'BOTH' END AS RESOLVE_MODE
    , EXPIRED_AMOUNT                 AS EXPIRED_AMOUNT
    , CASE EXPIRED_BASE WHEN 0 THEN 'MINUTE' WHEN 1 THEN 'HOUR' WHEN 2 THEN 'DAY' WHEN 3 THEN 'WEEK' WHEN 4 THEN 'MONTH' WHEN 5 THEN 'YEAR' END AS EXPIRED_BASE
    , SELECT_CONDITION               AS SELECT_CONDITION
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
  FROM DEPENDENCY_DEFINITION
 WHERE VALID_TO = 9223372036854775807;
CREATE VIEW SCI_V_DEPENDENCY_DEFINITION AS
SELECT
    ID
    , SE_DEPENDENT_ID                AS SE_DEPENDENT_ID
    , SE_REQUIRED_ID                 AS SE_REQUIRED_ID
    , NAME                           AS NAME
    , CASE UNRESOLVED_HANDLING WHEN 1 THEN 'IGNORE' WHEN 2 THEN 'ERROR' WHEN 3 THEN 'SUSPEND' WHEN 4 THEN 'DEFER' WHEN 5 THEN 'DEFER_IGNORE' END AS UNRESOLVED_HANDLING
    , CASE DMODE WHEN 1 THEN 'ALL_FINAL' WHEN 2 THEN 'JOB_FINAL' END AS DMODE
    , CASE STATE_SELECTION WHEN 0 THEN 'FINAL' WHEN 1 THEN 'ALL_REACHABLE' WHEN 2 THEN 'UNREACHABLE' WHEN 3 THEN 'DEFAULT' END AS STATE_SELECTION
    , CONDITION                      AS CONDITION
    , CASE RESOLVE_MODE WHEN 0 THEN 'INTERNAL' WHEN 1 THEN 'EXTERNAL' WHEN 2 THEN 'BOTH' END AS RESOLVE_MODE
    , EXPIRED_AMOUNT                 AS EXPIRED_AMOUNT
    , CASE EXPIRED_BASE WHEN 0 THEN 'MINUTE' WHEN 1 THEN 'HOUR' WHEN 2 THEN 'DAY' WHEN 3 THEN 'WEEK' WHEN 4 THEN 'MONTH' WHEN 5 THEN 'YEAR' END AS EXPIRED_BASE
    , SELECT_CONDITION               AS SELECT_CONDITION
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
    , VALID_FROM
    , VALID_TO
  FROM DEPENDENCY_DEFINITION;
ALTER TABLE DEPENDENCY_INSTANCE
    ADD REQUIRED_SE_ID decimal(20);
ALTER TABLE ARC_DEPENDENCY_INSTANCE
    ADD REQUIRED_SE_ID decimal(20);
DROP VIEW SCI_DEPENDENCY_INSTANCE;
CREATE VIEW SCI_DEPENDENCY_INSTANCE AS
SELECT
    ID
    , DD_ID                          AS DD_ID
    , DEPENDENT_ID                   AS DEPENDENT_ID
    , DEPENDENT_ID_ORIG              AS DEPENDENT_ID_ORIG
    , CASE DEPENDENCY_OPERATION WHEN 1 THEN 'AND' WHEN 2 THEN 'OR' END AS DEPENDENCY_OPERATION
    , REQUIRED_ID                    AS REQUIRED_ID
    , REQUIRED_SE_ID                 AS REQUIRED_SE_ID
    , CASE STATE WHEN 0 THEN 'OPEN' WHEN 1 THEN 'FULFILLED' WHEN 2 THEN 'FAILED' WHEN 3 THEN 'BROKEN' WHEN 4 THEN 'DEFERRED' WHEN 8 THEN 'CANCELLED' END AS STATE
    , CASE IGNORE WHEN 0 THEN 'NO' WHEN 1 THEN 'YES' WHEN 2 THEN 'RECURSIVE' END AS IGNORE
    , DI_ID_ORIG                     AS DI_ID_ORIG
    , SE_VERSION                     AS SE_VERSION
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
  FROM DEPENDENCY_INSTANCE;
ALTER TABLE INTERVALL
    ADD OBJ_ID decimal(20),
    ADD OBJ_TYPE integer;
DROP VIEW SCI_INTERVALL;
CREATE VIEW SCI_INTERVALL AS
SELECT
    ID
    , NAME                           AS NAME
    , OWNER_ID                       AS OWNER_ID
    , timestamptz 'epoch' + cast(to_char(mod(START_TIME, 1125899906842624)/1000, '999999999999') as interval) AS START_TIME
    , timestamptz 'epoch' + cast(to_char(mod(END_TIME, 1125899906842624)/1000, '999999999999') as interval) AS END_TIME
    , DELAY                          AS DELAY
    , CASE BASE_INTERVAL WHEN 0 THEN 'MINUTE' WHEN 1 THEN 'HOUR' WHEN 2 THEN 'DAY' WHEN 3 THEN 'WEEK' WHEN 4 THEN 'MONTH' WHEN 5 THEN 'YEAR' END AS BASE_INTERVAL
    , BASE_INTERVAL_MULTIPLIER       AS BASE_INTERVAL_MULTIPLIER
    , CASE DURATION WHEN 0 THEN 'MINUTE' WHEN 1 THEN 'HOUR' WHEN 2 THEN 'DAY' WHEN 3 THEN 'WEEK' WHEN 4 THEN 'MONTH' WHEN 5 THEN 'YEAR' END AS DURATION
    , DURATION_MULTIPLIER            AS DURATION_MULTIPLIER
    , timestamptz 'epoch' + cast(to_char(mod(SYNC_TIME, 1125899906842624)/1000, '999999999999') as interval) AS SYNC_TIME
    , CASE IS_INVERSE WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_INVERSE
    , CASE IS_MERGE WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_MERGE
    , EMBEDDED_INT_ID                AS EMBEDDED_INT_ID
    , SE_ID                          AS SE_ID
    , OBJ_ID                         AS OBJ_ID
    , CASE OBJ_TYPE WHEN 25 THEN 'DISTRIBUTION' WHEN 8 THEN 'USER' WHEN 9 THEN 'JOB_DEFINITION' WHEN 11 THEN 'RESOURCE' WHEN 15 THEN 'SCOPE' WHEN 16 THEN 'TRIGGER' WHEN 18 THEN 'EVENT' WHEN 19 THEN 'INTERVAL' WHEN 20 THEN 'SCHEDULE' WHEN 22 THEN 'SCHEDULED_EVENT' WHEN 28 THEN 'RESOURCE_TEMPLATE' WHEN 88 THEN 'INTERVAL_DISPATCHER' END AS OBJ_TYPE
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
  FROM INTERVALL;
-- Copyright (C) 2001,2002 topIT Informationstechnologie GmbH
-- Copyright (C) 2003-2014 independIT Integrative Technologies GmbH

CREATE TABLE INTERVAL_DISPATCHER (
    ID                             decimal(20) NOT NULL
    , INT_ID                         decimal(20)     NOT NULL
    , SEQ_NO                         integer         NOT NULL
    , NAME                           varchar(64)     NOT NULL
    , SELECT_INT_ID                  decimal(20)         NULL
    , FILTER_INT_ID                  decimal(20)         NULL
    , IS_ENABLED                     integer         NOT NULL
    , IS_ACTIVE                      integer         NOT NULL
    , CREATOR_U_ID                   decimal(20)     NOT NULL
    , CREATE_TS                      decimal(20)     NOT NULL
    , CHANGER_U_ID                   decimal(20)     NOT NULL
    , CHANGE_TS                      decimal(20)     NOT NULL
);
CREATE UNIQUE INDEX PK_INTERVAL_DISPATCHER
ON INTERVAL_DISPATCHER(ID);
DROP VIEW SCI_INTERVAL_DISPATCHER;
CREATE VIEW SCI_INTERVAL_DISPATCHER AS
SELECT
    ID
    , INT_ID                         AS INT_ID
    , SEQ_NO                         AS SEQ_NO
    , NAME                           AS NAME
    , SELECT_INT_ID                  AS SELECT_INT_ID
    , FILTER_INT_ID                  AS FILTER_INT_ID
    , CASE IS_ENABLED WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_ENABLED
    , CASE IS_ACTIVE WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_ACTIVE
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
  FROM INTERVAL_DISPATCHER;
ALTER TABLE SCHEDULING_HIERARCHY
    ADD INT_ID decimal(20);
DROP VIEW SCI_C_SCHEDULING_HIERARCHY;
DROP VIEW SCI_V_SCHEDULING_HIERARCHY;
CREATE VIEW SCI_C_SCHEDULING_HIERARCHY AS
SELECT
    ID
    , SE_PARENT_ID                   AS SE_PARENT_ID
    , SE_CHILD_ID                    AS SE_CHILD_ID
    , ALIAS_NAME                     AS ALIAS_NAME
    , CASE IS_STATIC WHEN 1 THEN 'STATIC' WHEN 0 THEN 'DYNAMIC' END AS IS_STATIC
    , CASE IS_DISABLED WHEN 0 THEN 'ENABLED' WHEN 1 THEN 'DISABLED' END AS IS_DISABLED
    , PRIORITY                       AS PRIORITY
    , CASE SUSPEND WHEN 1 THEN 'CHILDSUSPEND' WHEN 2 THEN 'NOSUSPEND' WHEN 3 THEN 'SUSPEND' END AS SUSPEND
    , RESUME_AT                      AS RESUME_AT
    , RESUME_IN                      AS RESUME_IN
    , CASE RESUME_BASE WHEN 0 THEN 'MINUTE' WHEN 1 THEN 'HOUR' WHEN 2 THEN 'DAY' WHEN 3 THEN 'WEEK' WHEN 4 THEN 'MONTH' WHEN 5 THEN 'YEAR' END AS RESUME_BASE
    , CASE MERGE_MODE WHEN 1 THEN 'MERGE_LOCAL' WHEN 2 THEN 'MERGE_GLOBAL' WHEN 3 THEN 'NOMERGE' WHEN 4 THEN 'FAILURE' END AS MERGE_MODE
    , ESTP_ID                        AS ESTP_ID
    , INT_ID                         AS INT_ID
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
  FROM SCHEDULING_HIERARCHY
 WHERE VALID_TO = 9223372036854775807;
CREATE VIEW SCI_V_SCHEDULING_HIERARCHY AS
SELECT
    ID
    , SE_PARENT_ID                   AS SE_PARENT_ID
    , SE_CHILD_ID                    AS SE_CHILD_ID
    , ALIAS_NAME                     AS ALIAS_NAME
    , CASE IS_STATIC WHEN 1 THEN 'STATIC' WHEN 0 THEN 'DYNAMIC' END AS IS_STATIC
    , CASE IS_DISABLED WHEN 0 THEN 'ENABLED' WHEN 1 THEN 'DISABLED' END AS IS_DISABLED
    , PRIORITY                       AS PRIORITY
    , CASE SUSPEND WHEN 1 THEN 'CHILDSUSPEND' WHEN 2 THEN 'NOSUSPEND' WHEN 3 THEN 'SUSPEND' END AS SUSPEND
    , RESUME_AT                      AS RESUME_AT
    , RESUME_IN                      AS RESUME_IN
    , CASE RESUME_BASE WHEN 0 THEN 'MINUTE' WHEN 1 THEN 'HOUR' WHEN 2 THEN 'DAY' WHEN 3 THEN 'WEEK' WHEN 4 THEN 'MONTH' WHEN 5 THEN 'YEAR' END AS RESUME_BASE
    , CASE MERGE_MODE WHEN 1 THEN 'MERGE_LOCAL' WHEN 2 THEN 'MERGE_GLOBAL' WHEN 3 THEN 'NOMERGE' WHEN 4 THEN 'FAILURE' END AS MERGE_MODE
    , ESTP_ID                        AS ESTP_ID
    , INT_ID                         AS INT_ID
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
    , VALID_FROM
    , VALID_TO
  FROM SCHEDULING_HIERARCHY;
ALTER TABLE SUBMITTED_ENTITY
    ADD TIME_ZONE varchar(32);
ALTER TABLE ARC_SUBMITTED_ENTITY
    ADD TIME_ZONE varchar(32);
DROP VIEW SCI_SUBMITTED_ENTITY;
CREATE VIEW SCI_SUBMITTED_ENTITY AS
SELECT
    ID
    , MASTER_ID                      AS MASTER_ID
    , SUBMIT_TAG                     AS SUBMIT_TAG
    , CASE UNRESOLVED_HANDLING WHEN 1 THEN 'UH_IGNORE' WHEN 3 THEN 'UH_SUSPEND' WHEN 2 THEN 'UH_ERROR' END AS UNRESOLVED_HANDLING
    , SE_ID                          AS SE_ID
    , CHILD_TAG                      AS CHILD_TAG
    , SE_VERSION                     AS SE_VERSION
    , OWNER_ID                       AS OWNER_ID
    , PARENT_ID                      AS PARENT_ID
    , SCOPE_ID                       AS SCOPE_ID
    , CASE IS_STATIC WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_STATIC
    , CASE IS_DISABLED WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_DISABLED
    , OLD_STATE                      AS OLD_STATE
    , CASE MERGE_MODE WHEN 1 THEN 'MERGE_LOCAL' WHEN 2 THEN 'MERGE_GLOBAL' WHEN 3 THEN 'NOMERGE' WHEN 4 THEN 'FAILURE' END AS MERGE_MODE
    , CASE STATE WHEN 0 THEN 'SUBMITTED' WHEN 1 THEN 'DEPENDENCY_WAIT' WHEN 2 THEN 'SYNCHRONIZE_WAIT' WHEN 3 THEN 'RESOURCE_WAIT' WHEN 4 THEN 'RUNNABLE' WHEN 5 THEN 'STARTING' WHEN 6 THEN 'STARTED' WHEN 7 THEN 'RUNNING' WHEN 8 THEN 'TO_KILL' WHEN 9 THEN 'KILLED' WHEN 10 THEN 'CANCELLED' WHEN 11 THEN 'FINISHED' WHEN 12 THEN 'FINAL' WHEN 13 THEN 'BROKEN_ACTIVE' WHEN 14 THEN 'BROKEN_FINISHED' WHEN 15 THEN 'ERROR' WHEN 16 THEN 'UNREACHABLE' END AS STATE
    , JOB_ESD_ID                     AS JOB_ESD_ID
    , JOB_ESD_PREF                   AS JOB_ESD_PREF
    , CASE JOB_IS_FINAL WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS JOB_IS_FINAL
    , CASE JOB_IS_RESTARTABLE WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS JOB_IS_RESTARTABLE
    , FINAL_ESD_ID                   AS FINAL_ESD_ID
    , EXIT_CODE                      AS EXIT_CODE
    , COMMANDLINE                    AS COMMANDLINE
    , RR_COMMANDLINE                 AS RR_COMMANDLINE
    , RERUN_SEQ                      AS RERUN_SEQ
    , CASE IS_REPLACED WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_REPLACED
    , CASE IS_CANCELLED WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_CANCELLED
    , BASE_SME_ID                    AS BASE_SME_ID
    , REASON_SME_ID                  AS REASON_SME_ID
    , FIRE_SME_ID                    AS FIRE_SME_ID
    , FIRE_SE_ID                     AS FIRE_SE_ID
    , TR_ID                          AS TR_ID
    , TR_SD_ID_OLD                   AS TR_SD_ID_OLD
    , TR_SD_ID_NEW                   AS TR_SD_ID_NEW
    , TR_SEQ                         AS TR_SEQ
    , WORKDIR                        AS WORKDIR
    , LOGFILE                        AS LOGFILE
    , ERRLOGFILE                     AS ERRLOGFILE
    , PID                            AS PID
    , EXTPID                         AS EXTPID
    , ERROR_MSG                      AS ERROR_MSG
    , KILL_ID                        AS KILL_ID
    , KILL_EXIT_CODE                 AS KILL_EXIT_CODE
    , CASE IS_SUSPENDED WHEN 2 THEN 'ADMINSUSPEND' WHEN 1 THEN 'SUSPEND' WHEN 0 THEN 'NOSUSPEND' END AS IS_SUSPENDED
    , CASE IS_SUSPENDED_LOCAL WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_SUSPENDED_LOCAL
    , PRIORITY                       AS PRIORITY
    , RAW_PRIORITY                   AS RAW_PRIORITY
    , NICE                           AS NICE
    , NP_NICE                        AS NP_NICE
    , MIN_PRIORITY                   AS MIN_PRIORITY
    , AGING_AMOUNT                   AS AGING_AMOUNT
    , PARENT_SUSPENDED               AS PARENT_SUSPENDED
    , CHILD_SUSPENDED                AS CHILD_SUSPENDED
    , WARN_COUNT                     AS WARN_COUNT
    , WARN_LINK                      AS WARN_LINK
    , timestamptz 'epoch' + cast(to_char(mod(SUBMIT_TS, 1125899906842624)/1000, '999999999999') as interval) AS SUBMIT_TS
    , timestamptz 'epoch' + cast(to_char(mod(RESUME_TS, 1125899906842624)/1000, '999999999999') as interval) AS RESUME_TS
    , timestamptz 'epoch' + cast(to_char(mod(SYNC_TS, 1125899906842624)/1000, '999999999999') as interval) AS SYNC_TS
    , timestamptz 'epoch' + cast(to_char(mod(RESOURCE_TS, 1125899906842624)/1000, '999999999999') as interval) AS RESOURCE_TS
    , timestamptz 'epoch' + cast(to_char(mod(RUNNABLE_TS, 1125899906842624)/1000, '999999999999') as interval) AS RUNNABLE_TS
    , timestamptz 'epoch' + cast(to_char(mod(START_TS, 1125899906842624)/1000, '999999999999') as interval) AS START_TS
    , timestamptz 'epoch' + cast(to_char(mod(FINSH_TS, 1125899906842624)/1000, '999999999999') as interval) AS FINSH_TS
    , timestamptz 'epoch' + cast(to_char(mod(FINAL_TS, 1125899906842624)/1000, '999999999999') as interval) AS FINAL_TS
    , IDLE_TIME                      AS IDLE_TIME
    , DEPENDENCY_WAIT_TIME           AS DEPENDENCY_WAIT_TIME
    , SUSPEND_TIME                   AS SUSPEND_TIME
    , SYNC_TIME                      AS SYNC_TIME
    , RESOURCE_TIME                  AS RESOURCE_TIME
    , JOBSERVER_TIME                 AS JOBSERVER_TIME
    , RESTARTABLE_TIME               AS RESTARTABLE_TIME
    , CHILD_WAIT_TIME                AS CHILD_WAIT_TIME
    , OP_SUSRES_TS                   AS OP_SUSRES_TS
    , NPE_ID                         AS NPE_ID
    , TIME_ZONE                      AS TIME_ZONE
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
    , ((COALESCE(FINAL_TS, EXTRACT(EPOCH FROM CURRENT_TIMESTAMP AT TIME ZONE 'GMT') * 1000) - SUBMIT_TS) / 1000) - DEPENDENCY_WAIT_TIME AS PROCESS_TIME
  FROM SUBMITTED_ENTITY;
-- Copyright (C) 2001,2002 topIT Informationstechnologie GmbH
-- Copyright (C) 2003-2014 independIT Integrative Technologies GmbH

CREATE TABLE TRIGGER_PARAMETER (
    ID                             decimal(20) NOT NULL
    , NAME                           varchar(64)     NOT NULL
    , EXPRESSION                     varchar(1024)   NOT NULL
    , TRIGGER_ID                     decimal(20)     NOT NULL
    , CREATOR_U_ID                   decimal(20)     NOT NULL
    , CREATE_TS                      decimal(20)     NOT NULL
    , CHANGER_U_ID                   decimal(20)     NOT NULL
    , CHANGE_TS                      decimal(20)     NOT NULL
    , VALID_FROM                   decimal(20) NOT NULL
    , VALID_TO                     decimal(20) NOT NULL
);
CREATE INDEX PK_TRIGGER_PARAMETER
ON TRIGGER_PARAMETER(ID);
DROP VIEW SCI_C_TRIGGER_PARAMETER;
DROP VIEW SCI_V_TRIGGER_PARAMETER;
CREATE VIEW SCI_C_TRIGGER_PARAMETER AS
SELECT
    ID
    , NAME                           AS NAME
    , EXPRESSION                     AS EXPRESSION
    , TRIGGER_ID                     AS TRIGGER_ID
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
  FROM TRIGGER_PARAMETER
 WHERE VALID_TO = 9223372036854775807;
CREATE VIEW SCI_V_TRIGGER_PARAMETER AS
SELECT
    ID
    , NAME                           AS NAME
    , EXPRESSION                     AS EXPRESSION
    , TRIGGER_ID                     AS TRIGGER_ID
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
    , VALID_FROM
    , VALID_TO
  FROM TRIGGER_PARAMETER;
DROP VIEW SCI_SCOPE;
ALTER TABLE SCOPE ALTER NODE TYPE VARCHAR(64);
CREATE VIEW SCI_SCOPE AS
SELECT
    ID
    , NAME                           AS NAME
    , OWNER_ID                       AS OWNER_ID
    , PARENT_ID                      AS PARENT_ID
    , CASE TYPE WHEN 1 THEN 'SCOPE' WHEN 2 THEN 'SERVER' END AS TYPE
    , CASE IS_TERMINATE WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_TERMINATE
    , CASE HAS_ALTEREDCONFIG WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS HAS_ALTEREDCONFIG
    , CASE IS_SUSPENDED WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_SUSPENDED
    , CASE IS_ENABLED WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_ENABLED
    , CASE IS_REGISTERED WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS IS_REGISTERED
    , CASE STATE WHEN 1 THEN 'NOMINAL' WHEN 2 THEN 'NONFATAL' WHEN 3 THEN 'FATAL' END AS STATE
    , PID                            AS PID
    , NODE                           AS NODE
    , ERRMSG                         AS ERRMSG
    , LAST_ACTIVE                    AS LAST_ACTIVE
    , CREATOR_U_ID                   AS CREATOR_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CREATE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CREATE_TS
    , CHANGER_U_ID                   AS CHANGER_U_ID
    , timestamptz 'epoch' + cast(to_char(mod(CHANGE_TS, 1125899906842624)/1000, '999999999999') as interval) AS CHANGE_TS
    , INHERIT_PRIVS                  AS INHERIT_PRIVS
  FROM SCOPE;
