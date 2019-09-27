#!/bin/bash

## Definitions
HEIGHT=15
WIDTH=80
CHOICE_HEIGHT=6
BACKTITLE="Security tools"
TITLE="Choose your security tools"
MENU="Choose one of the following options:"
env DIALOGRC="./dialogrc"

OPTIONS=(1 "Configurations"
         2 "Forensic Tools"
         3 "Pentest Tools"
         4 "Reverse Tools"
         5 "--------------------------"
         6 "Appliquer les modifications")

## Required
if [ `dpkg -l | grep 'ii  dialog' | wc -l` -eq 0 ]; then apt install -y dialog; fi

CHOICE=$(export DIALOGRC=./.dialogrc; dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            ./configurations/menu.sh
            ;;
        2)
	    ./forensic_tools/menu.sh
            ;;
	3)
	    ./postinstall.sh
	    ;;
        6)
	    clear
            echo "Application des modifications en cours.."
	    for choice_file in `find . -name ".choices_*"`
            do
	      for choice in `cat $choice_file`
	      do
		CONFIG_DIR=`echo $choice_file | cut -f 1 -d '_' --complement`
	        CONFIG_FILE=`find $CONFIG_DIR -name "\`echo $choice | awk -F \"-\" '{print $1}'\`*.cnf"`
	        source $CONFIG_FILE
	        eval "$COMMAND"
	      done
            done
            ;;
esac

## Suppression des choix effectues
rm -f .choices_*

