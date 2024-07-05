#!/bin/bash

# To Gra Kółko I Krzyżyk

opcja=0			# Ta zmienna pamęta ostatną wybraną opcje w menu wyboru.
exp1=0			# Punkty gracza Nr. 1
exp2=0			# Punkty gracza Nr. 2
remis=0			# Liczba remisów
planA=(. . .)		# Tablicza do wiersza Nr. A
planB=(. . .)		# Tablicza do wiersza Nr. B
planC=(. . .)		# Tablicza do wiersza Nr. C
gracz=o			# Kod gracza, który wykonuje ruch. Dla 'o' — kółko; a dla 'x' — krzyżyk.
gra=0			# Tryb gry. Dla 0 — tryb symulacji; dla 1 — gra dla jednego gracza; a dla 2 — tryb gry dla dwóch graczy.
planTEST=0		# Kod poprawności ruchu. Gdy jest 0 to ruch zostanie wykonany, a gdy kod to 1 grzcz będzię poproszony o ponowny ruch.

function pomoc ()
{
	clear
	echo " WITAJ W GRZE KÓŁKO I KRZYŻYK --→ pomoc"
	echo "———————————————————————————————————————"
	echo "Poruszanie po plansy odbywa się wpisująć kod pola planszy (9×9). Kodem planszy określamy DWA znaki pierwszy litera [od A do C], a drógi liczba [od 1 do 3]."
	echo "Litery od A do C określają wysokość, a liczby od 1 do 3 określają sierokość planszy."
	echo "Na przykład pole a2 to druge pole pierwszej linijki."
	echo "Znak zachęty ['KÓŁKO> ' lub 'KRZYŻYK> '] określa cyja jest kolej."
	echo "Gra posada 3 tryby gry:"
	echo " • Tryb symulacji —— gra się sama rozgrywa"
	echo " • Tryb gry dla 2 gracy"
	echo " • Tryb gry dla 1 gracza"
	echo ""
	
	read -p "Czy powrócyć do menu (t/N)? " opcja
	opcja=`echo $opcja | tr [:upper:] [:lower:]`

	if [[ "$opcja" == "t" || "$opcja" == "y" || "$opcja" == "tak" || "$opcja" == "yes" ]]
	then
		menu
	fi

	pomoc
}

function testplan ()
{
	case "$1" in
		"a")
			if [[ "${planA[$[$2-1]]}" == "." ]]
			then
				planA[$[$2-1]]="$gracz"
			else
				planTEST=1
			fi;;
		"b")
			if [[ "${planB[$[$2-1]]}" == "." ]]
			then
				planB[$[$2-1]]="$gracz"
			else
				planTEST=1
			fi;;
		"c")
			if [[ "${planC[$[$2-1]]}" == "." ]]
			then
				planC[$[$2-1]]="$gracz"
			else
				planTEST=1
			fi;;
		*)
			planTEST=1;;
	esac

	if [ $planTEST -eq 1 ]
	then
		planTEST=0
		case $gra in
			0)
				grasim;;
			1)
				if [[ "$gracz" == "o" ]]
				then
					echo "BŁĄD: To Pole Już Jest Zajęte!"
					ruchgracza
				else
					grasim
				fi;;
			2)
				echo "BŁĄD: To Pole Już Jest Zajęte!"
				ruchgracza;;
		esac
	fi
}

function ruchgracza ()
{
	echo ""

	case "$gracz" in
		"o")
			read -p "KÓŁKO> " opcja;;
		"x")
			read -p "KRZYŻYK> " opcja;;
	esac

	opcja=`echo $opcja | tr [:upper:] [:lower:]`

	planTEST=`echo ${opcja:0:1} | grep "[a-z]" >> /dev/null; echo $?`
	planTEST2=`echo ${opcja:1:1} | grep [0-9] >> /dev/null; echo $?`

	if [[ "$planTEST" == "0" && "$planTEST2" == "0" ]]
	then
		if [ ${#opcja} -eq 2 ]
		then
			testplan "${opcja:0:1}" ${opcja:1:1}
		else
			echo "BŁĄD: Nieprawidłowie Współrzędne!"
			ruchgracza
		fi
	elif [[ "$opcja" == "q" ]]
	then
		menu
	else
		echo "BŁĄD: Nieprawidłowie Współrzędne!"
		ruchgracza
	fi
}

function grasim ()
{
	let R1=$RANDOM%3+1
	let R2=$RANDOM%3+1

	case $R1 in
		1)
			testplan "a" $R2;;
		2)
			testplan "b" $R2;;
		3)
			testplan "c" $R2;;
	esac
}

