#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo $($PSQL "TRUNCATE TABLES games, teams;")


while IFS=',' read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; 
do
    
 if [[ $WINNER != "winner" && $WINNER != "opponent"  ]]; then
 TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  if [[ -z $TEAM_NAME ]]; then
  INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  fi
 fi
if [[ $OPPONENT != "winner" && $OPPONENT != "opponent" ]]; then
 TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
 if [[ -z $TEAM_NAME ]]; then
 INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
 fi
fi 
WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

if [[ -n $WIN_ID || -n $OP_ID ]]; then
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
    VALUES('$YEAR', '$ROUND', '$WIN_ID', '$OP_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
fi

 


 
    

done < games.csv
