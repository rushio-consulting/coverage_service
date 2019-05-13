[![Build Status](https://api.travis-ci.org/rushio-consulting/coverage_service.svg?branch=master)](https://travis-ci.org/rushio-consulting/coverage_service)

# Code coverage service 

## Purpose

The goal of this project is to provide an easy way to run the code coverage on your dart or flutter project.

This project wants to keep everything as simple as possible for developers, to avoid dealing with the setup of code coverage in your development environment.

## How to use it ? 

### with Docker

The docker image is available at the [official Docker Hub](https://hub.docker.com/r/rushioconsulting/coverage_service)

Easy to use :

    docker run --rm \
        -v $PATH_TO_MY_PROJECT:/coverage_project \
        rushioconsulting/coverage_service

where `$PATH_TO_MY_PROJECT` is the path to your dart or flutter project.


**When successful execution, the output directory will be `$PATH_TO_MY_PROJECT\coverage`**




