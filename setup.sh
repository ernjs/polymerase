#!/bin/bash

# @todo Create a makefile for make install

# @todo Setup for multiple shells 
PROFILE=~/.zshrc;

cat << EOF >> $PROFILE
function polymerase () {
	remove=''
	args_jump=2

	if [[ "PRS_FIRST_ARG" = 'rm' ]]; then
		remove+='--rm'
		args_jump=3
	fi

	if [[ "PRS_FIRST_ARG" = 'deploy' ]] || [[ "PRS_SECOND_ARG" = 'deploy' ]]; then
		PRS_COMMAND PRS_REMOVE -u PRS_UID deploy PRS_ARGS
		return
	fi

	if [[ "PRS_FIRST_ARG" = 'web' ]] || [[ "PRS_SECOND_ARG" = 'web' ]]; then
		PRS_COMMAND PRS_REMOVE web PRS_ARGS
		return
	fi
}
EOF

sed -i 's/PRS_FIRST_ARG/$1/g' $PROFILE
sed -i 's/PRS_SECOND_ARG/$2/g' $PROFILE
sed -i "s#PRS_COMMAND#docker-compose -f $(pwd)\/docker-compose.yml run --name PRS_PWD#g" $PROFILE
sed -i 's/PRS_REMOVE/$remove/g' $PROFILE
sed -i 's/PRS_UID/$UID/g' $PROFILE
sed -i 's/PRS_ARGS/${@:$args_jump}/g' $PROFILE
sed -i 's%PRS_PWD%${PWD##*/}%g' $PROFILE

