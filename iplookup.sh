#!/bin/bash

# Remove Shebang to use this script in .zshrc or .bashrc

iplookup() {

  if ! command -v jq &> /dev/null; then
    echo "IP Lookup | Jq not found. Please, install jq to continue."
    return 1
  fi

  if [[ -z "$1" ]]; then
    while true; do
      echo -ne "IP Address (leave blank to use your IP)>> "
      read ip
      
      if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        break
      elif [[ -z "$ip" ]]; then
        ip=$(curl -s ifconfig.me)
        break
      else
        echo "IP Lookup | Invalid IP format. Please enter a valid IP address."
      fi
    done  
  fi

  local response
  response=$(curl -s "https://ipwho.is/$ip")

  if [[ $? -ne 0 || -z "$response" ]]; then
    echo "IP Lookup | Request Error."
    return 1
  fi

  local success=$(echo "$response" | jq -r '.success')
  if [[ "$success" == "false" ]]; then
    local msg=$(echo "$response" | jq -r '.message')
    echo "IP Lookup | API Error >> $msg"
    return 1
  fi

  eval $(echo "$response" | jq -r '
    "type=\(.type)
     ip=\(.ip)
     city=\(.city)
     region=\(.region_code)
     regionName=\(.region)
     country=\(.country)"'
  )

  echo -e "\n"
  echo "---> $type | $ip <---"

  echo -e "
  \t | City >> $city
  \n\t | Region >> $region - $regionName
  \n\t | Country >> $country
  "

  echo "---> $type | $ip <---"
}

iplookup # Comment this to use script in .zshrc or .bashrc
