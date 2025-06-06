#!/bin/bash

# Remove Shebang to use this script in .zshrc or .bashrc


backup_auto() {
  local source_dir dest_dir interval_minutes password
  local log_file

  for cmd in tar gpg; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo -e "\nAuto Backup | Error: '$cmd' is not installed or not in the PATH."
      return 3
    fi
  done

  while true; do
    echo -n "Auto Backup | Enter source directory to backup >> "
    read source_dir
    if [[ -d "$source_dir" ]]; then
      break
    else
      echo "Auto Backup | Error: '$source_dir' is not a valid directory."
    fi
  done

  while true; do
    echo -n "Auto Backup | Enter destination directory (leave blank for \$HOME/backup) >> "
    read dest_dir
    dest_dir="${dest_dir:-$HOME/backup}"

    mkdir -p "$dest_dir" 2>/dev/null
    if [[ -d "$dest_dir" ]]; then
      break
    else
      echo "Auto Backup | Error: Could not create or access '$dest_dir'"
    fi
  done

  while true; do
    echo -n "Auto Backup | Enter interval in minutes for repeated backups (leave blank for one-time) >> "
    read interval_minutes
    if [[ -z "$interval_minutes" || "$interval_minutes" =~ ^[0-9]+$ ]]; then
      break
    else
      echo "Auto Backup | Please enter a valid number or leave blank."
    fi
  done

  while true; do
    echo -n "Auto Backup | Enter a password for encryption >> "
    read -s password
    echo
    if [[ -n "$password" ]]; then
      break
    else
      echo "Auto Backup | Password cannot be empty."
    fi
  done

  log_file="$dest_dir/backup.log"

  while true; do
    local timestamp
    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    local base
    base=$(basename "$source_dir")
    local backup_file="${base}-${timestamp}.tar.xz"
    local encrypted_file="${backup_file}.gpg"

    echo -e "\nAuto Backup | Creating Backup ..."
    tar -cJf "$dest_dir/$backup_file" \
      --exclude=".git" \
      --exclude="node_modules" \
      --exclude=".DS_Store" \
      --exclude="*.log" \
      -C "$(dirname "$source_dir")" "$base"

    echo "$password" | gpg --batch --yes --passphrase-fd 0 --symmetric --cipher-algo AES256 "$dest_dir/$backup_file"
    rm -f "$dest_dir/$backup_file"

    echo -e "\n[$(date +"%Y-%m-%d %H:%M:%S")] | Encrypted backup saved as '$encrypted_file'" >> "$log_file"

    echo -e "Auto Backup | Backup complete."
    echo -e "Auto Backup | Log file >> $log_file"

    if [[ -z "$interval_minutes" ]]; then
      break
    fi

    echo -e "\nAuto Backup | Waiting $interval_minutes minutes for next backup (CTRL+C to cancel)..."
    sleep "$((interval_minutes * 60))"
  done
}

backup_auto # Comment this to use script in .zshrc or .bashrc
