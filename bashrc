CONFIGURATION_DIR=~/configuration

source ${CONFIGURATION_DIR}/bash/env
source ${CONFIGURATION_DIR}/bash/config
source ${CONFIGURATION_DIR}/bash/aliases

if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi

