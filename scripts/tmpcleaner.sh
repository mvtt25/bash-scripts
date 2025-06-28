#!/bin/bash

# Remove Shebang to use this script in .zshrc or .bashrc


tmpcleaner() {
  local DRY_RUN=false
  local TARGET_DIR

  while true; do
    echo -n "Cleaner | Do you want to perform a dry-run? (y/n) >> "
    read dry_input
    case "$dry_input" in
      [yY])
        DRY_RUN=true
        break
        ;;
      [nN])
        DRY_RUN=false
        break
        ;;
      *)
        echo "Cleaner | Invalid input. Please enter 'y' or 'n'."
        ;;
    esac
  done

  while true; do
    echo -n "Cleaner | Enter the target directory (leave blank for current dir '.') >> "
    read TARGET_DIR
    TARGET_DIR="${TARGET_DIR:-.}"

    if [[ -d "$TARGET_DIR" ]]; then
      break
    else
      echo "Cleaner | Error >> '$TARGET_DIR' isn't a valid directory. Try again."
    fi
  done

  echo "Cleaner | Scanning temporary files in >> $TARGET_DIR"
  [[ "$DRY_RUN" == true ]] && echo "Cleaner | No files will be deleted with dry-run"

  local extensions=("*.tmp" "*~" "*.bak" "*.swp" "*.log")

  for ext in "${extensions[@]}"; do
    find "$TARGET_DIR" -type f -name "$ext" 2>/dev/null | while read -r file; do
      if [[ "$DRY_RUN" == true ]]; then
        echo "Cleaner | DRY-RUN >> Found $file"
      else
        echo "Cleaner | Removed >> $file"
        rm -f "$file"
      fi
    done
  done

  echo "Cleaner | Cleaning Complete"
}

tmpcleaner # Comment this to use script in .zshrc or .bashrc
