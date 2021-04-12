#!/bin/bash

function hyphen {

	#printf "\n"
	for i in $( seq 1 65 )
		do 
		printf "-"
		done
	printf "\n"
}
function syntax_e {
	hyphen	
	printf "| > Use datacov [country]\n"
	printf "| Example: datacov germany\n" 
	printf "|\n| Information about the Brazilian states:\n| > use: datacov [-b] [state_acronym]\n"
	printf "| Example: datacov -b mg\n"
	hyphen
	exit
}

function template {

	hyphen
	echo -e "\t\t\t"$head
	hyphen
	echo -e "\t$cases\t\t\t   $deaths"
	echo -e "\t\t\t$recovered" 
	hyphen
	echo -e "\n\t\tSourse: covid19-brazil-api.vercel.app/"
	hyphen
	echo -e "\t\t\t stay home, stay safe"
	hyphen
	exit
}

function simple_o {
	echo $head $cases $deaths $recovered
}


br="brazil/uf/"
url="https://covid19-brazil-api.vercel.app/api/report/v1/"
data=""
br_op="-b"
file="temp"
config=3
sp0=$2
sp1=$3

if [ $# -lt 1 -o $# -gt 2 ]; then
		hyphen
		echo -e "\t\t\tSYNTAX ERROR"
		syntax_e
		exit

elif [ $# -eq 1 ]; then
			data=$(curl -s $( echo "$url$1" ))
			config=1
			
			

	elif [ "$#" -eq "2" ]; then
			if [ "$1" = "$br_op" ]; then
				data=$( curl -s $( echo "$url$br$2" ))
				config=2
	fi

fi

if [ "$config" -eq "3" ]; then
		syntax_e
fi
	
if [ $config -ne "3" ]; then
		echo $data > $file
		sed -i 's/,/\n/g' $file
		sed -i 's/"//g' $file
		sed -i 's/{/\n/g' $file
		sed -i 's/:/: /g' $file
		lines=$( wc -l $file )
		set $( echo $lines)
		if [ $1 -le "3" ]; then
		    hyphen
			echo -e "\t\t\tNOT FOUND"
			syntax_e
		fi
		
fi
		
if [ "$config" -eq "1" ]; then

	head=$( sed -n '3 p' $file )
	sed -i 's/confirmed/cases/g' $file
	cases=$( sed -n '5 p' $file )
	deaths=$( sed -n '6 p' $file )
	recovered=$( sed -n '7 p' $file )

	template
	#rm $file
fi

if [ "$config" -eq "2" ]; then

	head=$( sed -n '4 p' $file )
	head=$( echo $head"  Brazil" )
	cases=$( sed -n '5 p' $file )
	deaths=$( sed -n '6 p' $file )
	sed -i '5,6 !d' $file
	sed -i 's/:/ /g' $file
	data=$( cat $file)
	set $( echo $data)
	sum=$( echo $2 - $4 | bc -l )
	recovered=$( echo "recovered: "$sum )
	template
	#rm $file

fi

syntax_e







