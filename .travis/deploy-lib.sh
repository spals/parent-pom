#!/bin/bash
cd `dirname $0`/..

if [ -z "${SONATYPE_USERNAME}" ]
then
    echo "error: please set SONATYPE_USERNAME and SONATYPE_PASSWORD environment variable"
    exit 1
fi

if [ -z "${SONATYPE_PASSWORD}" ]
then
    echo "error: please set SONATYPE_PASSWORD environment variable"
    exit 1
fi

TRAVIS_SETTINGS_XML=${1}
echo "using Maven settings.xml at ${TRAVIS_SETTINGS_XML}"
if [ ! -z "${TRAVIS_TAG}" ]
then
    echo "on a tag -> set pom.xml <version> to ${TRAVIS_TAG}"
    mvn --settings ${TRAVIS_SETTINGS_XML} org.codehaus.mojo:versions-maven-plugin:2.1:set -DgenerateBackupPoms=false -DnewVersion=${TRAVIS_TAG} 1>/dev/null 2>/dev/null
    mvn --batch-mode --settings ${TRAVIS_SETTINGS_XML} --update-snapshots clean deploy -Ddeploy -DskipTests

    # Create new SNAPSHOT version by incrementing the patch
    TRAVIS_TAG_ARRAY=( ${TRAVIS_TAG//./ } )
    ((TRAVIS_TAG_ARRAY[-1]++))

    function join { local IFS="$1"; shift; echo "$*"; }
    NEW_SNAPSHOT_VERSION="$(join . ${TRAVIS_TAG_ARRAY[@]})-SNAPSHOT"

    echo "**POST RELEASE COMMAND: mvn versions:set -DgenerateBackupPoms=false -DnewVersion=${NEW_SNAPSHOT_VERSION}"
else
    echo "not on a tag -> keep snapshot version in pom.xml"
    mvn --batch-mode --settings ${TRAVIS_SETTINGS_XML} --update-snapshots clean deploy -Ddeploy -DskipTests
fi
