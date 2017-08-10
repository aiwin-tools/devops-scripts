#!/usr/bin/env bash

# http://docs.sonarqube.org/display/SONARQUBE54/Breaking+the+CI+Build

if [ -n "$MAVEN_HOME" ] || [ -n "$M2_HOME" ]; then
  REPORT_INFO="target/sonar/report-task.txt"
elif [ -n "$GRADLE_HOME" ]; then
  REPORT_INFO="build/sonar/report-task.txt"
else
  echo "Sonar report path can not be obtained"
  exit -1
fi

echo "Contents of $REPORT_INFO ... "
cat "$REPORT_INFO" || (echo "The report info path $REPORT_INFO does not exists" && exit -1)

source "$REPORT_INFO"

echo "Invoking SonarQube API ..."
TASK=$(curl -u $SONAR_TOKEN: $ceTaskUrl 2>/dev/null)

if [ -z "$TASK" ]; then
    echo "Exiting due empty value in task"
    exit -1
else
    # Obtain Analisys Status
    echo "Obtaining Analisys Status ..."
    STATUS=$(echo $TASK | jq -r .task.status)
    echo "Analisys Status: $STATUS"
    SLEEP=2
    while [ "$STATUS" != "SUCCESS" ] && [ "$STATUS" != "CANCELED" ] && [ "$STATUS" != "FAILED" ]; do
        echo "Sleeping $SLEEP seconds ..."
        sleep $SLEEP

        TASK=$(curl -u $SONAR_TOKEN: $ceTaskUrl 2>/dev/null)
        STATUS=$(echo $TASK | jq -r .task.status)
        echo "Analisys Status: $STATUS"

        let SLEEP*=2
    done

    if [ "$STATUS" == "SUCCESS" ]; then
        # Obtain Analisys Id
        echo "Obtaining Analisys Id ... "
        ANALYSIS_ID=$(echo $TASK | jq -r .task.analysisId)
        echo "Analisys Id obtained: $ANALYSIS_ID"

        # Obtain Status of Analisys
        echo "Obtaining Status of Analisys ..."
        PROJECT_STATUS=$(curl -u $SONAR_TOKEN: "$SONAR_HOST_URL/api/qualitygates/project_status?analysisId=$ANALYSIS_ID" 2>/dev/null | jq -r .projectStatus.status)
        if [ "$PROJECT_STATUS" != "OK" ]; then
            echo "Exiting due sonar project status $PROJECT_STATUS"
            exit -1
        fi
    else
        echo "Exiting due sonar task status $STATUS"
        exit -1
    fi
fi
