[![Build Status](https://api.travis-ci.org/rushio-consulting/coverage_service.svg?branch=master)](https://travis-ci.org/rushio-consulting/coverage_service)
[![codecov](https://codecov.io/gh/rushio-consulting/coverage_service/branch/master/graph/badge.svg)](https://codecov.io/gh/rushio-consulting/coverage_service)

# Code Coverage Service

## Why this project

Currently getting coverage in dart is pretty complicated. You need to install a bunch of library and launch some pretty complicated command before you can know how much of your package is tested.

Our goals with this package is to help you better test your package, this project wants to keep everything as simple as possible for developers.

We provide a [docker image](https://hub.docker.com/r/rushioconsulting/coverage_service) that has everything installed to get the percentage of you tested code.


## Getting started

What do you get from the running docker container ? 

- one number that is the percentage of the covered code
- it will also create a coverage folder named `coverage` with the lcov.info file from where you can get gutter for vscode. In this folder you will also find **some static web page that show the covered percentage of each file**.


#### Easy to use :

    docker run --rm \
        -v $PATH_TO_MY_PROJECT:/app \
        rushioconsulting/coverage_service

where `$PATH_TO_MY_PROJECT` is the path to your dart or flutter project.


**When successful execution, the output directory will be `$PATH_TO_MY_PROJECT\coverage`**

## Features and bugs

Please file feature requests and bugs at [the issue tracker](https://github.com/rushio-consulting/coverage_service/issues).

## Technical Support

For any technical support, don't hesitate to contact us. Find more information in [our website](http://rushio-consulting.fr)

For now, all the issues with the label support mean that they come out of the scope of the following project. So you can contact us as a [support](https://rushio-consulting.fr/support/).
