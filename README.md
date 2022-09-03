

# ogg_dep_status.sh
This file basicallly "gets" Deployment Files for OCI OGG ( Oracle Golden Gate ) Deplpyments Replicats or Extracts

# Why to use ogg_dep_status.sh

As an OGG Administrator , one would like to always have a quick look at the status of the EXtracts and Replicats 
This tool gives the options to moniotr the extracts / replicats 


# Understanding the file ogg_dep_status.sh

OCI Provides Oracle Goolden Gate Deployments and this will be useful to download all the report files associated to a Deployment 
The File extensively uses curl API's

If you are new to curl , this will be a good pooint to start with 
https://curl.se/

The Below Link is the Oracle REST API's for Oracle Golden Gate ,
this will help get a good understanding on how REST API's are used for OCI OGG Administration Tasks

https://docs.oracle.com/goldengate/c1230/gg-winux/OGGRA/index.html

# Usage of the file 

Usage is $ ./ogg_dep_status.sh 

# Pre-requisites 

1) The availablity of the .netrc file for curl Authentication is needed 
2) jq is needed for JSON parsing
3) Python 2.7.5 or higher (preferably) to use json.tool
4) There are two files needed for list of extracts and replicats 

REP_FILE=~/dep_rep.txt
EXT_FILE=~/dep_ext.txt

This script is made in such a way that one could just list the most extracts and replicats that are needed to get the status 

$ cat ~/dep_rep.txt
MYREP

$ cat ~/dep_ext.txt
MYEXT 

# Example

-- Ensure you have your .netrc set up 
$ cat .netrc
 
machine         aaaaaaaaaaa.deployment.goldengate.ap-mumbai-1.oci.oraclecloud.com login           apiuser  password        putyourpasshere123#

-- Getting all the report files for a Replicat
 
 $ ./ogg_dep_status.sh 


# Sample Output


#########################################################
DEP OGG EXTRACTS
#########################################################

MYEXT current state is "running" last status reported 4 seconds ago
"OKNODOT\tLag unknown (timestamp mismatch between source and target)."
[ { "$schema": "ogg:trailPosition", "name": "ER", "offset": 354154108, "path": "//", "sequence": 16155 } ]


#########################################################
DEP OGG REPLICATS
#########################################################

MYREP current state is "running" with last sequence 16155 with offset 349936108 last status reported 6 seconds ago
"OKNODOT\t.Low watermark position: 236137717131.\nHigh watermark position: 236137717642.\nAt EOF, no more records to process"

