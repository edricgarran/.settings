#!/bin/bash
set -xeu

ROOT=${HOME}/.settings

ln -fs ${ROOT}/shell/pam_environment ${HOME}/.pam_environment
echo -n 'source ~/.bashrc' >${HOME}/.bash_profile
ln -fs ${ROOT}/shell/bashrc ${HOME}/.bashrc

ln -fs ${ROOT}/misc/gitconfig ${HOME}/.gitconfig
ln -fs ${ROOT}/misc/clang-format ${HOME}/.clang-format
ln -fs ${ROOT}/misc/prettierrc ${HOME}/.prettierrc
ln -fs ${ROOT}/misc/pylintrc ${HOME}/.pylintrc

# this is not a link because this file is altered with other stuff later
if [ ! -f ${HOME}/.ssh/config ]; then
    mkdir -p ${HOME}/.ssh
    cp ${ROOT}/misc/sshconfig ${HOME}/.ssh/config
fi

CONFIG=${HOME}/.config
mkdir -p ${CONFIG}
ln -fs ${ROOT}/config/* ${CONFIG}
