#!/bin/bash


controls1="Controls: UpArrow   => Up"
controls2="          DownArrow => Down"
gameOver="0"
obstacle1=">"
obstacle2="-"
declare -a line2=(_ _ _ _ _ _ _ _ _ _)
declare -a line1=(X _ _ _ _ _ _ _ _ _)
declare -a line0=(_ _ _ _ _ _ _ _ _ _)
declare -i userRow=1
declare -i newRow=0

#Description: Print the track. Lines 2, 1, and 0.
printTrack()
{
	echo
	echo "    $controls1"
	echo "    $controls2"
	echo "    ${line2[@]}"
	echo "    ${line1[@]}"
	echo "    ${line0[@]}"
}

#Description: Displays a count down from 3 to 1
countDownToStart()
{
	for i in `seq 3 1`;
	do
		echo -n "    The game begins in $i"
		printTrack
		sleep 1
		clear
	done
	echo -n "    Go!"
	printTrack
	sleep 1
	clear
}

#Description: Shows intro and starts the game
startThumper()
{
	introWaitTime=2
	clear
	
	userName=""
	echo -n "    What is your name? => "
	read userName
	clear
	
	echo -n "    Welcome, $userName..." 
	printTrack
	sleep $introWaitTime
	clear
	
}



#Description: Move player to their proper position
movePlayer()
{
	userResponce=$1
	#If user pressed Up Arrow, move the "X" icon up
	if [[ $userResponce == *A* ]]; then
		if [ $userRow -eq 0 ]; then
			if [ "${line1[0]}" == "$obstacle1" ]; then
				gameOver=1
			else
				line2[0]="_" 
				line1[0]="X"
				line0[0]="_"
			fi	
		elif [ $userRow -eq 1 ]; then
			if [ "${line2[0]}" == "$obstacle1" ]; then
				gameOver=1
			else
				line2[0]="X"
				line1[0]="_"
				line0[0]="_"
			fi
		fi
			
		newRow=$userRow+1
		if [ $newRow -lt 3 ];
		then
			userRow=$userRow+1
		fi			
	#If user pressed the Down Arrow, move the "X" icon down
	elif [[ $userResponce == *B* ]];
	then
		if [ $userRow -eq 2 ]; then
			if [ "${line1[0]}" == "$obstacle1" ]; then
				gameOver=1
			else
				line2[0]="_"
				line1[0]="X"
				line0[0]="_"
			fi
		elif [ $userRow -eq 1 ]; then
			if [ "${line0[0]}" == "$obstacle1" ]; then
				gameOver=1
			else
				line2[0]="_"
				line1[0]="_"
				line0[0]="X"
			fi
		fi
		
		newRow=$userRow-1
		if [ $newRow -gt -1 ]; then
			userRow=$userRow-1
		fi
	fi
}

#Description: Check if the user lost
checkIfLost()
{
	#If user lost, return 0
	if [ "${line2[0]}" == "X" ] && [ "${line2[1]}" == "$obstacle1" ]; then
		gameOver=1
	elif [ "${line1[0]}" == "X" ] && [ "${line1[1]}" == "$obstacle1" ]; then
		gameOver=1
	elif [ "${line0[0]}" == "X" ] && [ "${line0[1]}" == "$obstacle1" ]; then
		gameOver=1
	fi
}

#Description: Updates the game track
updateTrack()
{
	clear
	#Move all obstacles closer to the user
	oldLine2=(${line2[@]})
	if [ "${line2[0]}" == "X" ]; then
		if [ "${oldLine2[1]}" == "$obstacle1" ]; then
			gameOver=1
		fi
	else
		line2[0]=${oldLine2[1]}
	fi
	for i in `seq 1 $((${#line2[@]} - 2))`;
	do
		iPlus=$(($i+1))
		oldLinePlus2=${oldLine2[$iPlus]}
		line2[$i]=$oldLinePlus2
	done
		
	oldLine1=(${line1[@]})
	if [ "${line1[0]}" == "X" ]; then
		if [ "${oldLine1[1]}" == "$obstacle1" ]; then
			gameOver=1
		fi
	else
		line1[0]=${oldLine1[1]}
	fi
	for i in `seq 1 $((${#line1[@]} - 2))`;
	do
		iPlus=$(($i+1))
		oldLinePlus1=${oldLine1[$iPlus]}
		line1[$i]=$oldLinePlus1
	done
		
	oldLine0=(${line0[@]})
	if [ "${line0[0]}" == "X" ]; then
		if [ "${oldLine0[1]}" == "$obstacle1" ]; then
			gameOver=1
		fi
	else
		line0[0]=${oldLine0[1]}
	fi
	for i in `seq 1 $((${#line0[@]} - 2))`;
	do
		iPlus=$(($i+1))
		oldLinePlus0=${oldLine0[$iPlus]}
		line0[$i]=$oldLinePlus0
	done
}

#Description: Create an obstacle for the track
createObstacle()
{
	if [ $(($RANDOM % 3)) -eq 0 ]; then
		declare -i obstacleRow
		obstacleRow=$((RANDOM % 3))
			
		if [ "$obstacleRow" -eq 2 ]; then
			line2[9]="$obstacle1"
			line1[9]="_"
			line0[9]="_"
		elif [ "$obstacleRow" -eq 1 ]; then
			line2[9]="_"
			line1[9]="$obstacle1"
			line0[9]="_"
		elif [ "$obstacleRow" -eq 0 ]; then
			line2[9]="_"
			line1[9]="_"
			line0[9]="$obstacle1"
		fi
	else
		line2[9]="_"
		line1[9]="_"
		line0[9]="_"
	fi
}

showDefeat()
{
	clear
	echo
	echo "    Doh! You Almost Had It...    "
	echo
}
#Description: Main loop of the game
eventLoop()
{
	#Get current second
	oldTime=$((`date +%s` % 10))
	newTime=$((`date +%s` % 10))
	
	#Loop infinitely
	while [ "$gameOver" ==  "0" ];
	do
		#Reset userResponce
		userResponce=""
		
		#Echo the track
		clear
		printTrack
		
		#Read an up arrow or down arrow press from the user. 
		read -rsn3 -t 1 userResponce
		newTime=$((`date +%s` % 10))
		
		#If user pressed a key, process it
		if [ ! -z "$userResponce" ]; 
		then
			movePlayer $userResponce
		fi
		
		#Once every second, update the board
		if [ "$newTime" != "$oldTime" ]; then
			oldTime=$newTime
			checkIfLost
			updateTrack
			createObstacle
		fi		
	done
}

startThumper
countDownToStart
eventLoop
showDefeat





