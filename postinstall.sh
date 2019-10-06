#!/bin/bash

## Required
if [ `dpkg -l | grep 'ii  dialog' | wc -l` -eq 0 ]; then apt install -y dialog; fi


## Definitions
HEIGHT=15
WIDTH=80
CHOICE_HEIGHT=6
BACKTITLE="Security tools"
TITLE="Choose your security tools"
MENU="Choose one of the following options:"
LOG="./log"
PWD=`pwd`

StringLength_Check(){
  if [ ${#1} -eq 0 ]; then
    StringLength_result="No_description"
  else
    StringLength_result="${1// /_}"
    #StringLength_result="$1"
  fi
}

## Select ALL features by default
dir_counter=0
for dir in `find ./modules -type d` 
do
  if [ $dir_counter -gt 0 ]
  then
    DIR_CONFIG=`echo $dir | cut -f 3 -d "/" `
    if [ ! -f ".choices_$DIR_CONFIG" ]
    then
      for cnf in `find ./modules/$DIR_CONFIG -iname "*.cnf" | sort -n`
      do
        ID=`echo $cnf | cut -f 4 -d "/" | cut -f 1 -d "_"`
        source $cnf
        StringLength_Check "$NAME"
        NAME="$StringLength_result"
        echo -n "$ID-$NAME " >> .choices_$DIR_CONFIG
      done
    fi
  fi
  let "dir_counter=dir_counter+1"
done

# Launch menu
OPTIONS=(1 "Configurations"
         2 "Forensic Tools"
         3 "Pentest Tools"
         4 "Pwn Tools"
         5 "Reverse Tools"
         6 "--------------------------"
         7 "Appliquer les modifications")

CHOICE=$(export DIALOGRC=./resources/configurations/.dialogrc; dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            ./modules/configurations/menu.sh
            ;;
        2)
	    ./modules/forensic_tools/menu.sh
            ;;
        3)
	    ./modules/pentesting_tools/menu.sh
            ;;
        4)
	    ./modules/pwn_tools/menu.sh
            ;;
	6)
	    ./postinstall.sh
	    ;;
        7)
	    clear
            echo "Application des modifications en cours.."
	    for choice_file in `find . -name ".choices_*"`
            do
	      for choice in `cd $PWD; cat $choice_file`
	      do
          echo "[*] Execution de $choice"
		      CONFIG_DIR=./modules/`echo $choice_file | cut -f 1 -d '_' --complement`
	        CONFIG_FILE=`find $CONFIG_DIR -name "\`echo $choice | awk -F \"-\" '{print $1}'\`*.cnf"`
      		#echo "choice:$choice"
      		#echo "CONFIG_DIR:$CONFIG_DIR"
      		#echo "CONFIG_FILE:$CONFIG_FILE"
	        source $CONFIG_FILE
	        eval "$COMMAND"  1>>$LOG 2>&1
	      done
            done
            ;;
esac

## Suppression des choix effectues
rm -f .choices_*

