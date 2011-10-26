#!/bin/bash
db=testrun.sqlite

for e in `ls *.txt`; do
    echo "Running $e through parser"
    ./parse-trips.rb ${e/.txt} 2>/dev/null
done

for e in `ls *-create.sql`; do 
   echo "Running $e into $db."
   cat $e|sqlite3 $db 
done

echo "vacuum;" | sqlite3 $db

for e in `ls *-inserts.sql`; do 
   echo "Running $e into $db"
   cat $e|sqlite3 $db 
done