function wytajWgra ()
{
	clear
	echo " WYTAJ W GRZE KÓŁKO I KRZYŻYK --→ gra"
	echo "——————————————————————————————————————"
	echo "KÓŁKO  : $exp1"
	echo "KRZYŻYK: $exp2"
	echo "REMIS  : $remis"
	echo ""
	echo "  1 2 3"
	echo "A ${planA[@]}"
	echo "B ${planB[@]}"
	echo "C ${planC[@]}"

}

function gra ()
{
	gra=$1
	exp1=0
	exp2=0
	remis=0

	while true
	do
		wytajWgra

		case $1 in
			0)
				grasim; sleep 0.2;;
			1)
				if [[ "$gracz" == "o" ]]
				then
					ruchgracza
				else
					grasim
				fi;;
			2)
				ruchgracza;;
		esac
	
		wytajWgra

		for (( i=0; $i<=2; i++ ))
		do
			if [[ "${planA[$i]}" == "${planB[$i]}" && "${planC[$i]}" == "${planB[$i]}" ]]
			then
				if [[ "${planB[$i]}" == "o" ]]
				then
					opcja="o"
				elif [[ "${planB[$i]}" == "x" ]]
				then
					opcja="x"
				fi
			fi
		done

		if [[ "`echo ${planA[0]}${planB[1]}${planC[2]}`" == "xxx" ]]
		then
			opcja="x"
		elif [[ "`echo ${planA[0]}${planB[1]}${planC[2]}`" == "ooo" ]]
		then
			opcja="o"
		elif [[ "`echo ${planA[2]}${planB[1]}${planC[0]}`" == "xxx" ]]
		then
			opcja="x"
		elif [[ "`echo ${planA[2]}${planB[1]}${planC[0]}`" == "ooo" ]]
		then
			opcja="o"
		elif [[ "${planA[@]}" == "o o o" || "${planA[@]}" == "x x x" ]]
		then
			if [[ "${planA[1]}" == "o" ]]
			then
				opcja="o"
			else
				opcja="x"
			fi
		elif [[ "${planB[@]}" == "o o o" || "${planB[@]}" == "x x x" ]]
		then
			if [[ "${planB[1]}" == "o" ]]
			then
				opcja="o"
			else
				opcja="x"
			fi
		elif [[ "${planC[@]}" == "o o o" || "${planC[@]}" == "x x x" ]]
		then
			if [[ "${planC[1]}" == "o" ]]
			then
				opcja="o"
			else
				opcja="x"
			fi
		fi

		if [[ "$opcja" == "o" || "$opcja" == "x" ]]
		then
			planA=(. . .)
			planB=(. . .)
			planC=(. . .)

			if [[ "$opcja" == "o" ]]
			then
				exp1=$[$exp1+1]
				echo "Wygrało KÓŁKO!"
			elif [[ "$opcja" == "x" ]]
			then
				exp2=$[$exp2+1]
				echo "Wygrał KRZYŻYK!"
			fi

			opcja="d"
			sleep 2.5
		fi


		echo ${planA[@]} ${planB[@]} ${planC[@]} | grep \\. ; planTEST=$?

		if [[ "$planTEST" == "1" ]]
		then
			echo "REMIS!"
			planA=(. . .)
			planB=(. . .)
			planC=(. . .)
			sleep 1.5
			remis=$[$remis+1]
		fi

		if [[ "$gracz" == "x" ]]
		then
			gracz="o"
		else
			gracz="x"
		fi
	done
}

function menu ()
{
	clear
	exp1=0
	exp2=0
	remis=0
	planA=(. . .)
	planB=(. . .)
	planC=(. . .)

	echo " WITAJ W GRZE KÓŁKO I KRZYŻYK"
	echo "——————————————————————————————"
	echo "1. —— Nowa Gra z Komputerem"
	echo "2. —— Nowa Gra z Innym Graczem"
	echo "3. —— Symulacja Gry"
	echo "4. —— Pomoc"
	echo "5. —— Wyjście"
	echo ""

	read -p "Podaj Nr. opcji: " opcja
	case $opcja in
		1)
			echo "Wybrałeś opcje '1. —— Nowa Gra z Komputerem'"; sleep 0.3; gra 1;;
		2)
			echo "Wybrałeś opcje '2. —— Nowa Gra z Innym Graczem'"; sleep 0.3; gra 2;;
		3)
			echo "Wybrałeś opcje '3. —— Symulacja Gry'"; sleep 0.3; gra 0;;
		4)
			echo "Wybrałeś opcje '4. —— Pomoc'"; sleep 0.3; pomoc;;
		5)
			echo "Wybrałeś opcje '5. —— Wyjście'"; sleep 0.3; exit 0;;
		*)
			echo "BŁĄD: nie ma takej opcjii"; sleep 1; menu;;
	esac
}

function main ()
{
	echo "Autorem Tego Programu Jest: TuxMenKam!"
	echo "v1.0"
	sleep 1

	menu
}

main

