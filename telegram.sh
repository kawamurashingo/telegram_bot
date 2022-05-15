#!/bin/bash
BOT_ID="XXXXXXXX"
DIR=`dirname $0`

# get google calender schedule
python3 ${DIR}/get_events.py | sed -e 's:<html-blob>::g' -e 's:</html-blob>::g' -e "s:<br>:\n:g" > schedule.txt

# make text
sed -e "s/DATE/`date +%Y-%m-%d`/" ${DIR}/reverse.sed > make_reverse.sed
sed -n "/`date +%Y-%m-%d`/,/^$/p" schedule.txt  | sed -f make_reverse.sed | sed -e "s:`date +%Y-%m-%d`:`date +%m/%d`:" -e "s/~.*//" > make.txt

# make file
test -d ./FILE || mkdir ./FILE

while read line
do
echo $line  |grep -q Title && ID=`grep "\`echo $line |awk -F'　' '{print $1}' |sed -e "s/Title://"\`" ${DIR}/member |awk -F',' '{print $2}'`
echo $line  |grep -q Title && grep "`echo $line |awk -F'　' '{print $2}'`" ${DIR}/client >> ./FILE/$ID
echo $line  |grep -q Title || echo $line >> ./FILE/$ID
done < make.txt


# post telegram
for i in `ls ./FILE`
do
DATE=`tail -n1 ./FILE/$i`
#CLI=`head -n1 ./FILE/$i|sed -e 's/,/ \\\\n /g'`
CLI=`head -n1 ./FILE/$i|awk -F',' '{print $1" "$2" "$3"\\\\n"$4}'`

TXT=`cat ./FILE/$i | sed -e '1d' -e '$d' -e 's/$/ \\\\n/'`

DSC="
当日確認です。 \\n
\\n
$DATE \\n
$TXT \\n
$CLI \\n
\\n
ご確認よろしくお願い致します。
"

echo $i
curl -s  -H 'Accept: application/json' -H "Content-type: application/json" -X POST "https://api.telegram.org/bot${BOT_ID}/sendMessage?chat_id=$i" -k -d @- <<EOF
{
    "text": "${DSC}"
}
EOF

echo ""

done

rm -f ./FILE/*

exit 0
