iplookup() {
  if [[ -z "$1" ]]; then
    echo "IP | Provide IP as command line parameter."
    return 1
  fi

  local response
  response=$(curl -s "https://ipwho.is/$1")

  if [[ $? -ne 0 || -z "$response" ]]; then
    echo "❌ IP | Request Error."
    return 1
  fi

  local success=$(echo "$response" | jq -r '.success')
  if [[ "$success" == "false" ]]; then
    local msg=$(echo "$response" | jq -r '.message')
    echo "❌ IP | API Error >> $msg"
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

  echo "\n"
  echo "---> $type | $ip <---"

  echo "
  \tIP | City >> $city
  \n\tIP | Region >> $region - $regionName
  \n\tIP | Country >> $country
  "

  echo "---> $type | $ip <---"
}

