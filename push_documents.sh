#!/bin/bash

SERVER=$ES_SERVER
INDIR=$1
DROP_INDEX=$2

INDEX=storageunits
DOCUMENT=Storageunit

if [ "$INDIR" == "" ]
then
	echo "error: no input dir"
	exit 1
fi

function create_index {
  curl -XPUT "$SERVER/$INDEX"
  DATA=$(cat mapping.json)
  curl -XPUT "$SERVER/$INDEX/_mapping/$DOCUMENT" -d "$DATA"
}  

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$SERVER/$INDEX")

if [[ $DROP_INDEX = "drop_index" && $HTTP_CODE = "200" ]]; then
  echo "recreating index"
  curl -XDELETE "$SERVER/$INDEX"
  create_index
else
  if [[ $HTTP_CODE = "404" ]]; then  
    echo "creating index"
    create_index
  fi
fi

echo "importing new $INDEX/$DOCUMENT documents"
FILES=$INDIR/*.bulk

for f in $FILES
do
  if [[ -f $f ]]; then
    echo $f
    curl -XPOST "$SERVER/$INDEX/$DOCUMENT/_bulk"  --data-binary @$f
  fi
done
echo "done"
