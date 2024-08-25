#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align  -c"
echo -e "\nEnter your username:"
read USERNAME
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
if [[ -z $USER_ID ]]
then
echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
INSERT_NEW_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")
echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
GUESSES=1
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
echo -e "\nGuess the secret number between 1 and 1000:"
read GUESSED_NUMBER
if [[ $GUESSED_NUMBER == $SECRET_NUMBER ]]
then
echo -e "\nYou guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
INSERT_GAMES=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, 1)")
else
while [[ ! $GUESSED_NUMBER == $SECRET_NUMBER ]]
do
if [[ $GUESSED_NUMBER -gt $SECRET_NUMBER ]]
then 
echo -e "\nIt's lower than that, guess again:"
fi
if [[ $GUESSED_NUMBER -lt $SECRET_NUMBER ]]
then
echo -e "\nIt's higher than that, guess again:"
fi
if [[ ! $GUESSED_NUMBER =~ ^[0-9]+$ ]]
then
echo -e "\nThat is not an integer, guess again:"
fi
read GUESSED_NUMBER
((GUESSES++))
done
fi
echo -e "\nYou guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
INSERT_GAMES=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $GUESSES)")

