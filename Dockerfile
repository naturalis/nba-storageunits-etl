FROM alpine
RUN apk add --update --no-cache bash curl git
ADD push_documents.sh push_documents.sh
ADD mapping.json mapping.json
ENV ES_SERVER elasticsearch
CMD push_documents.sh $IN_DIR
# if you want to force dropping of the index (f.i. when mapping has changed):
# CMD push_documents.sh $IN_DIR drop_index