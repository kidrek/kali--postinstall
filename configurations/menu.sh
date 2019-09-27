#!/bin/bash

## Definitions
HEIGHT=15
WIDTH=80
CHOICE_HEIGHT=6
BACKTITLE="Security tools"
TITLE="Choose your settings"
MENU="Choose one of the following options:"

StringLength_Check(){
  if [ ${#1} -eq 0 ]; then
    StringLength_result="No_description"
  else
    StringLength_result="${1// /_}"
    #StringLength_result="$1"
  fi
}

for cnf in `find ./configurations/ -iname "*.cnf" | sort -n`
do
  #ID=`echo $cnf | awk -F "_" '{print $1}' | awk -F "/" '{print $3}'`
  ID=`echo $cnf | cut -f 2 -d '/' --complement | cut -f 1 -d '_' | cut -f 2 -d '/'`
  source $cnf
  StringLength_Check "$NAME"
  NAME="$StringLength_result"
  StringLength_Check "$DESC"
  DESC="$StringLength_result"
  OPTIONS="$OPTIONS $ID-$NAME $DESC OFF"
done

CHOICE=$(export DIALOGRC=./.dialogrc;dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --checklist "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                $OPTIONS \
                2>&1 >/dev/tty)


echo $CHOICE
echo $CHOICE > ./.choices_configurations
./postinstall.sh

## Sources
### https://morgan-durand.com/creer-des-boites-de-dialogues-en-bash/

