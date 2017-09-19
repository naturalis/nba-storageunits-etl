#!/bin/bash

#SERVER=http://172.18.0.2:9200
SERVER=$ES_SERVER
INDEX=storageunits
DOCUMENT=Storageunit

INDIR=$1
DROP_INDEX=$2

if [ "$INDIR" == ""  ]
then
	echo "error: no input dir"
	exit
fi

if [[ $DROP_INDEX = "drop_index" ]]; then
  echo "recreating index"
  curl -XDELETE "$SERVER/$INDEX"
  echo
  curl -XPUT "$SERVER/$INDEX"
  echo
  curl -XPUT "$SERVER/$INDEX/_settings" -d '{"index" :{"number_of_replicas" : 0}}'
  echo
  DATA=$(cat datamodel_dummy.json)
  curl -XPOST "$SERVER/$INDEX/$DOCUMENT/1" -d "$DATA"
  echo
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
echo
curl -XDELETE "$SERVER/$INDEX/1"
echo
echo "done"
