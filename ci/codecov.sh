#!/bin/bash
#============================================================================================================#
#title           :codecov.sh
#description     :Enable to push info to codecov
#author		     :bwnyasse
#===========================================================================================================#
set -o errexit -o nounset

# Push tag only if it's not a SNAPSHOT build
if  [[ "$TRAVIS_BRANCH" == "master" && "$VERSION" != *"dev"* ]]
then
    cd $CURRENT

    #FIXME : This one must done outside of this script , kind of test of the builded docker image
    docker run --rm \
    -v $PWD:/app \
    ${DOCKER_REPOSITORY}

    cd $CURRENT/coverage || exit 1 # TODO: Better handle error

    bash <(curl -s https://codecov.io/bash) -t $CODECOV_TOKEN

    cd $CURRENT
fi