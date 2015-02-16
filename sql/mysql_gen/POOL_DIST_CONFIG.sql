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
-- Copyright (C) 2001,2002 topIT Informationstechnologie GmbH
-- Copyright (C) 2003-2014 independIT Integrative Technologies GmbH

CREATE TABLE POOL_DIST_CONFIG (
    ID                             DECIMAL(20) NOT NULL
    , `PLD_ID`                       decimal(20)     NOT NULL
    , `PR_ID`                        decimal(20)     NOT NULL
    , `IS_MANAGED`                   integer             NULL
    , `NOM_PCT`                      integer             NULL
    , `FREE_PCT`                     integer             NULL
    , `MIN_PCT`                      integer             NULL
    , `MAX_PCT`                      integer             NULL
    , `CREATOR_U_ID`                 decimal(20)     NOT NULL
    , `CREATE_TS`                    decimal(20)     NOT NULL
    , `CHANGER_U_ID`                 decimal(20)     NOT NULL
    , `CHANGE_TS`                    decimal(20)     NOT NULL
) engine = innodb;
CREATE UNIQUE INDEX PK_POOL_DIST_CONFIG
ON POOL_DIST_CONFIG(id);
CREATE VIEW SCI_POOL_DIST_CONFIG AS
SELECT
    ID
    , `PLD_ID`                       AS `PLD_ID`
    , `PR_ID`                        AS `PR_ID`
    , CASE `IS_MANAGED` WHEN 1 THEN 'TRUE' WHEN 0 THEN 'FALSE' END AS `IS_MANAGED`
    , `NOM_PCT`                      AS `NOM_PCT`
    , `FREE_PCT`                     AS `FREE_PCT`
    , `MIN_PCT`                      AS `MIN_PCT`
    , `MAX_PCT`                      AS `MAX_PCT`
    , `CREATOR_U_ID`                 AS `CREATOR_U_ID`
    , from_unixtime((`CREATE_TS` & ~1125899906842624)/1000) AS `CREATE_TS`
    , `CHANGER_U_ID`                 AS `CHANGER_U_ID`
    , from_unixtime((`CHANGE_TS` & ~1125899906842624)/1000) AS `CHANGE_TS`
  FROM POOL_DIST_CONFIG;
