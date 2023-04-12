#!/bin/bash
twelve=36
workload=$1
number=$2
how='eager'

echo $workload
echo $number

# how to use:
# $ ./sort_and_parse_baseline.sh w7 0

rm /home/yunchae/EMDC/logs/parsed_TIME_STAMP\_$workload\_$how\_$number.txt;
touch /home/yunchae/EMDC/logs/parsed_TIME_STAMP\_$workload\_$how\_$number.txt;

rm normalized_parsed_TIME_STAMP\_$workload\_$how\_$number.txt;
touch normalized_parsed_TIME_STAMP\_$workload\_$how\_$number.txt;

rm /home/yunchae/EMDC/logs/parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt;
touch /home/yunchae/EMDC/logs/parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt;

rm normalized_parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt;
touch normalized_parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt;

cat /home/yunchae/EMDC/logs/log\_$workload\_$how\_$number.txt | grep "TIME STAMP (BEMPS_BEGIN)" > /home/yunchae/EMDC/logs/TIME_STAMP\_$workload\_$how\_$number.txt
cat /home/yunchae/EMDC/logs/TIME_STAMP\_$workload\_$how\_$number.txt | sort > sorted_TIME_STAMP\_$workload\_$how\_$number.txt

# bemps free가 호출된 TIME STAMP는 여기에 출력
cat /home/yunchae/EMDC/logs/log\_$workload\_$how\_$number.txt | grep "TIME STAMP (BEMPS_FREE)" > /home/yunchae/EMDC/logs/TIME_STAMP\_$workload\_$how\_free_$number.txt
cat /home/yunchae/EMDC/logs/TIME_STAMP\_$workload\_$how\_free_$number.txt | sort > sorted_TIME_STAMP\_$workload\_$how\_free_$number.txt

cat sorted_TIME_STAMP\_$workload\_$how\_$number.txt | while read line;
do
string=$line;
array=(${string});
echo -n ${array[4]} " " >> /home/yunchae/EMDC/logs/parsed_TIME_STAMP\_$workload\_$how\_$number.txt;
echo ${array[7]} >> /home/yunchae/EMDC/logs/parsed_TIME_STAMP\_$workload\_$how\_$number.txt;
done

cat sorted_TIME_STAMP\_$workload\_$how\_free_$number.txt | while read line;
do
string=$line;
array=(${string});
echo -n ${array[4]} " " >> /home/yunchae/EMDC/logs/parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt;
echo ${array[7]} >> /home/yunchae/EMDC/logs/parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt;
done

start=0
cnt=0

cat parsed_TIME_STAMP\_$workload\_$how\_$number.txt | while read line;
do
string=$line;
array=(${string});

if [ $cnt -eq 0 ]
then
start=$((${array[0]}))
# echo $start
fi

tid=${array[1]}


echo -n $(( $tid % $twelve )) " " >> normalized_parsed_TIME_STAMP\_$workload\_$how\_$number.txt ;
echo $(( $((${array[0]})) - $start ))>> normalized_parsed_TIME_STAMP\_$workload\_$how\_$number.txt ;
cnt=$((cnt+1));
done

echo "----------------------" >> normalized_parsed_TIME_STAMP\_$workload\_$how\_$number.txt ;
cat log\_$workload\_$how\_$number.txt | grep "bemps_beacon" >> normalized_parsed_TIME_STAMP\_$workload\_$how\_$number.txt ;


cat parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt | while read line;
do
string=$line;
array=(${string});

# echo ${array[0]}

string2=`head -n 1 parsed_TIME_STAMP\_$workload\_$how\_$number.txt`
array2=(${string2})
start=$((${array2[0]}))

echo -n $start " ";
echo ${array[0]}

tid=${array[1]}
# echo $(( $((${array[0]})) - $start ))

echo -n $(($tid % $twelve)) " " >> normalized_parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt ;
echo $(( $((${array[0]})) - $start ))>> normalized_parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt ; 

done 

echo "----------------------" >> normalized_parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt ;
cat log\_$workload\_$how\_$number.txt | grep " bemps_free" >> normalized_parsed_TIME_STAMP\_$workload\_$how\_free_$number.txt ;