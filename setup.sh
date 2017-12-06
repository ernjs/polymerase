#!/bin/bash

# @todo Create a makefile for make install

# @todo Setup for multiple shells 
PROFILE=~/.zshrc;
PATH=$(pwd)

echo "PATH_POLYMERASE=$PATH" >> $PROFILE;

polymerase="docker-compose -f $PATH/docker-compose.yml run --name " 
polymerase+='${PWD##*/}'

echo "alias polymerase='$polymerase'" >> $PROFILE
echo "alias polymerase-deploy='$polymerase -u $UID deploy'" >> $PROFILE
echo "alias polymerase-web='$polymerase web'" >> $PROFILE
