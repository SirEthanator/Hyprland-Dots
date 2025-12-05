#!/bin/bash

ROOT="$HOME/Hyprland-Dots/theme_srcs/cursors"
DEST_DIR="$HOME/.icons"
BACKUP_DIR="$DEST_DIR/bak"

declare -A themes
themes["everforest"]='Bibata-Modern-Everforest'
themes["everforest-light"]='Bibata-Modern-Everforest-Light'
themes["catmocha"]='Bibata-Modern-CatMocha'
themes["catlatte"]='Bibata-Modern-CatLatte'
themes["rosepine"]='Bibata-Modern-Rose-Pine'
themes["rosepine-dawn"]='Bibata-Modern-Rose-Pine-Dawn'
themes["material"]='Bibata-Modern-Material'
themes["material-light"]='Bibata-Modern-Material-Light'

if [[ -n "$1" && "${1:0:2}" != '--' ]]; then
  iter=("$1")
  shift
else
  iter=("${!themes[@]}")
fi

noprompts=0
regen=0

for arg in "$@"; do
  case "$arg" in
  --script | --noprompts)
    noprompts=1
    ;;
  --regenerate)
    regen=1
    ;;
  *)
    echo "Invalid argument: $arg"
    exit 1
    ;;
  esac
done

if [[ "$noprompts" -eq 0 ]]; then
  read -rp "Backup existing cursors? This will overwrite any existing backups. (y/N) " backup
  backup=$(echo "$backup" | tr '[:upper:]' '[:lower:]')
else
  backup='n'
fi

echo "Installing..."

if [[ "$backup" == 'y' ]]; then
  rm -rf "$BACKUP_DIR"
  mkdir "$BACKUP_DIR"
fi

for key in "${iter[@]}"; do
  if [[ "$regen" -eq 1 ]]; then
    "$ROOT"/generate.sh "${themes[$key]}"
  fi

  name="${themes[$key]}"
  if [[ -e "${DEST_DIR}/${name}" ]]; then
    if [[ "$backup" == 'y' ]]; then
      mv "${DEST_DIR}/${name}" "$BACKUP_DIR" || exit 1
    else
      rm -rf "${DEST_DIR}/${name:?}"
    fi
  fi
  cp -r "${ROOT}/themes/${name}" "$DEST_DIR"
done

echo 'Installation complete!'
