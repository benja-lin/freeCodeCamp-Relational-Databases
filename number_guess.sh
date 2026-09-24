#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

WELCOME() {
echo "Enter your username:"
read USER_INPUT
IFS="|" read -r USERNAME GAMES_PLAYED BEST_GAME <<< "$($PSQL "SELECT username, games_played, best_game FROM users WHERE username = '$USER_INPUT'")"
if [[ -z $USERNAME ]]
then
  echo "Welcome, $USER_INPUT! It looks like this is your first time here."
else
  echo "Welcome back, $USER_INPUT! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0
GAMETIME
}

GAMETIME() {
if [[ ! $1 ]]
then
  echo "Guess the secret number between 1 and 1000:"
else
  echo "$1"
fi
read INPUT
NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))
if [[ ! $INPUT =~ ^[0-9]+$ ]]
then
  GAMETIME "That is not an integer, guess again:"
  return
elif [[ $INPUT -lt $SECRET_NUMBER ]]
then
  GAMETIME "It's higher than that, guess again:"
  return
elif [[ $INPUT -gt $SECRET_NUMBER ]]
then
  GAMETIME "It's lower than that, guess again:"
  return
else
  SUCCESS
fi
}

SUCCESS() {
if [[ -z $USERNAME ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username, best_game) VALUES('$USER_INPUT',$NUMBER_OF_GUESSES)")
else
  if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
  then
    UPDATE_USER_BEST=$($PSQL "UPDATE users SET games_played = games_played + 1, best_game = $NUMBER_OF_GUESSES WHERE username = '$USERNAME'")
  else
    UPDATE_USER_BEST=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE username = '$USERNAME'")
  fi
fi
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
}
WELCOME
