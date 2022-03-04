#!/bin/zsh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
VIRTUALENV_NAME="demisto-sdk-dev"

# Get current working dir
SDK_WORKDIR=`pwd`

# Arguments handling
if [[ $1 == "-h" ]]; then
  printf "This script creates environment for developing demisto-sdk, The following steps are done:
  1. Installing virtualenv-wrapper.
  2. Create virtualenv \"${VIRTUALENV_NAME}\".
  3. Installing in virtualenv demisto-sdk as editable version.

Notes:
  1. This script requires python3 installed.
  2. For more information please see the Contribution guide.
\n"
  exit 0
fi

# Validate mandatoy executables for execution
executables_exists=0
for executable in pyenv python3 git
do
    if ! command -v $executable &> /dev/null
    then
        printf "${RED}$executable isn't installed, Please install $executable before using this script!${NC}\n"
        executables_exists=1
    fi
done

if [[ executables_exists -eq 1 ]]; then
    exit 1
fi

# Validate Pyenv configure correctly
if [[ "*/.pyenv/*" = $(which python3) ]]; then
    printf "${RED}Python3 executable source isn't managed by pyenv, Please verify global var PATH configuration${NC}\n"
    exit 1
fi

# Install pyenv-vritualenvwrapper
printf "Installing pyenv-vritualenvwrapper\n"
rm -rf $(pyenv root)/plugins/pyenv-virtualenvwrapper
command git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $(pyenv root)/plugins/pyenv-virtualenvwrapper

if [ $? -eq 0 ]; then
   printf "pyenv-virtualenvwrapper installed ${GREEN}succefully${NC}\n"
else
   printf "${RED}pyenv-virtualenvwrapper can't installed using brew$\nAdditional error details:\n${output}${NC}"
   exit 1
fi

# Init PATH variables
if [[ $SHELL == *"bin/zsh"* ]]; then
    source ~/.zshrc
elif [[ $SHELL == *"bin/bash"* ]]; then
    source ~/.bash_profile
else
    printf "${RED}Currnltly only bash/zsh is supported as base shell.\n${output}${NC}"
    printf "${RED}Run 'export SHELL=/bin/zsh' or 'export SHELL=/bin/bash' and rerun the script.\n${output}${NC}"
    exit 1
fi

# Initializing pyenv-vritualenvwrapper
printf "Initiallizing pyenv-vritualenvwrapper\n"
pyenv virtualenvwrapper
echo pyenv virtualenvwrapper >> ~/.zshrc
echo pyenv virtualenvwrapper >> ~/.bash_profile

# Creating development enviorment
rmvirtualenv ${VIRTUALENV_NAME}
mkvirtualenv ${VIRTUALENV_NAME}

pip3 install -e ${SDK_WORKDIR}

# Summary log
printf "\n\nDemisto-sdk virtual env setup finished succefully:\n  1. Restart your terminal.\n  2. In order to activate enviorment ${GREEN}workon ${VIRTUALENV_NAME}${NC}\n  3. Inorder to deactivate enviorment ${RED}deactivate${NC}\n"
exit 0
