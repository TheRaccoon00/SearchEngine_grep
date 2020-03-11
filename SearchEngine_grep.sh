  #!/bin/bash

if [ -z "$2" ] || [ -z "$1" ]
then
  echo "At least one argument is missing !"
  echo "sh SearchEngine_grep.sh [URL] [KEYWORD]"
  exit 1
fi

browse_recursively () {
  wget -q --tries=5 --output-document=.website $1
  while read line; do
    echo $line | grep $2
  done < ".website"

  check=$(cat .website | wc -l)
  if [ $check  =  0 ]
  then
    return
  fi

  grep -Eo 'href="[^\"]+"' .website | while read line; do
    browse_recursively $(echo ${line:6:-1}) $2
  done

}

browse_recursively $1 $2
