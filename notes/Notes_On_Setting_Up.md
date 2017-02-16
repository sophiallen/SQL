

#1/5/2017
Today we: 
- Set up virtual machines, connected to .\sqlexpress servers via SQL management studio. 
- The msdb database keeps track of schedules/alerts.
- Tempdb is a scratch db where temp files go, for example when temporary tables are created by SQL in the process of other tasks. 
- Copied and ran sql code from Steve's github dbschema/community_assist
- Went to class files and downloaded metroAlt_log.zip and (theoretically) extracted it to program files / sql server / mssql12.sqlexpress / mssql / data
- Opened up community assist and looked at its files. There are two: the core binary data file, and the log file (which keeps track of all the transactions that have occurred in the db)
  - never keep the log file on the same disk as the data file, or else if the disc with the data fails you have no backup. 
  - "dbo" refers to database owner, it's the default schema. 
- Started a new query (see query1)
  - GO separates batches (it's a microsoft keyword, not really a SQL keword)
  - Semi-colons are not required in the management studio, but are most other places. 
  - CREATE database is smart enough to figure out where the db should be added, if you don't specify. 
  - identity(start, step) keyword auto-increments the key, primary key is self explanato
  - the n in nvarchar indicates unicode. Without it (varchar) is ASCII. N**var**char tends to take more processing power than **n**char (fixed length), nchar tends to take up more disk space. 
- Comments in SQL: /*Multiline */ or -- Single Line
  
  
