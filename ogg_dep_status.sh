#!/bin/bash
############################################################################################
#Script Name    : ogg_dep_status.sh
#Description    : Identifies Status of all Replicats / Extracts for OGG Deployment
#Args           : ogg_dep_status.sh
#Author         : Abhilash Kumar Bhattaram
#Email          : abhilash8@gmail.com
#GitHb          : https://github.com/abhilash-8/
############################################################################################

DEP_URL=https://aaaaaaaaaaa.deployment.goldengate.ap-mumbai-1.oci.oraclecloud.com
REP_FILE=~/dep_rep.txt
EXT_FILE=~/dep_ext.txt
NOW=$(date +"%Y_%m_%d_%H%M%S")
### Identify Status of Extracts
echo ""
echo " dep Replication Summary Report as on $NOW "
echo ""
echo "#########################################################"
echo "dep OGG EXTRACTS "
echo "#########################################################"
echo ""
curl -n -H "Content-Type: application/json" -H "Accept: application/json" -X GET $DEP_URL/services/v2/extracts | python -m json.tool | grep name | awk '{print $2}' | sed 's/"//g' > $EXT_FILE
for EXT_NAME in `cat $EXT_FILE`
do
        EXT_URL=$DEP_URL/services/v2/extracts/${EXT_NAME}/info/status
        EXT_LAG_URL=$DEP_URL/services/v2/extracts/${EXT_NAME}/command
        EXP_STATUS=$(curl -n  -H "Content-Type: application/json" -H "Accept: application/json" -X GET $EXT_URL | jq '.response' | jq '.status' )
        EXP_LAG=$(curl -n  -H "Content-Type: application/json" -H "Accept: application/json" -X GET $EXT_URL | jq '.response' | jq '.sinceLagReported' )
        EXP_SEQUENCE=$(curl -n  -H "Content-Type: application/json" -H "Accept: application/json" -X GET $EXT_URL | jq '.response' | jq '.position' | jq '.sequence' )
        EXP_OFFSET=$(curl -n  -H "Content-Type: application/json" -H "Accept: application/json" -X GET $EXT_URL | jq '.response' | jq '.position' | jq '.offset' )
        echo "$EXT_NAME current state is $EXP_STATUS last status reported $EXP_LAG seconds ago"
        EXT_LAG_STATUS=$(curl -n -H "Content-Type: application/json" -H "Accept: application/json" -X "POST" $EXT_LAG_URL -d $'{"command":"GETLAG"}' | jq '.response' | jq '.reply' )
        echo $EXT_LAG_STATUS
        EXT_STATS=$(curl -n -H "Content-Type: application/json" -H "Accept: application/json" -X "POST" $EXT_LAG_URL -d $'{"command":"STATUS"}' | python -m json.tool | jq '.response' | jq '.replyData'  | jq '.status' | jq '.extractWritingPosition')
        echo $EXT_STATS
        curl -n -H "Content-Type: application/json" -H "Accept: application/json" -X "POST" $EXT_LAG_URL -d $'{"command":"STATUS"}' | python -m json.tool > /tmp/${EXT_NAME}-status.json
        echo ""
done

### Identify Status of Replicats
echo ""
echo "#########################################################"
echo "dep OGG REPLICATS "
echo "#########################################################"
echo ""
curl -n -H "Content-Type: application/json" -H "Accept: application/json" -X GET $DEP_URL/services/v2/replicats | python -m json.tool | grep name | awk '{print $2}' | sed 's/"//g' > $REP_FILE
for REP_NAME in `cat $REP_FILE`
do
        REP_URL=$DEP_URL/services/v2/replicats/${REP_NAME}/info/status
        REP_LAG_URL=$DEP_URL/services/v2/replicats/${REP_NAME}/command
        REP_STATUS=$(curl -n  -H "Content-Type: application/json" -H "Accept: application/json" -X GET $REP_URL | jq '.response' | jq '.status' )
        REP_LAG=$(curl -n  -H "Content-Type: application/json" -H "Accept: application/json" -X GET $REP_URL | jq '.response' | jq '.sinceLagReported' )
        REP_SEQUENCE=$(curl -n  -H "Content-Type: application/json" -H "Accept: application/json" -X GET $REP_URL | jq '.response' | jq '.position' | jq '.sequence' )
        REP_OFFSET=$(curl -n  -H "Content-Type: application/json" -H "Accept: application/json" -X GET $REP_URL | jq '.response' | jq '.position' | jq '.offset' )
        echo "$REP_NAME current state is $REP_STATUS with last sequence $REP_SEQUENCE with offset $REP_OFFSET last status reported $REP_LAG seconds ago"
        REP_LAG_STATUS=$(curl -n -H "Content-Type: application/json" -H "Accept: application/json" -X "POST" $REP_LAG_URL -d $'{"command":"GETLAG"}' | jq '.response' | jq '.reply' )
        echo $REP_LAG_STATUS
        echo ""
        curl -n -H "Content-Type: application/json" -H "Accept: application/json" -X "POST" $REP_LAG_URL -d $'{"command":"GETLAG"}' | python -m json.tool > /tmp/${REP_NAME}-getlag.json
done


# For Detailed Logging
#curl -n -H "Content-Type: application/json" -H "Accept: application/json" -X GET  $DEP_URL/services/v2/messages  | python -m json.tool
