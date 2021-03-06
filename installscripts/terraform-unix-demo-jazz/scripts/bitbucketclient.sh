#!/bin/bash
sleep 60

JENKINSELB=jazz20-jenkinselb-1752892078.us-east-1.elb.amazonaws.com
BITBUCKETELB=jazz20-bitbucketelb-1647531460.us-east-1.elb.amazonaws.com
BASEURL=http://$BITBUCKETELB:7990
USER=jenkins1
PASS=jenkinsadmin
CLIENTJAR=~/atlassian-cli-6.7.1/lib/bitbucket-cli-6.7.0.jar
region=$1


#create PROJECTS in BITBUCKET
#ACTION=createProject --project 'SLF'  --name 'SLF' --description ' created from cli' --public
#java -jar $CLIENTJAR -s $BASEURL -u $USER -p $PASS --action $ACTION 
java -jar $CLIENTJAR -s $BASEURL -u $USER -p $PASS --action createProject --project "SLF"  --name "SLF" --description " created from cli" --public
#ACTION=createProject --project 'CAS'  --name 'CAS' --description ' created from cli' --public
#java -jar $CLIENTJAR -s $BASEURL -u $USER -p $PASS --action $ACTION 
java -jar $CLIENTJAR -s $BASEURL -u $USER -p $PASS --action createProject --project "CAS"  --name "CAS" --description " created from cli" --public



# UPLOADS THE REPOSITORIES INTO BITBUCKET
./scripts/bitbucketpush.sh $BITBUCKETELB
#CALLS JENKINS JOB TO INSTALL Serverless application on AWS
#curl  http://$JENKINSELB:8080/job/inst_deploy_createservice/build?token=triggerCreateService --user jenkinsadmin:jenkinsadmin
curl  -X GET -u jenkinsadmin:jenkinsadmin http://$JENKINSELB:8080/job/deploy-all-platform-services/buildWithParameters?token=dep-all-ps-71717&region=$region 
