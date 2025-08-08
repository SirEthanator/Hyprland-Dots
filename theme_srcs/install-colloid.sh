#!/bin/bash

case "$(basename "$0")" in
  'install-gtk.sh') mode='gtk' ;;
  'install-icons.sh') mode='icons' ;;
  *)
    echo 'ERROR: Please run install-gtk.sh or install-icons.sh instead!'
    exit 1 ;;
esac

if [[ "$mode" == 'gtk' ]]; then
  ROOT="$HOME/Hyprland-Dots/theme_srcs/gtk"
  DEST_DIR="$HOME/.themes"
  BACKUP_DIR="$DEST_DIR/bak"
elif [[ "$mode" == 'icons' ]]; then
  ROOT="$HOME/Hyprland-Dots/theme_srcs/icons"
  DEST_DIR="$HOME/.icons"
  BACKUP_DIR="$DEST_DIR/bak"
fi

declare -A themes
themes['everforest']='green'
themes['rosepine']='teal'
themes['catppuccin']='purple'
themes['material']=''

if [[ -n "$1" && "${1:0:2}" != '--' ]]; then
  iter=("$1")
  shift
else
  iter=("${!themes[@]}")
fi

noprompts=0
nobackup=0

for arg in "$@"; do
  case "$arg" in
    --noconfirm)
      noprompts=1
      ;;
    --nobackup)
      nobackup=1
      ;;
    --script)
      noprompts=1
      nobackup=1
      ;;
    *)
      echo "Invalid argument: $arg"
      exit 1
  esac
done

if [[ -e "$BACKUP_DIR" ]]; then
  if [[ ! "$noprompts" -eq 1 ]]; then
    read -rp 'Existing backup found. Delete it? (y/N) ' deleteBackup
    deleteBackup=$(echo "$deleteBackup" | tr '[:upper:]' '[:lower:]')
  fi

  if [[ $deleteBackup == 'y' ]]; then
    rm -r "$BACKUP_DIR"
  fi
fi

if [[ (! -e "$BACKUP_DIR") || ("$deleteBackup" == 'y') ]]; then
  if [[ ! "$noprompts" == 1 ]]; then
    read -rp 'Backup existing themes? (Y/n) ' backup
    backup=$(echo "$backup" | tr '[:upper:]' '[:lower:]')
  fi

  if [[ "$backup" == 'y' || -z "$backup" ]] && [[ ! "$nobackup" -eq 1 ]]; then
    mkdir "$BACKUP_DIR"
    cp -r "$DEST_DIR"/Colloid* "$BACKUP_DIR"
  fi
fi

for theme in "${iter[@]}"; do
  if [[ "$mode" == 'gtk' ]]; then
    args=(-d "$DEST_DIR" --tweaks "$theme" -c standard)
    if [[ "$theme" == 'material' ]]; then
      (
        cd "$ROOT"/src/assets/gtk-2.0 || exit 1
        rm -r ./assets*Material
        ./render-assets.sh | grep -v 'exists'
      )
    fi

  elif [[ "$mode" == 'icons' ]]; then
    args=(-d "$DEST_DIR" -s "$theme")
  fi

  if [[ -n "${themes[$theme]}" ]]; then
    args+=(-t "${themes[$theme]}")
  fi

  "$ROOT"/install.sh "${args[@]}"
done

find "$DEST_DIR"/Colloid* -maxdepth 0 -type d -exec cp "$ROOT"/LICENSE {} \;

