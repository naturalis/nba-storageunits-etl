FROM alpine 
RUN apk add --update --no-cache bash curl 
ADD push_documents.sh push_documents.sh
ADD datamodel_dummy.json datamodel_dummy.json
ENV ES_SERVER elasticsearc 
CMD push_documents.sh $IN_DIR drop_index