#! /bin/bash
values_file="values-DEV.yaml"
cp $values_file ${values_file}.new
json_file="vars.json"

curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $MY_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/orgs/yangyys/actions/variables > $json_file

echo $MY_TOKEN
  
