#!/bin/bash

# See ./terraform-wrapper.md for further details.

helpFunction()
{
   echo ""
   echo "Usage: $0 -i input variable.tf"
   echo -e "\t-i Path to the variables.tf file to be parsed. Example: /tf/s/variables.tf"
   exit 1 # Exit script after printing help
}

#Sample: https://unix.stackexchange.com/questions/31414/how-can-i-pass-a-command-line-argument-into-a-shell-script
while getopts "i:" opt
do
   case "$opt" in
      i ) input="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

echo "Input is: $input"

# Check if input variable file exists
if [ ! -f "$input" ]
then
   echo "Input variable file does not exist: $input"
   helpFunction
fi

#getVariableRegEx="^variable\s+\"(.*)\"\s+{$"
getVariableRegEx="^variable[[:space:]]*\"(.*)\"[[:space:]]*"

while read p; do

  #echo the line if in matches (?:variable) "(.+)"
  if [[ $p =~ $getVariableRegEx ]]; then
      #echo $p
      #echo "${BASH_REMATCH[0]}"
      echo "${BASH_REMATCH[1]} ="
  fi 
done <$input