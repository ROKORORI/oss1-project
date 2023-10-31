#!/bin/bash
name=Ko_SungMin
student_id=12221828
echo '--------------------------'
echo 'User Name: '$name
echo 'Student Numer: '$student_id
echo '[ MENU ]'
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'" 
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release data' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo '--------------------------'
read -p 'Enter your choice [ 1-9 ] ' number
while :
do  
    # except value
    error=0
    # 1
    if [ $number == '1' ] ; then
    	echo ''
    	read -p "Please enter the 'movie id'(1~1682):" movie_id
    	if [ $movie_id -le 1682 ] && [ $movie_id -ge 1 ] ; then
    	    echo ''
    	    awk -F \| '{if($1 == movie_id) print $0}' movie_id=$movie_id u.item
    	elif :; then
    	    error=1
    	fi
    # 2
    elif [ $number == '2' ] ; then
    	echo ''
    	read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" agreement
    	if [ $agreement == 'y' ] ; then
    	    echo ''
    	    awk -F \| 'BEGIN {cnt=0} {if ($7 == 1 && cnt < 10){cnt++ ; print $1, $2}}' u.item	
    	elif [ $agreement == 'n' ] ; then :;
    	else
    	    error=1
    	fi
    # 3
    elif [ $number == '3' ] ; then
    	echo ''
    	read -p "Please enter the 'movie id'(1~1682):" movie_id
    	if [ $movie_id -le 1682 ] && [ $movie_id -ge 1 ]; then
    	    echo ''
    	    awk -F' ' 'BEGIN{sum=0; per=0} {if ($2 == movie_id){sum += $3; per +=1}}
    	                 END{rate=sum/per; printf "average rating of %d: %1.6g\n", movie_id, rate}' movie_id=$movie_id u.data
    	else
    	    error=1
    	fi
    # 4
    elif [ $number == '4' ] ; then
    	echo ''
    	read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" agreement
    	if [ $agreement == 'y' ] ; then
    	    echo ''
    	    cat u.item | sed "s/http.*)//g" | sed -n "1,10p"
    	elif [ $agreement == 'n' ] ; then :;
    	else
    	    error=1
    	fi
    # 5
    elif [ $number == '5' ] ; then
        echo ''
    	read -p "Do you want to get the data about users from 'u.user'?(y/n)" agreement
    	if [ $agreement == 'y' ] ; then
    	    echo ''
    	    cat u.user | sed -e "s/^/|/g" -e "s/|/_/g" | sed -e 's/M/male/g' | sed -e 's/F/female/g' -e "s/_/user|/" -e "s/_/|is|/" -e "s/_/|years old|/" -e "s/_/|/" -e "s/_.*//" -e "s/|/ /g" | sed -n "1,10p"
    	elif [ $agreement == 'n' ] ; then :;
    	else
    	    error=1
    	fi
    # 6
    elif [ $number == '6' ] ; then
    	echo ''
    	read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):" agreement
    	if [ $agreement == 'y' ] ; then
    	    echo ''
    	    cat u.item | sed 's/\(..\-\)\(...\-\)\(....\)/\3\2\1/g' | sed 's/\(.......\)\(\-\)\(..\)\(\-\)/\1\3/g' | sed 's/Jan/01/g' | sed 's/Feb/02/g' | sed 's/Mar/03/g' | sed 's/Apr/04/g' | sed 's/May/05/g' | sed 's/Jun/06/g' | sed 's/Jul/07/g' | sed 's/Aug/08/g' | sed 's/Sep/09/g' | sed 's/Oct/10/g' | sed 's/Nov/11/g' | sed 's/Dec/012/g' | sed -n "1673,1682p"
    	elif [ $agreement == 'n' ] ; then :;
    	else
    	    error=1
    	fi
    # 7
    elif [ $number == '7' ] ; then
    	echo ''
    	read -p "Please enter the 'user id'(1~943):" user_id
    	if [ $user_id -ge 1 ] && [ $user_id -le 943 ] ; then
    	    echo ''
    	    movie=$(cat u.data | awk '$1 == user_id { print $2 }' user_id=$user_id | sort -n)
    	    #length
    	    length=0
    	    for var in $movie
    	    do
    	        length=$((length+1))
    	    done
    	    #movie_number
    	    cnt=0
    	    out_1=''
    	    for var in $movie
    	    do
    	        if [ $cnt -eq 0 ] ; then
    	            out_1+="$var"
    	        else
    	            out_1+="|$var"
    	        fi
    	        cnt=$((cnt+1))
    	    done
    	    echo $out_1
    	    echo ''
    	    # movie_num, movie_title
    	    cnt=0
    	    for var in $movie
    	    do  
    	        if [ $cnt -lt 10 ] ; then
    	            awk -F '|' '$1 == var { printf "%s|%s\n", $1, $2 }' var=$var u.item
    	        fi
    	        cnt=$((cnt+1))
    	    done
    	else
    	    error=1
    	fi
    # 8
    elif [ $number == '8' ] ; then
    	echo ''
    	read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" agreement
    	if [ $agreement == 'y' ] ; then
    	    # 20 <= programmer <= 29 's id
    	    pro_people=$(cat u.user | awk -F '|' '$2 >= 20 && $2 <= 29 { print $0 }' | awk -F '|' '$4 ~ /^programmer/ { print $1 }')
    	    # item length
    	    item_length=$(cat u.item | awk 'BEGIN{cnt=0}{cnt++}END{print cnt}')
    	    # array
    	    movie=()
    	    movie_rate=()
    	    for (( i=0; i<=$item_length; i++))
    	    do
    	        movie+=(0)
    	        movie_rate+=(0)
    	    done
    	    #mean
    	    for person in $pro_people
    	    do
    	        movie_num_rate=$(cat u.data | awk -F ' ' '$1 == person { print $2":"$3 }' person=$person)
    	        for cal in $movie_num_rate
    	        do
    	            movie_num=$(echo $cal | cut -d ':' -f1)
    	            movie_eval=$(echo $cal | cut -d ':' -f2)
    	            movie[$movie_num]=$((${movie[$movie_num]}+1))
    	            movie_rate[$movie_num]=$((${movie_rate[$movie_num]}+$movie_eval))     
    	        done
    	    done
    	    echo ''
    	    #print
    	    for (( i=0; i<=$item_length; i++))
    	    do
    	       if [ ${movie[$i]} -gt 0 ] ; then
    	            echo $i ${movie_rate[$i]} ${movie[$i]} | awk '{printf "%1d %1.6g\n", $1, $2/$3}'
    	       fi             
    	    done
        elif [ $agreement == 'n' ] ; then :;
    	else
    	    error=1
    	fi
    # 9
    elif [ $number == '9' ] ; then
        echo 'Bye!'
        break
    # 10 except situation
    else
        error=1
    fi
    # if error
    if [ $error -eq 1 ] ; then
        echo ''
        echo error occurred!
        echo ''
        read -p 'Enter your choice [ 1-9 ] ' number
    else
        echo ''
    	read -p 'Enter your choice [ 1-9 ] ' number   
    fi
done
