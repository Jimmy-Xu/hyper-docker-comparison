#!/bin/sh

SUT=arldcn24
DIR=`pwd`

# TODO make sure /mnt/data is mounted

# build the container (assumes the spyre git repo is in NFS)
ssh $SUT docker build -t fio $DIR

# run the test

echo Running fio - this takes 5-10 minutes
ssh $SUT docker run --rm -v /mnt/data:/mnt/data fio test.fio > results/docker.log

wait
echo Experiment completed
