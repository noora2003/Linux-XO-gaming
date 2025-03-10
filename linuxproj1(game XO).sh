# display the name of players
welcome_message(){
echo "-----------------------------------------"
echo "welcome to the XO game ,hope you have fun!"
echo "-----------------------------------------"
echo "please enter the first name player :"
read name1
echo "please enter the second name player :"
read name2
echo  player one name is: $name1  and palyer two name is :$name2
read -p "player#1 $name1 choose X or O :" choose1
read -p "player#2 $name2 choose X or O :" choose2
}
welcome_message
echo ----------------------------------------
################################################
#reset the board
declare -A my_grid
reset_grid(){
echo Enter the size of grid 3,4 or 5
read size
for((i=0;i<$size;i++))
do
for((j=0;j<$size;j++))
do
my_grid[$i,$j]=" "    #reset the grid
done
printf "\n"
done

}
###############################################
# display the empty grid
print_grid(){
printf "\n"
for((i=0;i<$size;i++))
do
echo -n "$(($i+1))-|"
for((j=0;j<$size;j++))
do
#echo -n $(($j+1))
echo -n "${my_grid[$i,$j]}""|" 
done
printf "\n"
done
}

#################################################
#play on empty grid
player_moves(){
printf "\n"
k=0
max=$((size*size))
result=0
round=1
echo Now to play just enter the number of row then the number of column from 1 to $size for example: 1 2
printf "\n"
while [ "$k" -lt "$max" ];
 do

#player 1 moves
if [ "$round" -eq 1 ];
then
echo player#1 $name1 enter your move row then column 
read row column
row=$((row-1))
column=$((column-1))
choice=$choose1
else
#player2 move
echo player#2 $name2 enter your move row then column
read row column
row=$((row-1))
column=$((column-1))
choice=$choose2
fi

if [ "${my_grid[$row,$column]}" != " " ];  # check if the cell available
then
echo Invalid move, try again!
continue
else
my_grid[$row,$column]=$choice
k=$((k+1))
print_grid
check_winner $choice
result=$?
fi
printf "\n"

#check the winner
if [ "$result" -eq 1 ];
then
echo player $choice is win !
break
fi
round=$((3-round)) #switch the player
done

if [ "$result" -eq 0 ];
then
echo GAME IS TIE,NO WINNER!
fi

}

#################################################
#check the winner
check_winner(){
 winner=$1
#check row
for((i=0;i<$size;i++)) do
flag1=1
for((j=0;j<$size;j++)) do
if [ "${my_grid[$i,$j]}" != "$winner" ];
 then
flag1=0
break
fi
done
#check winner
if [ "$flag1" -eq 1 ];
then
#echo  player $winner is win !
return 1
fi
done

#check column
for((i=0;i<$size;i++)) do
flag2=1
for((j=0;j<$size;j++)) do
if [ "${my_grid[$j,$i]}" != "$winner" ];
then
flag2=0
break
fi
done

#check winner
if [ "$flag2" -eq 1 ];
then
#echo player  $winner is win !
return 1
fi
done

#check the left diagonal

for((i=0;i<$size;i++)) do
flag3=1
if [ "${my_grid[$i,$i]}" != "$winner" ] ;
then
flag3=0
break
fi
done

#check the winner
if [ "$flag3" -eq 1 ];
then
#echo player $winnner is win!
return 1
fi

#check the right diagonal

for((i=0;i<$size;i++)) do
flag4=1
if [ "${my_grid[$i,$(($size-1-$i))]}" != "$winner" ];
then
flag4=0
break
fi
done


#check the winner
if [ "$flag4" -eq 1 ];
then
#echo player $winner is win!
return 1
fi

#echo no winner yet
return 0
}

####################################################
#load from text file
declare -A array
load_file(){
echo Enter the number of moves
read moves
echo Enter the name of file you would to creat
read  name_file
touch $name_file
echo the file $name_file has been created
printf "\n"
pico $name_file        #open the file
file=$(cat $name_file)  #read the file line by line
for line in $file
do
echo $line
done
printf "\n"
#split the content of file
IFS=';' read -ra value1 <<<"$file"       #split by | and store in value1, IFS(internal feild separator)
for((i=0;i<${#value1[@]};i++))do              # IFS is assign a special delimiter
IFS='|' read -ra value2 <<< "${value1[i]}"
for((j=0;j<${#value2[@]};j++))do
array[$i,$j]=${value2[j]}
done
done
#display the array
print_array
printf "\n"
counter=0
players=1
score1=0
score2=0
while [ "$counter" -lt "$moves" ];
do
echo "---------- ROUND:$((counter+1))----------"
while :
do
if [ "$players" -eq 1 ];
then
echo "---------- player#1:$name1's move ----------"
choose=$choose1
else
echo "---------- player#2:$name2's move ----------"
choose=$choose2
fi
echo 1- placing in an empty cell
echo 2- Removing from an occupied cell
echo 3- Exchanging row
echo 4- Exchanging columns
echo 5- Exchanging the position of marks
echo 6- Exit
echo 'select the number of move'
read instruction
case $instruction in
1) move_1 $choose
   print_array
    ;;
2) move_2 $choose
   print_array
   ;;
3) move_3
   print_array
   ;;
4) move_4
   print_array
   ;;
5) move_5
   print_array
   ;;
6) exit;;
*) echo invalid option;;
esac

