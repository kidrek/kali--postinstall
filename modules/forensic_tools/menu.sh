#!/bin/bash

## Definitions
HEIGHT=15
WIDTH=80
CHOICE_HEIGHT=6
BACKTITLE="Security tools"
TITLE="Choose your Forensic Tools"
MENU="Choose one of the following options:"

StringLength_Check(){
  if [ ${#1} -eq 0 ]; then
    StringLength_result="No_description"
  else
    StringLength_result="${1// /_}"
    #StringLength_result="$1"
  fi
}

for cnf in `find ./modules/forensic_tools/ -iname "*.cnf" | sort -r`
do
  #ID=`echo $cnf | awk -F "_" '{print $1}' | awk -F "/" '{print $3}'`
  #ID=`echo $cnf | cut -f 2 -d '/' --complement | cut -f 1 -d '_' | cut -f 2 -d '/'`
  ID=`echo $cnf | awk -F "/" '{print $4}' | cut -f 1 -d '_'`
  source $cnf
  StringLength_Check "$NAME"
  NAME="$StringLength_result"
  StringLength_Check "$DESC"
  DESC="$StringLength_result"
  OPTIONS="$ID-$NAME $DESC ON $OPTIONS"
done

CHOICE=$(export DIALOGRC=./resources/configurations/.dialogrc;dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --checklist "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                $OPTIONS \
                2>&1 >/dev/tty)


echo $CHOICE
echo $CHOICE > ./.choices_forensic_tools
./postinstall.sh

## Sources
### https://morgan-durand.com/creer-des-boites-de-dialogues-en-bash/

