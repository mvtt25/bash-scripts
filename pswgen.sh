#!/bin/bash

# Remove Shebang to use this script in .zshrc or .bashrc


pswgen() {
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  CYAN='\033[0;36m'
  NC='\033[0m' 

  while true; do
    echo -ne "${YELLOW}Type a length (default 16) >> ${NC}"
    read len
    len=${len:-16}

    if [[ "$len" =~ ^[0-9]+$ && "$len" -ge 16 ]]; then
      break
    else
      echo -e "${RED}Invalid length. Please enter a number greater than or equal to 16.${NC}"
    fi
  done  

  echo -e "${CYAN}---> Charset <---${NC}"
  echo -e "${CYAN}
    \t1 | Only letters 
    \n\t2 | Only numbers 
    \n\t3 | Only letters and numbers 
    \n\t4 | Letters, numbers and symbols
  ${NC}"
  echo -e "${CYAN}---> Charset <---${NC}"

  while true; do
    echo -ne "${YELLOW}Choice [1-4] >> ${NC}"
    read type
    type=${type:-4}

    if [[ "$type" =~ ^[1-4]$ ]]; then
      break
    else
      echo -e "${RED}Invalid type. Please enter a number from 1 to 4.${NC}"
    fi
  done

  case $type in
    4) charset='A-Za-z0-9!@#$%^&*+='; charset_size=72 ;;
    3) charset='A-Za-z0-9'; charset_size=62 ;;
    2) charset='0-9'; charset_size=10 ;;
    1) charset='A-Za-z'; charset_size=52 ;;
    *) echo -e "${RED}Invalid type${NC}"; return ;;
  esac

  pass=$(LC_ALL=C tr -dc "$charset" < /dev/urandom | head -c "$len")

  if [[ -z "$pass" ]]; then
    echo -e "${RED}Error generating password${NC}"
    return
  fi

  if command -v bc &> /dev/null; then
    entropy=$(awk -v l="$len" -v c="$charset_size" 'BEGIN { print l * log(c)/log(2) }')
    if (( $(echo "$entropy < 60" | bc -l) )); then
      strength="${RED}Weak${NC}"
    elif (( $(echo "$entropy < 100" | bc -l) )); then
      strength="${YELLOW}Medium${NC}"
    else
      strength="${GREEN}Strong${NC}"
    fi
    echo -e "\n${CYAN}Key | Password strength: ${strength}.${NC}\n"
  else
    echo -e  "${RED}I can't calculate entropy. Please install bc${NC}"
  fi

  echo -ne "${YELLOW}Key | Do you want to copy it? (y/n) ${NC}"
  read copythat

  case $copythat in
    [yY])
      if command -v xclip &> /dev/null; then
        echo -n "$pass" | xclip -selection clipboard
        echo -e "${GREEN}Key | Password copied using xclip.${NC}"
      elif command -v pbcopy &> /dev/null; then
        echo -n "$pass" | pbcopy
        echo -e "${GREEN}Key | Password copied using pbcopy.${NC}"
      else
        echo -e "${YELLOW}Key | Clipboard tool not found. Your password >> ${pass}${NC}"
      fi
      ;;
    [nN]) echo -e "${CYAN}Key | Password: ${pass}${NC}" ;;
    *)    echo -e "${RED}! | Unrecognized input. Password: ${pass}${NC}" ;;
  esac
}


pswgen # Comment this to use script in .zshrc or .bashrc
