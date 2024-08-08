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

# ==== Install packages ==== #

echo 'Installing packages...'
sudo pacman --needed -Syu rustup pipewire-jack
sudo pacman --needed -S \
  hyprland hyprpaper hyprcursor hyprlock waybar rofi-wayland swaync yad mate-polkit \
  kitty zsh starship neovim luajit stow neofetch hypridle cliphist grim slurp \
  kvantum kvantum-qt5 qt5ct qt6ct gtk2 gtk3 gtk4 \
  cargo base-devel fftw iniparser autoconf-archive pkgconf xdg-user-dirs wget unzip \
  pulseaudio ocean-sound-theme alsa-lib sox \
  ttf-cascadia-code ttf-cascadia-code-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
sudo pacman --needed -Rs grml-zsh-config

if [[ ! -d $HOME/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
if [[ ! -e $HOME/.cargo/bin/macchina ]]; then
  rustup default stable
  cargo install macchina
fi
# TODO: Install SwayOSD

# ==== Install sddm ==== #

if [[ ! $(pacman -Q sddm > /dev/null 2>&1) ]]; then
  read -p 'Install sddm? (Y/n) ' instSDDM
  instSDDM=$(echo "$instSDDM" | tr '[:lower:]' '[:upper:]')
  if [[ "$instSDDM" == 'Y' ]] || [[ "$instSDDM" == '' ]]; then
    echo 'Installing sddm...'
    sudo pacman -S sddm
    sudo systemctl enable sddm.service
  fi
fi

# ==== Backup exsisting config dirs ==== #

if [[ -e $HOME/Scripts ]]; then
  mv $HOME/Scripts $HOME/Scripts.bak
fi

if [[ -e $HOME/Hyprland-Dots ]]; then
  mv $HOME/Hyprland-Dots $HOME/Hyprland-Dots.bak
fi

if [[ -e $HOME/.config/.backup ]]; then
  mv $HOME/.config/.backup $HOME/.config/.backup.bak  # Backup backup :)
fi

backupItems=(cava hypr kitty Kvantum macchina nvim rofi starship swaync waybar starship.toml)

for item in ${backupItems[@]}; do
  if [[ -e $HOME/.config/$item ]]; then
    echo "Backing up ~/.config/${item}..."
    mv $HOME/.config/$item $HOME/.config/.backup/$item
    backedUp=true
  fi
done

if [[ "$backedUp" = true ]]; then
  echo 'Backed up items have been stored in ~/..config/.backup'
fi

# ==== Install new config ==== #

cd $HOME

# Install GTK themes
if [[ ! -e $HOME/.themes ]]; then
  mkdir $HOME/.themes
fi
git clone https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme.git
chmod +x $HOME/Everforest-GTK-Theme/themes/install.sh
$HOME/Everforest-GTK-Theme/themes/install.sh -t green -c dark
mv $HOME/.themes/Everforest-Green-Dark $HOME/.themes/Everforest
mv $HOME/.themes/Everforest-Green-Dark-hdpi $HOME/.themes/Everforest-hdpi
mv $HOME/.themes/Everforest-Green-Dark-xhdpi $HOME/.themes/Everforest-xhdpi

cd $HOME/.themes
wget https://github.com/catppuccin/gtk/releases/download/v1.0.3/catppuccin-mocha-lavender-standard+default.zip
if [[ $? -eq 0 ]]; then
  unzip catppuccin-mocha-lavender-standard+default.zip > /dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    rm catppuccin-mocha-lavender-standard+default.zip
    mv catppuccin-mocha-lavender-standard+default CatMocha
    mv catppuccin-mocha-lavender-standard+default-hdpi CatMocha-hdpi
    mv catppuccin-mocha-lavender-standard+default-xhdpi CatMocha-xhdpi
  else
    echo 'Error extracting Catppuccin GTK'
  fi
else
  echo 'Failed to download Catppuccin GTK'
fi

# Install icons
if [[ ! -e $HOME/.icons ]]; then
  mkdir $HOME/.icons
fi

cp -r $HOME/Everforest-GTK-Theme/icons/Everforest-Dark $HOME/.icons/
# TODO: Install Papirus + Catppuccin folders

# Clone repo and symlink with stow
git clone https://github.com/SirEthanator/Hyprland-Dots.git $HOME/Hyprland-Dots
if [[ $? -ne 0 ]]; then
  echo 'Error cloning repo, quitting...'
  exit 1
fi
cd $HOME/Hyprland-Dots
stow .

# Install cursors
cd $HOME/.icons
ln -s ../Hyprland-Dots/Cursors/everforest-cursors .
ln -s ../Hyprland-Dots/Cursors/everforest-cursors-light .
# TODO: Install Catppuccin Cursors

