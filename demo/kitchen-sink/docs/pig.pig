rows = LOAD 's3n://event-logs/impressions/2015/04/08';
    USING com.mortardata.pig.JsonLoader('time: chararray, browser:chararray');

clean_rows = FOREACH rows GENERATE SUBSTRING(time, 0, 10) AS date, browser;

filtered = FILTER clean_rows BY browser=='ff29' or browser=='cr32';

grouped = GROUP filtered BY (date, browser);

/*
results = FOREACH grouped GENERATE FLATTEN(group.$0), COUNT(filtered);
*/

results = FOREACH grouped GENERATE FLATTEN(group.$0), COUNT(filtered);

-- Store stuff
STORE results INTO 's3n://pig-results/2015-04-10/' USING PigStorage('\t');
