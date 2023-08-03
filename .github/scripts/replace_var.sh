#!/bin/bash

values_file="values-DEV.yaml"
json_file="vars.json"
cp $values_file ${values_file}.new

curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $MY_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/yangyys/actions/variables > $json_file

sed -i 's/\\"//g' vars.json

#total_line=`cat $json_file | grep name | wc -l`
total_line=`grep total_count $json_file |head -n 1 |awk '{print $2}' |sed 's/,//g'`
for ((i=1; i<=$total_line; i++))
do
    #name=`cat $json_file | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~"name"){print $(i+1)} }}' | tr -d '"' | sed -n ${i}p |sed 's/^[ ]*//g'`
    #name=`cat $json_file | awk -F\" '{for(i=1;i<=NF;i++){if($i~"name"){print $(i+2)} }}' | tr -d '"' | sed -n ${i}p |sed 's/^[ ]*//g'`
    #value=`cat $json_file | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~"value"){print $(i+1)} }}' | tr -d '"' | sed -n ${i}p |sed 's/^[ ]*//g'`
    #value=`cat $json_file | awk -F\" '{for(i=1;i<=NF;i++){if($i~"value"){print $(i+2)} }}' | tr -d '"' | sed -n ${i}p |sed 's/^[ ]*//g'`
    name=`grep "\"name\":" $json_file |sed -n "${i}p" |awk -F\" '{print $4}'`
    value=`grep "\"value\":" $json_file |sed -n "${i}p" |awk -F\" '{print $4}'`
    #value=`grep "\"value\":" $json_file |sed -n "${i}p" | awk '{print $2}' | sed 's/,/ /g'`

    if grep -q "<\$$name>" $values_file
    then
        if [ $name == "IMAGE_TAG" ]
        then
            sed -i "s|<\$$name>|\"$value\"|" ${values_file}.new
        else
            sed -i "s|<\$$name>|$value|" ${values_file}.new
        fi
    fi
done
