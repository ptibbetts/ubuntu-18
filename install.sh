#!/bin/sh

# Variables
user="${USER}"
repo="https://github.com/ptibbetts/ubuntu.git"
install="$HOME/.ubuntu"

# Text formatting
bold=$(tput bold)
normal=$(tput sgr0)

echo() {
  printf "$1\n"
}

confirm() {
  read -r -p "${1}" response
  case "$response" in
    [yY][eE][sS]|[yY])
      true
      ;;
    *)
      false
      ;;
    esac
}

# Confirmation
if ! confirm "Are you sure you want to do this? [y\N]: "; then
  echo "Cancelling…"
  exit
fi

# Exit if the scripts run into any errors
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT
set -e

# Install Git 
if ! command -v git >/dev/null; then
  echo "${bold}Git:${normal} Installing…"
  sudo apt-get update
  sudo apt-get install git -y
else
  echo "${bold}Git:${normal} Skipping, already installed."
fi

# Install Ansible
if ! command -v ansible >/dev/null; then
 echo "${bold}Ansible:${normal} Installing…"
 sudo apt-get install software-properties-common
 sudo apt-add-repository ppa:ansible/ansible
 sudo apt-get update
 sudo apt-get install ansible
else
 echo "${bold}Ansible:${normal} Skipping, already installed."
fi

# Clone the repository to the local drive and cd into it
if [ -d $install ]; then
  echo "${bold}Playbook:${normal} Already installed, attempting to update…"
  cd $install
  git pull origin master
else
  echo "${bold}Playbook:${normal} Cloning…"
  git clone $repo $install
  cd $install
fi

echo "${bold}Ansible:${normal} Installing roles…"
ansible-galaxy install -r requirements.yml 

echo "${bold}Running ansible playbook for user ${user}…"
ansible-playbook playbook.yml -e install_user=${user} -e hostname=${user} -i hosts --ask-become-pass

echo "${bold}Done!"