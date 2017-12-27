#!/bin/bash

# @todo Create a makefile for make install

INSTALL_DIR=/usr/bin/polymerase

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

cat << EOF > $INSTALL_DIR
#!/bin/bash

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

sed -i 's/PRS_FIRST_ARG/$1/g' $INSTALL_DIR
sed -i 's/PRS_SECOND_ARG/$2/g' $INSTALL_DIR
sed -i "s#PRS_COMMAND#docker-compose -f $(pwd)\/docker-compose.yml run --name PRS_PWD#g" $INSTALL_DIR
sed -i 's/PRS_REMOVE/$remove/g' $INSTALL_DIR
sed -i 's/PRS_UID/$UID/g' $INSTALL_DIR
sed -i 's/PRS_ARGS/${@:$args_jump}/g' $INSTALL_DIR
sed -i 's%PRS_PWD%${PWD##*/}%g' $INSTALL_DIR

chmod +x $INSTALL_DIR
