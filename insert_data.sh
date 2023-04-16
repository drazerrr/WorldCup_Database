#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Use TRUNCATE for clear all data from tables
RESET=$($PSQL "TRUNCATE games, teams")

# use cat for access data from file and while loop for rendering
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    # use if condition for leave first line from the file
    if [[ $YEAR != year ]]
    then
        # chech team name available in column or not
        WINNER_TEAMS=$($PSQL "SELECT name FROM teams WHERE name = '$WINNER'")
        OPPONENT_TEAMS=$($PSQL "SELECT name FROM teams WHERE name = '$OPPONENT'")
        # if team name not found then insert team in column's row
        if [[ -z $WINNER_TEAMS ]]
        then
              TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
              echo -e "\n$TEAMS $WINNER"
         fi  
         if [[ -z $OPPONENT_TEAMS ]]
         then
                TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')") 
                echo -e "\n$TEAMS $OPPONENT"
          fi      
    fi          
done   

# insert data in games table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
    if [[ $YEAR != year ]]
    then
        WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
        OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
        GAME_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    fi   
done

