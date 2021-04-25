#!/bin/bash
set -xeu

ROOT=${HOME}/.settings

ln -fs ${ROOT}/shell/pam_environment ${HOME}/.pam_environment
echo -n 'source ~/.bashrc' >${HOME}/.bash_profile
ln -fs ${ROOT}/shell/bashrc ${HOME}/.bashrc

ln -fs ${ROOT}/misc/Xdefaults ${HOME}/.Xdefaults
ln -fs ${ROOT}/misc/gitconfig ${HOME}/.gitconfig

# this is not a link because this file is altered with other stuff later
mkdir ${HOME}/.ssh
cp ${ROOT}/misc/sshconfig > ${HOME}/.ssh/config

CONFIG=${HOME}/.config
mkdir -p ${CONFIG}
ln -fs ${ROOT}/config/* ${CONFIG}

systemctl --user enable --now ${ROOT}/systemd/*
systemctl --user daemon-reload
