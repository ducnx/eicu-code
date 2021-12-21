# This file makes tables for the concepts in this subfolder.
# Be sure to run postgres-functions.sql first, as the concepts rely on those function definitions.
# Note that this may take a large amount of time and hard drive space.

# string replacements are necessary for some queries
export REGEX_DATETIME_DIFF="s/DATETIME_DIFF\((.+?),\s?(.+?),\s?(DAY|MINUTE|SECOND|HOUR|YEAR)\)/DATETIME_DIFF(\1, \2, '\3')/g"
export REGEX_SCHEMA='s/`eicu.(eicu_crd).(.+?)`/\2/g'
export CONNSTR='-d eicu'

# this is set as the search_path variable for psql
# a search path of "public,mimiciii" will search both public and mimiciii
# schemas for data, but will create tables on the public schema
export PSQL_PREAMBLE='SET search_path TO public,eicu_crd'

echo ''
echo '==='
echo 'Beginning to create tables for eICU database.'
echo 'Any notices of the form "NOTICE: TABLE "XXXXXX" does not exist" can be ignored.'
echo 'The scripts drop views before creating them, and these notices indicate nothing existed prior to creating the view.'
echo '==='
echo ''

echo 'Directory 3 of 9: demographics'
{ echo "${PSQL_PREAMBLE}; DROP TABLE IF EXISTS icustay_detail; CREATE TABLE icustay_detail AS "; cat demographics/icustay_detail.sql; } | sed -r -e "${REGEX_DATETIME_DIFF}" | sed -r -e "${REGEX_SCHEMA}" | psql ${CONNSTR}

echo 'Finished creating tables.'
