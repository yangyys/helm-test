#! /bin/bash

values_file="values-DEV.yaml"
cp $values_file ${values_file}.new

json_file="vars.json"

curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $MY_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/yangyys/actions/variables > $json_file

total_line=`cat $json_file | grep name | wc -l`

for ((i=1; i<=$total_line; i++))
do
    #name=`cat $json_file | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~"name"){print $(i+1)} }}' | tr -d '"' | sed -n ${i}p |sed 's/^[ ]*//g'`
    name=`cat $json_file | awk -F\" '{for(i=1;i<=NF;i++){if($i~"name"){print $(i+2)} }}' | tr -d '"' | sed -n ${i}p |sed 's/^[ ]*//g'`
    #value=`cat $json_file | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~"value"){print $(i+1)} }}' | tr -d '"' | sed -n ${i}p |sed 's/^[ ]*//g'`
    #value=`cat $json_file | awk -F\" '{for(i=1;i<=NF;i++){if($i~"value"){print $(i+2)} }}' | tr -d '"' | sed -n ${i}p |sed 's/^[ ]*//g'`
    value=`grep "\"value\":" $json_file |sed -n "${i}p" |awk -F\" '{print $4}'`
    echo "<\$$name>"
    echo $value

    if grep -q "<\$$name>" $values_file
    then
         sed -i "s|<\$$name>|$value|" ${values_file}.new
    fi
done
  