#scoring plan
if [ "$instruction" -eq 2 ];
then

if [ "$players" -eq 1 ];
then
score1=$((score1+1))
else
score2=$((score2+1))
fi

elif [ "$instruction" -eq 3 ] || [ "$instruction" -eq 4 ];
then

if [ "$players" -eq 1 ];
then
score1=$((score1+1))
else
score2=$((score2+1))
fi

elif [ "$instruction" -eq 5 ];
then

if [ "$players" -eq 1 ];
then
score1=$((score1+2))
else
score2=$((score2+2))
fi

fi
break
done
players=$((3-players))
counter=$((counter+1))

done
echo score1 $score1
echo score2 $score2
 if [ "$score1" -gt "$score2" ];
then
echo player1 $name1 is win
elif [ "$score2" -gt "$score1" ];
then
echo player2 $name2 is win
else
echo no winner
fi
echo FINISH GAME!!


}
#################################################3
print_array(){
for((i=0;i<${#value1[@]};i++)) do
for((j=0;j<${#value2[@]};j++)) do
echo -n "|""${array[$i,$j]}""|"
done
printf "\n"
done
}
##################################################
# move 1:placing mark in an empty cell
move_1(){
arg=$1
found=0
for((i=0;i<${#value1[@]};i++))do
for((j=0;j<${#value2[@]};j++))do
if [ "${array[$i,$j]}" = " " ];
then
array[$i,$j]=$arg
found=1
break 2
fi
done
done
if [ "$found" -eq 0 ];
then
echo THERE IS NO EMPTY CELL
fi

}
###################################################
#move2: remove mark
move_2(){
while :
do
echo Enter the number of row and column to remove the mark
read x y
x=$((x-1))
y=$((y-1))
arg=$1
found=0

#for((i=0;i<${#value1[@]};i++))do
#for((j=0;j<${#value2[@]};j++))do
if [ "${array[$x,$y]}" = "$arg" ];
then
array[$x,$y]=" "
found=1
break
fi
#done
#done
if [ "$found" -eq 0 ];
then
echo 'YOU CANT REMOVE!,try again'
continue
fi
done
}
##########################################################
#move3:exchanging row
move_3(){
while :
do
echo Enter the number of rows to exchange for example:r23
read exchange
temp=0
if [[ "$exchange" =~ ^r[0-9][0-9]$ ]];   #check the format
then
row1=${exchange:1:1}
row1=$((row1-1))
row2=${exchange:2:1}
row2=$((row2-1))
#echo  row1 $row1 and row2 $row2
for ((i=0;i<${#value1[@]};i++)) do
temp="${array[$row1,$i]}"
array[$row1,$i]="${array[$row2,$i]}"
array[$row2,$i]="$temp"
done
break
else
echo WRONG INPUT FORMATE,try again

fi
done
}
##############################################################
#move4:exchange column
move_4(){
while :
do
echo Enter the number of columns to exchange for example :c23
read exchange
temp=0
if [[ "$exchange" =~ ^c[0-9][0-9]$ ]];
then
n1=${exchange:1:1}
n1=$((n1-1))
n2=${exchange:2:1}
n2=$((n2-1))
for((i=0;i<${#value1[@]};i++))do
temp="${array[$i,$n1]}"
array[$i,$n1]="${array[$i,$n2]}"
array[$i,$n2]="$temp"
done
break
else
echo WRONG INPUT FORMAT,try again
fi
done
}
##########################################################
#move5:exchange the position of marks
move_5(){
while :
do
echo Enter the number of row and columns to exchange the position of mark for example:e1232
read pos
temp=0
if [[ "$pos" =~ ^e[0-9][0-9][0-9][0-9]$ ]]
then
row1=$(( ${pos:1:1} -1 ))
column1=$(( ${pos:2:1} -1))
row2=$((${pos:3:1} -1))
column2=$((${pos:4:1}-1))
if [ "${array[$row1,$column1]}" != " " ] &&  [ "${array[$row2,$column2]}" != " " ];
then
temp="${array[$row1,$column1]}"
array[$row1,$column1]="${array[$row2,$column2]}"
array[$row2,$column2]="$temp"
break
else
echo EMPTY CELL!!
continue
fi

else
echo WRONG INPUT FORMAT,try again
continue
fi
done
}
#############################################################

#menu
menu_1(){
while :
do
echo 1- initiate an empty grid
echo 2- load from text file
echo 3- 'Exit from menu'
echo 'select the number of instruction:'
read number
case $number in
1) reset_grid
print_grid
player_moves;;
2) load_file;;
3) echo 'Exit the program' 
 exit;;
*) echo invalid option;;
esac
done
 }
menu_1









