#!/bin/bash



function psping(){
    
    timeout=1
    local OPTIND

    while getopts c:t:u: opt
    do
    
        case $opt in
            c)
                pings_limit=$OPTARG
                ;;
            t)
                timeout=$OPTARG
                ;;
            u)
                user=$OPTARG
                ;;
          
        esac
    done
    shift $(($OPTIND - 1))
    process_name=$1

    if [ -z "$pings_limit" ]; then
            for((i=0; i<10 ;++i)); do
                    echo "runing infinite amount of pings press ctrl+c to stop and set -c some_numeric_value for example  -c 5  in your command"
                    if [ -z "$user" ];
                    then
                    echo "Pinging $process_name for any user"
                    ps -ef| grep -q $process_name | wc -l
                    else
                    echo "Pinging $process_name for user $user"
                    ps -u $user | grep -q $process_name | wc -l    
                    fi

                    sleep $timeout
            done
    fi
  
    START=1
    END=$pings_limit
    for (( c=$START; c<=$END; c++ ))
    do
                    if [ -z "$user" ];
                    then
                    echo "Pinging $process_name for any user"
                    ps -ef| grep -q $process_name | wc -l
                    else
                    echo "Pinging $process_name for user $user"
                    ps -u $user | grep -q $process_name | wc -l    
                    fi
    sleep $timeout
    done
}