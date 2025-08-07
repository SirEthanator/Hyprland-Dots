#!/bin/bash

ROOT="$HOME/Hyprland-Dots/theme_srcs/icons"
DEST_DIR="$HOME/Hyprland-Dots/.icons"
BACKUP_DIR="$DEST_DIR/bak"

if [[ -e "$BACKUP_DIR" ]]; then
  read -rp 'Existing backup found. Delete it? (y/N) ' deleteBackup
  deleteBackup=$(echo "$deleteBackup" | tr '[:upper:]' '[:lower:]')
  if [[ $deleteBackup == 'y' ]]; then
    rm -r "$BACKUP_DIR"
  fi
fi

if [[ (! -e "$BACKUP_DIR") || ("$deleteBackup" == 'y') ]]; then
  read -rp 'Backup existing themes? (Y/n) ' backup
  backup=$(echo "$backup" | tr '[:upper:]' '[:lower:]')
  if [[ "$backup" == 'y' || -z "$backup" ]]; then
    mkdir "$BACKUP_DIR"
    mv "$DEST_DIR"/Colloid* "$BACKUP_DIR"
  else
    rm -r "$DEST_DIR"/Colloid*
  fi
fi

declare -A themes
themes['everforest']='green'
themes['rosepine']='teal'
themes['catppuccin']='purple'
themes['material']=''

if [[ -n "$1" ]]; then
  iter=("$1")
else
  iter=("${!themes[@]}")
fi

for theme in "${iter[@]}"; do
  args=(-d "$DEST_DIR" -s "$theme")
  if [[ -n "${themes[$theme]}" ]]; then
    args+=(-t "${themes[$theme]}")
  fi

  "$ROOT"/install.sh "${args[@]}"
done

find "$DEST_DIR"/Colloid* -maxdepth 0 -type d -exec cp "$ROOT"/LICENSE {} \;

