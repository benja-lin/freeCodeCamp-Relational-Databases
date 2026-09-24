#!/bin/bash
#displays element properties
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
SILLY="I could not find that element in the database"
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]{1,3}$ ]]
  then
    IFS='|' read -r ATOMIC_NUMBER ATOMIC_MASS SYMBOL NAME TYPE MELTING_POINT_C BOILING_POINT_C<<< "$($PSQL "SELECT atomic_number, atomic_mass, symbol, name, type, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$1")"
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "$SILLY"
    else
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_C celsius and a boiling point of $BOILING_POINT_C celsius."
    fi
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    IFS='|' read -r ATOMIC_NUMBER ATOMIC_MASS SYMBOL NAME TYPE MELTING_POINT_C BOILING_POINT_C<<< "$($PSQL "SELECT atomic_number, atomic_mass, symbol, name, type, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$1'")"
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "$SILLY"
    else
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_C celsius and a boiling point of $BOILING_POINT_C celsius."
    fi
  elif [[ $1 =~ ^[A-Z][a-z]*$ ]]
  then
    IFS='|' read -r ATOMIC_NUMBER ATOMIC_MASS SYMBOL NAME TYPE MELTING_POINT_C BOILING_POINT_C<<< "$($PSQL "SELECT atomic_number, atomic_mass, symbol, name, type, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING (type_id) WHERE name='$1'")"
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "$SILLY"
    else
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_C celsius and a boiling point of $BOILING_POINT_C celsius."
    fi
  else
    echo "$SILLY"
fi
