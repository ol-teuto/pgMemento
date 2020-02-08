-- INIT.sql
--
-- Author:      Felix Kunde <felix-kunde@gmx.de>
--
--              This script is free software under the LGPL Version 3
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
-- Script to start auditing for a given database schema
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                                  | Author
-- 0.1.0     2016-03-09   initial commit                                 FKun
--

\pset footer off
SET client_min_messages TO WARNING;
\set ON_ERROR_STOP ON

\echo
\prompt 'Please enter the name of the schema to be used along with pgMemento: ' schema_name
\prompt 'Specify tables to be excluded from logging processes (seperated by comma): ' except_tables
\prompt 'Log existing data as inserted (baseline)? (y|n): ' log_data
\prompt 'Trigger CREATE TABLE statements? (y|n): ' trigger_create_table

\echo
\echo 'Create event trigger to log schema changes ...'
SELECT pgmemento.create_schema_event_trigger(CASE WHEN lower(:'trigger_create_table') = 'y' OR lower(:'trigger_create_table') = 'yes' THEN TRUE ELSE FALSE END);

\echo
\echo 'Start auditing for tables in ':schema_name' schema ...'
SELECT pgmemento.create_schema_audit(:'schema_name', CASE WHEN lower(:'log_data') = 'y' OR lower(:'log_data') = 'yes' THEN TRUE ELSE FALSE END, string_to_array(:'except_tables',','));

\echo
\echo 'pgMemento is now initialized on ':schema_name' schema.'