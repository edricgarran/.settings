#!/bin/bash
set -xeu

ROOT=${HOME}/.settings

ln -fs ${ROOT}/shell/pam_environment ${HOME}/.pam_environment
echo -n 'source ~/.bashrc' >${HOME}/.bash_profile
ln -fs ${ROOT}/shell/bashrc ${HOME}/.bashrc

ln -fs ${ROOT}/misc/Xdefaults ${HOME}/.Xdefaults
ln -fs ${ROOT}/misc/gitconfig ${HOME}/.gitconfig

# this is not a link because this file is altered with other stuff later
if [ ! -f ${HOME}/.ssh/config ]; then
    mkdir -p ${HOME}/.ssh
    cp ${ROOT}/misc/sshconfig > ${HOME}/.ssh/config
fi

CONFIG=${HOME}/.config
mkdir -p ${CONFIG}
ln -fs ${ROOT}/config/* ${CONFIG}

mkdir -p ${HOME}/.local/share/icons
ln -fs ${ROOT}/misc/icons/* ${HOME}/.local/share/icons
ln -fs ${HOME}/.local/share/icons ${HOME}/.icons
