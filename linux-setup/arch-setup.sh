#!/bin/bash

cd /tmp
mkdir fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaMono.zip
unzip CascadiaMono.zip
rm CascadiaMono.zip
cp * ~/.local/share/fonts
cd ~/
rm /tmp/fonts -rf

mkdir ~/.rezz-dotfiles
mkdir ~/.rezz-dotfiles/zsh
mkdir ~/.rezz-dotfiles/kitty
mkdir ~/.rezz-dotfiles/ssh
mkdir ~/.rezz-dotfiles/omp-themes
mkdir ~/.ssh
mkdir ~/.omp-themes
mkdir ~/.config/kitty

cd ~/.rezz-dotfiles
RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'

command_exists() {
    command -v $1 >/dev/null 2>&1
}

checkEnv() {
    ## Check for requirements.
    REQUIREMENTS='curl groups sudo'
    if ! command_exists ${REQUIREMENTS}; then
        echo -e "${RED}To run me, you need: ${REQUIREMENTS}${RC}"
        exit 1
    fi

    ## Check Package Handeler
    PACKAGEMANAGER='apt yum dnf pacman zypper'
    for pgm in ${PACKAGEMANAGER}; do
        if command_exists ${pgm}; then
            PACKAGER=${pgm}
            echo -e "Using ${pgm}"
        fi
    done

    if [ -z "${PACKAGER}" ]; then
        echo -e "${RED}Can't find a supported package manager"
        exit 1
    fi

    ## Check SuperUser Group
    SUPERUSERGROUP='wheel sudo root'
    for sug in ${SUPERUSERGROUP}; do
        if groups | grep ${sug}; then
            SUGROUP=${sug}
            echo -e "Super user group ${SUGROUP}"
        fi
    done

    ## Check if member of the sudo group.
    if ! groups | grep ${SUGROUP} >/dev/null; then
        echo -e "${RED}You need to be a member of the sudo group to run me!"
        exit 1
    fi

}

curl -o ~/.rezz-dotfiles/zsh/.zshrc https://raw.githubusercontent.com/rezzect/rezz-dotfiles/master/zsh/.zshrc
touch ~/.aliases
curl -o ~/.rezz-dotfiles/ssh/authorized_keys https://raw.githubusercontent.com/rezzect/rezz-dotfiles/master/ssh/authorized_keys
curl -o ~/.rezz-dotfiles/omp-themes/rezztheme-edit.omp.json https://raw.githubusercontent.com/rezzect/rezz-dotfiles/master/omp-themes/rezztheme-edit.omp.json
curl -o ~/.rezz-dotfiles/kitty/kitty.conf https://raw.githubusercontent.com/rezzect/rezz-dotfiles/master/kitty/kitty.conf

installDepend() {
    ## Check for dependencies.
    DEPENDENCIES='zip unzip zsh zoxide trash-cli kitty'
    echo -e "${YELLOW}Installing dependencies...${RC}"
        sudo pacman -Sy
        sudo pacman --noconfirm -S ${DEPENDENCIES}
}

installOhMyPosh() {
    if command_exists oh-my-posh; then
        echo "Oh My Posh already installed"
        return
    fi

    if ! curl -sS https://ohmyposh.dev/install.sh | sudo sh; then
        echo -e "${RED}Something went wrong during Oh My Posh install!${RC}"
        exit 1
    fi
}

linkConfig() {
    ln -svf ~/.rezz-dotfiles/zsh/.zshrc ~/.zshrc
    ln -svf ~/.rezz-dotfiles/omp-themes/rezztheme-edit.omp.json ~/.omp-themes/
    ln -svf ~/.rezz-dotfiles/kitty/kitty.conf ~/.config/kitty/
    ln -svf ~/.rezz-dotfiles/ssh/authorized_keys ~/.ssh/
}

sudo chsh -s /bin/zsh $USER

checkEnv
installDepend
installOhMyPosh

if linkConfig; then
    echo -e "${GREEN}Done!\nrestart your shell to see the changes.${RC}"
else
    echo -e "${RED}Something went wrong!${RC}"
fi
