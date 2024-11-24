#!/bin/bash

# Import OS info as variables
. /etc/os-release

# ==== Check if running Arch ==== #

if [[ $ID != 'arch' ]] && [[ $1 != '-f' ]]; then
  echo 'Arch Linux not detected.'
  echo 'This script only works on Arch or Arch based distros.'
  echo 'If you are on an Arch based distro or would just like to continue, run the script with the -f option.'
  exit 1
fi

printf '\033[1;33mWARNING:\033[0m Most of the script has undergone VERY minimal testing and some parts have recieved none at all.\n'
printf '\033[1;33mWARNING:\033[0m The script is currently likely to cause issues and will NOT quite fully install the config.\n'
read -p 'Continue anyways? (y/N) ' confirmation
confirmation=$(echo "$confirmation" | tr '[:lower:]' '[:upper:]')
if [[ "$confirmation" == 'N' ]] || [[ "$confirmation" == '' ]]; then
  exit 0
fi

# ==== Back up function ==== #

error() {
  printf "\033[0;31mERROR: \033[0m $1"
  exit 1
}

backUp() {
  # SYNTAX: Backup-path:string items:array
  backupPath="$1"
  shift  # Shift args to the left (removes $1 from $@)
  items=("$@")

  if [[ ! -e "$backupPath"/.backup ]]; then mkdir "$backupPath"/.backup; fi
  local backedUp=false
  for item in "${items[@]}"; do
    if [[ -e "$backupPath"/"$item" ]]; then
      echo "Backing up ${backupPath}/${item}"
      mv ${backupPath}/${item} ${backupPath}/.backup  || error "Failed to back up: ${backupPath}/${item}"
      backedUp=true
    fi
  done
  if [[ "$backedUp" = true ]]; then
    echo "Backed up items have been stored in ${backupPath}/.backup"
  else
    rm -d ${backupPath}/.backup > /dev/null 2>&1 || true  # Don't show error if failed to delete. Will fail if not empty dir.
  fi
}

# ==== Install packages ==== #

echo 'Installing packages...'
{
  sudo pacman --needed --noconfirm -Syu rustup pipewire-jack
  sudo pacman --needed --noconfirm -S \
    hyprland hyprpaper hyprcursor hyprlock waybar rofi-wayland swaync yad mate-polkit \
    kitty zsh starship neovim luajit stow neofetch hypridle cliphist grim slurp \
    kvantum kvantum-qt5 qt5ct qt6ct gtk2 gtk3 gtk4 \
    cargo base-devel fftw iniparser autoconf-archive pkgconf xdg-user-dirs wget unzip \
    pulseaudio pamixer ocean-sound-theme alsa-lib sox \
    ttf-cascadia-code ttf-cascadia-code-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
  sudo pacman --needed --noconfirm -Rs grml-zsh-config
} || error 'Failed to install required packages'

if [[ ! -d $HOME/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
# TODO: Fully automate installation of omz

{
  if [[ ! -e $HOME/.cargo/bin/macchina ]]; then
    rustup default stable
    cargo install macchina
  fi
} || error 'Failed to install Macchina'

{
  if [[ ! -e /usr/bin/syshud ]]; then
    if [[ -e ./syshud ]]; then
      mv ./syshud ./syshud.bak
    fi
    git clone https://aur.archlinux.org/syshud.git syshud
    cd syshud
    makepkg -si --noconfirm --needed  # -s will install deps, -i installs automatically
    cd ..
    rm -rf ./syshud
  fi
} || error 'Failed to install Syshud'

# ==== Install sddm ==== #

{
  if [[ ! $(pacman -Q sddm > /dev/null 2>&1) ]]; then
    read -p 'Install sddm? (Y/n) ' instSDDM
    instSDDM=$(echo "$instSDDM" | tr '[:lower:]' '[:upper:]')
    if [[ "$instSDDM" == 'Y' ]] || [[ "$instSDDM" == '' ]]; then
      echo 'Installing sddm...'
      sudo pacman --noconfirm -S sddm
      sudo systemctl enable sddm.service
    fi
  fi
} || error 'Failed to install SDDM'

# ==== Backup exsisting config dirs ==== #

backupItems=(Hyprland-Dots Scripts)
backUp $HOME "${backupItems[@]}"

backupItems=(.backup cava hypr kitty Kvantum macchina nvim rofi swaync waybar starship.toml)
backUp $HOME/.config "${backupItems[@]}"

# ==== Install new config ==== #

# Back up GTK themes
if [[ -e $HOME/.themes ]]; then
  themeDirs=(Everforest Everforest-hdpi Everforest-xhdpi \
            CatMocha CatMocha-hdpi CatMocha-xhdpi \
            Rose-Pine Rose-Pine-hdpi Rose-Pine-xhdpi)
  backUp $HOME/.themes "${themeDirs[@]}"
fi

# Back up icons and cursors
if [[ -e $HOME/.icons ]]; then
  iconDirs=(Everfoest-Dark Papirus Papirus-Dark Papirus-Light Rose-Pine \
            catppuccin-cursors catppuccin-cursors-light everforest-cursors everforest-cursors-light rose-pine-cursors rose-pine-cursors-light)
  backUp $HOME/.icons "${iconDirs[@]}"
fi

# Clone repo and symlink with stow
git clone https://github.com/SirEthanator/Hyprland-Dots.git $HOME/Hyprland-Dots || error 'Failed to clone repo'
cd $HOME/Hyprland-Dots || error 'Failed to cd into repo'
stow . || error 'Symlinking with Stow failed'

{
read -p 'Change .zshrc? (y/N) ' modifyZshrc
modifyZshrc=$(echo "$modifyZshrc" | tr '[:lower:]' '[:upper:]')
if [[ "$modifyZshrc" == 'Y' ]]; then
  backUp $HOME '.zshrc'
  cp $HOME/Hyprland-Dots/.zshrc-default $HOME/.zshrc
fi
} || error 'Failed to install new .zshrc'

echo 'Installation complete!'

