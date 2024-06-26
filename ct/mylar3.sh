#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    __  ___      __          _____
   /  |/  /_  __/ /___ _____|__  /
  / /|_/ / / / / / __ `/ ___//_ < 
 / /  / / /_/ / / /_/ / /  ___/ / 
/_/  /_/\__, /_/\__,_/_/  /____/  
       /____/                    
                                                                    
EOF
}
header_info
echo -e "Loading..."
APP="Mylar3"
var_disk="8"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/mylar3 ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating $APP"
systemctl stop mylar3.service
RELEASE=$(curl -s https://api.github.com/repos/mylar3/mylar3/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3) }')
tar zxvf <(curl -fsSL https://github.com/mylar3/mylar3/archive/refs/tags/${RELEASE}.tar.gz) -C /opt/mylar3 &>/dev/null
cd /opt/mylar3
python3 -m pip install -r requirements.txt &>/dev/null
systemctl start mylar3.service
msg_ok "Updated $APP"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:8585${CL} \n"
