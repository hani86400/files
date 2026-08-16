#!/usr/bin/env bash
#set -euo pipefail

# source ${HANI_HOME}/files/etc/profile.d/s11_aliases_general.sh #2026_06_13

export S11_WORK_DIR='/opt/s11_wd'
export S11_DC_DIR='/opt/s11_wd/dc'
export S11_LOG='/var/log/s11.log'
export LOG_FILE='/var/log/s11.log'
export S11_SS='/var/lib/cloud/instance/user-data.txt'
export S11_SS_LOG='/var/log/cloud-init-output.log'

alias s11_find_wd="find /opt/s11_wd"
alias s11_find_dc="find /opt/s11_wd/dc"

alias s11_log_cat="cat ${LOG_FILE}"

alias s11_ss_cat="cat ${S11_SS} ; ls -l  ${S11_SS} "
alias s11_ss_log="cat ${S11_SS_LOG} ; ls -l  ${S11_SS_LOG} "
alias s11_ss_nano="sudo nano ${S11_SS} "
alias s11_ss_run="source ${S11_SS}"

alias cdprofile='cd /etc/profile.d && ls -latr'
alias cdcontainers='cd /opt/containers && ls -latr'

alias ps10="export PS1='# '"
alias ps11="export PS1='$ '"

alias h='     history'
alias H='     history'
alias hgrep=' history | grep '
alias hmore=' history | more '
alias ll='ls -lAtrF'
shopt -s histappend
his_info()	{ echo -e "HISTSIZE=\e[1;96m${HISTSIZE}\e[0m HISTFILESIZE=\e[1;96m${HISTFILESIZE}\e[0m HISTFILE=\e[1;96m${HISTFILE}\e[0m COMMAND#=\e[1;96m$(wc -l $HISTFILE | cut -d ' ' -f1) \e[0m" ; } 
hoff()	{
echo -e "\e[1;96m# [ HISTORY STOP  ]\e[0m export HISTFILE='/dev/null'"
unset HISTFILE # OFF'set +o history'
export HISTFILE='/dev/null'
his_info
}
hon()	{
echo -e "\e[1;96m# [ HISTORY START  ]\e[0m export HISTFILE="${HANI_HISTFILE}""
export HISTFILE="${HANI_HISTFILE}"
his_info
}
export PROMPT_COMMAND='history -a ; history -n' #export history ; import history
export HISTCONTROL=ignoreboth 

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [ A C M E . S H ]                                 [ 2026_06_22 ] ::
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
export ACME_EMAIL='hix89893@laoia.com'
export ACME_HOME='/opt/acme.sh'
export ACME_COMMAND="${ACME_HOME}/acme.sh"
alias  acme_use_letsencrypt="echo  'acme.sh --set-default-ca --server letsencrypt'"
alias  acme_register="echo  'acme.sh --register-account -m ${ACME_EMAIL}' "
alias  acme_issue='echo "THE_DOMAIN=\"wxyz.duckdns.org\" && acme.sh --issue -d \"\${THE_DOMAIN}\" --standalone           "'
alias  acme_renew='echo "THE_DOMAIN=\"wxyz.duckdns.org\" && acme.sh --renew -d \"\${THE_DOMAIN}\" --standalone # --force "'
       acme_install(){ # acme_install "${ACME_EMAIL}" "${ACME_HOME}"
    local email="${1:-}"
    local acme_home="${2:-}"
    local target_paths=( "/usr/local/bin/acme.sh" "/usr/bin/acme.sh" "/bin/acme.sh" )
    local sudo_cmd=""
    if [[ $EUID -ne 0 ]]; then
        sudo_cmd="sudo"
    fi
    curl -s https://get.acme.sh | $sudo_cmd sh -s email="$email" --home "$acme_home" --force
    for path in "${target_paths[@]}"; do
        if [[ -L "$path" || -f "$path" ]]; then
            $sudo_cmd rm -f "$path"
        fi
        $sudo_cmd ln -svf "${acme_home}/acme.sh" "$path"
    done
    $sudo_cmd chmod -R 755 "$acme_home"
} # f u n c t i o n [END] :::::::::::::::::::::::::::::::::::::::::::::



# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [ C E R T B O T ]                                 [ 2026_06_17 ] ::
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
certbot_install() {
dnf update  -y
dnf install -y certbot 
} 
certbot_request() {
    # Expecting 3 arguments: domain, email, and mode (prod/test)
    local domain="${1:-}"
    local email="${2:-}"
    local mode="${3:-prod}" # Defaults to 'prod' if not specified

    # Validate mandatory inputs
    if [[ -z "$domain" || -z "$email" ]]; then
        echo "[-] Error: request_cert requires both a domain and an email." >&2
        return 1
    fi
     
    echo "[+] Requesting certificate for ${domain}..."
    
    # Base arguments for standalone verification
    local certbot_args=(
        certonly
        --standalone
        --preferred-challenges http
        -d "$domain"
        --email "$email"
        --agree-tos
        --non-interactive
    )

    # Check if test/staging mode was explicitly requested
    if [[ "$mode" == "test" || "$mode" == "staging" ]]; then
        echo "[!] Running in TEST/STAGING mode to avoid rate limits."
        certbot_args+=(--test-cert)
    else
        echo "[+] Running in PRODUCTION mode."
    fi

    # Execute certbot with tracing enabled temporarily
    set -x
    certbot "${certbot_args[@]}"
    { set +x; } 2>/dev/null
}
certbot_renew() {
certbot renew --quiet 
} # f u n c t i o n [END] ::::::::::::::::::::::::::::::::::::::::::::: 

# f u n c t i o n :::::::::::::::::::::::::::::::::::: [ 2026_08_16 ] :
                  ssh_github_conf(){
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if [[ $# -lt 2 ]]
then
    echo -e "ssh_github_conf \e[1;95m<​CONF_PATH>\e[0m \e[1;95m<​USERNAME>\e[0m \e[1;92m[KEY_PATH]\e[0m"
    return 1
fi

local LOC_CONF_PATH="$1"
local LOC_USERNAME="$2"
local LOC_KEY_PATH="${3:-~/.ssh/key_github_vps}"
local LOC_CONF_DIR=""

if ! id "$LOC_USERNAME" &>/dev/null
then
    echo -e "\e[1;91mUser does not exist:\e[0m $LOC_USERNAME"
    return 1
fi

LOC_CONF_DIR=$(dirname -- "$LOC_CONF_PATH")

if [[ ! -d "$LOC_CONF_DIR" ]]
then
    sudo mkdir -p "$LOC_CONF_DIR"
fi

sudo tee "$LOC_CONF_PATH" > /dev/null << EOT
Host github_vps
     Hostname github.com
     IdentityFile ${LOC_KEY_PATH}
     User git
     IdentitiesOnly yes
EOT

sudo chown "${LOC_USERNAME}:${LOC_USERNAME}" "$LOC_CONF_PATH"
sudo chmod 600 "$LOC_CONF_PATH"

echo -e "\e[1;92mCreated:\e[0m $LOC_CONF_PATH \e[1;92mowned by\e[0m $LOC_USERNAME \e[1;92m(600)\e[0m"

} # f u n c t i o n [END] :::::::::::::::::::::::::::::::::::::::::::::
# f u n c t i o n :::::::::::::::::::::::::::::::::::: [ 2026_08_16 ] :
                  ssh_github_conf(){
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
cat <<'EOT'

Host github_vps
     Hostname github.com
     IdentityFile ~/.ssh/key_github_vps
     User git
     IdentitiesOnly yes
     
EOT
} # f u n c t i o n [END] :::::::::::::::::::::::::::::::::::::::::::::


# f u n c t i o n :::::::::::::::::::::::::::::::::::: [ 2026_08_15 ] :
                  aws_volumes_help(){
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
cat <<'EOT'
fdisk -l     && T_DEV='/dev/xvdd'
file -s      "${T_DEV}" 
mkfs -t ext4 "${T_DEV}" 
file -s      "${T_DEV}" 
T_DIR='/ebs8g' && mkdir -pv "${T_DIR}" && mount /dev/xvdd "${T_DIR}"
EOT
} # f u n c t i o n [END] :::::::::::::::::::::::::::::::::::::::::::::


#######################################################################
# f u n c t i o n                                      [ 2026_06_13 ] #
                    s11_help(){
#######################################################################
echo -e "\n\e[1;96m# [ environment ]\e[0m"
env | sort | grep -i s11
echo -e "\n\e[1;96m# [ alias ]\e[0m"
alias | grep -i s11
echo -e "\n\e[1;96m# [ functions ]\e[0m"
typeset -F | awk '{print $NF}' | grep -i s11 
} # f u n c t i o n [END] #############################################
#######################################################################
# f u n c t i o n                                      [ 2026_01_29 ] #
                    ec2_set_hostname(){
#######################################################################
#TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600") && curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/user-data

export DEFAULT_HOSTNAME="nonameec2"
export METADATA_URL="http://169.254.169.254/latest"

TOKEN=""
if curl -s --connect-timeout 1 "$METADATA_URL" >/dev/null
then
  TOKEN=$(curl -sX PUT "$METADATA_URL/api/token"  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" || true)
fi

INSTANCE_NAME=""
if [[ -n "$TOKEN" ]]
then
#              https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html
  INSTANCE_NAME=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" "$METADATA_URL/meta-data/tags/instance/Name" || true)
fi

if [[ -n "$INSTANCE_NAME" ]]
then
  hostnamectl set-hostname "$INSTANCE_NAME"
else
  hostnamectl set-hostname "$DEFAULT_HOSTNAME"
fi
} # f u n c t i o n [END] #############################################

s11_git_install(){ dnf update -y && dnf install -y git ; }
#######################################################################
# f u n c t i o n                                      [ 2026_06_22 ] #
                  s11_hermes_instal(){
#######################################################################
mkdir -pv /opt/hermes && cd /opt/hermes 
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh -o install.sh
chmod +x install.sh
./install.sh --skip-setup --non-interactive 
} # f u n c t i o n [END] #############################################

s11_nginx_install_ubuntu() {

    set -e

    echo "==> Installing Nginx..."

    sudo apt update
    sudo apt install -y nginx

    echo "==> Enabling Nginx..."

    sudo systemctl enable --now nginx

    echo "==> Verifying installation..."

    nginx -v
    sudo nginx -t

    echo
    echo "Nginx status:"
    sudo systemctl --no-pager --full status nginx

}

#######################################################################
# f u n c t i o n                                      [ 2026_02_19 ] #
                  s11_nginx_install(){
#######################################################################
   log 'T' "s11_nginx_install"

    dnf update -y
    dnf install -y nginx
    NGINX_LOG_DIR="/var/log/nginx"
    mkdir -p "$NGINX_LOG_DIR" /etc/nginx/auth
    for NGINX_LOG_FILE in app_access.log app_error.log shared_access.log shared_error.log; do
      install -o nginx -g nginx -m 0644 /dev/null "${NGINX_LOG_DIR}/${NGINX_LOG_FILE}"
    done
    chown root:nginx "$NGINX_LOG_DIR" 
    chmod 0755 "$NGINX_LOG_DIR"
    setsebool -P httpd_can_network_connect on
# Ensure the directory exists
sudo mkdir -p /etc/nginx

# Write the configuration using a heredoc
tee /etc/nginx/proxy_params > /dev/null << 'EOF'
# =========================================================
# Shared Proxy Parameters
# =========================================================

proxy_http_version 1.1;

# Headers configuration
proxy_set_header Host              $host;
proxy_set_header X-Real-IP         $remote_addr;
proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header Connection        "";

# Timeout fine-tuning
proxy_connect_timeout 60s;
proxy_send_timeout    60s;
proxy_read_timeout    60s;
EOF

# Set secure system permissions (Readable by root/nginx, writable only by root)
chmod 644 /etc/nginx/proxy_params
    
} # f u n c t i o n [END] #############################################

random_hex_color()   { printf '#%06x\n' $((RANDOM * 16777215 / 32767)) ; }
get_contrast_color() { printf '#%06x\n' $((0xFFFFFF - 0x${1#\#})) ; }

random_html() {
  local HEAD="$1"
  local C1=$(printf '#%06x' $((RANDOM * 16777215 / 32767)))
  local C2=$(printf '#%06x' $((0xFFFFFF - 0x${C1#\#})))
  cat <<EOF
<!DOCTYPE html><html lang="en"><head><title>${HEAD}</title></head><body style="background-color: ${C1}; color: ${C2};"><h1>${HEAD}</h1></body></html>
EOF
}

#######################################################################
# f u n c t i o n                                        [2026_06_03] #
                  py_server_on(){
#######################################################################
    if [ $# -lt 1 ]
    then
        echo "Usage: py_server_on <PY_PORT> [PY_BIND] [PY_DIR]"
#                    py_server_on "4040"    "0.0.0.0" "/tmp/www" # "https://files.x25.shop/index.html"
        return 1
    fi

    PY_PORT="$1"
    PY_BIND="${2:-0.0.0.0}"
    PY_DIR="${3:-/tmp/www${PY_PORT}}"

    mkdir -pv "${PY_DIR}"/{cgi-bin,html}
    cd "${PY_DIR}/html" || return 1
    random_html "Python server on port ${PY_PORT} bind ${PY_BIND} www_dir ${PY_DIR}" > index.html
#   wget -O index.html "$PY_INDEX_URL"
    chmod -R 755 "${PY_DIR}"

    # Kill existing python http.server on same port
    PIDS=$(ps aux | grep '[h]ttp.server' | grep "${PY_PORT}" | awk '{print $2}')
    if [ -n "$PIDS" ]; then
        kill $PIDS
    fi
    rm -rf "${PY_DIR}/cgi-bin/__pycache__"
set -x    
nohup python3 -m http.server "${PY_PORT}" --bind "${PY_BIND}" --directory "${PY_DIR}"  --cgi > "${PY_DIR}/server.log" 2>&1 &
set +x
} # f u n c t i o n [END] #############################################
#######################################################################
# f u n c t i o n                                      [ 2025_10_17 ] #
                  s11_caddy_install(){
#######################################################################
log 'T' 's11_caddy_install'

CADDY_PKG_URL='https://github.com/caddyserver/caddy/releases/download/v2.10.2/caddy_2.10.2_linux_amd64.tar.gz'
CADDY_PKG_TAR="${S11_WORK_DIR}/caddy.tar.gz"
CADDY_PKG_BIN="${S11_WORK_DIR}/caddy"
CADDY_INSTALL_BIN='/usr/bin/caddy'
curl -L  "${CADDY_PKG_URL}" -o "${CADDY_PKG_TAR}"
tar -xzf "${CADDY_PKG_TAR}" -C "${S11_WORK_DIR}"
mv "${CADDY_PKG_BIN}" "${CADDY_INSTALL_BIN}"
chmod +x              "${CADDY_INSTALL_BIN}"
setcap 'cap_net_bind_service=+ep' "${CADDY_INSTALL_BIN}"

mkdir -pv /var/log/caddy
touch     /var/log/caddy/{output,error,access}.log

mkdir -pv /var/lib/caddy
useradd --system --user-group --home-dir /var/lib/caddy --shell /usr/sbin/nologin caddy
chown -R caddy:caddy /etc/caddy /var/lib/caddy /var/log/caddy
chmod -R 755 /var/log/caddy

log 'INFO CADDY_DIRS: ' " $(ls -ld  /etc/caddy /var/lib/caddy /var/log/caddy ; ls -l ${CADDY_INSTALL_BIN} )"
log 'INFO CADDY_USER: ' " $(tail -5 /etc/group ; echo ; tail -5 /etc/passwd )"

} # f u n c t i o n [END] #############################################
#######################################################################
# f u n c t i o n                                      [ 2026_06_26 ] #
                  s11_docker_install_ubuntu (){
#######################################################################                   
# Remove old packages (optional)
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do
    sudo apt-get remove -y "$pkg"
done

# Install prerequisites
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# Add Docker's GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${VERSION_CODENAME}") stable" \
| sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# Install Docker Engine + Compose plugin
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable Docker
sudo systemctl enable --now docker

#
# Configration
#
usermod -aG      docker "${S11_OS_USER}"
newgrp docker
systemctl start  docker
systemctl enable docker



} # f u n c t i o n [END] #############################################


# f u n c t i o n :::::::::::::::::::::::::::::::::::: [ 2026_08_13 ] :
                  s11_docker_install(){
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local LOC_ID=""
local LOC_ID_LIKE=""
local LOC_COMPOSE_DIR='/usr/libexec/docker/cli-plugins'
local LOC_COMPOSE_BIN="${LOC_COMPOSE_DIR}/docker-compose"
local LOC_COMPOSE_URL='https://github.com/docker/compose/releases/download/v2.24.7/docker-compose-linux-x86_64'

log 'T' 's11_docker_install'

[[ -r /etc/os-release ]] && . /etc/os-release
LOC_ID="${ID:-}"
LOC_ID_LIKE="${ID_LIKE:-}"

#
# 1. Install Docker engine
#
case "${LOC_ID} ${LOC_ID_LIKE}" in
    *ubuntu*|*debian*)
        apt-get update  -y
        apt-get install -y docker.io
        ;;
    *rhel*|*centos*|*fedora*|*rocky*|*alma*)
        dnf update  -y
        dnf install -y docker
        ;;
    *)
        log 'ERROR' "s11_docker_install: unsupported OS (ID=${LOC_ID} ID_LIKE=${LOC_ID_LIKE})"
        return 1
        ;;
esac

# 2. Compose plugin: neither Ubuntu's docker.io nor RHEL's docker package ships it,
# so fetch the v2 binary directly as a CLI plugin on both OSes.
if ! docker compose version &>/dev/null
then
    mkdir -pv   "${LOC_COMPOSE_DIR}"
    curl -SL -o "${LOC_COMPOSE_BIN}" "${LOC_COMPOSE_URL}"
    chmod +x    "${LOC_COMPOSE_BIN}"
fi

#
# 3. Allow OS_USER to run docker without sudo
#
groupadd -f docker
usermod -aG      docker ubuntu
usermod -aG      docker ec2-user


systemctl start  docker
systemctl enable docker

} # f u n c t i o n [END] :::::::::::::::::::::::::::::::::::::::::::::
#######################################################################
# f u n c t i o n                                      [ 2026_08_13 ] #
                  s11_docker_relocate_storage(){
#######################################################################
cat <<EOF

ls -ld /var/lib/docker /var/lib/containerd /docker /containerd

#
# Docker_relocate_storage
#

if [[ ! -d /docker ]]
then
    systemctl stop docker
    systemctl stop docker.socket 2>/dev/null
    systemctl stop containerd
   
    mv    /var/lib/docker /docker
    ln -sfv /docker       /var/lib/docker
fi

if [[ ! -d /containerd ]]
then
    systemctl stop docker
    systemctl stop docker.socket 2>/dev/null
    systemctl stop containerd

    mv    /var/lib/containerd /containerd
    ln -sfv /containerd       /var/lib/containerd
fi
systemctl start  docker
systemctl enable docker

EOF
} # f u n c t i o n [END] #############################################
#######################################################################
# f u n c t i o n                                      [ 2025_12_06 ] #
                  s11_docker_conf_n8n_1(){
#######################################################################
log 'T' 's11_docker_conf_n8n_1'

docker volume create pgdata
docker volume create n8ndata

docker pull postgres:16.11-alpine3.23
docker pull n8nio/n8n:nightly-amd64

} # f u n c t i o n [END] #############################################
#######################################################################
# f u n c t i o n                                      [ 2025_12_06 ] #
                  s11_docker_conf_n8n_3(){
#######################################################################
log 'T' 's11_docker_conf_n8n_3'

docker pull hani86400/busybox-httpd-env:1222

} # f u n c t i o n [END] #############################################

#######################################################################
# f u n c t i o n                                       [2026_02_20 ] #
                   aws_s3_put_object() {
# $1 : AWS_S3_BUCKET_NAME
# $2 : FILE
#######################################################################
    if [ $# -lt 2 ]; then
        printf "\e[1;94mUSAGE\e[0m aws_s3_put_object \e[1;95m<AWS_S3_BUCKET_NAME>\e[0m \e[1;95m<FILE>\e[0m [DEST_KEY]\n"
        return 1
    fi

    local T_BUCKET="$1"
    local T_SRC_FILE="$2"
    local T_DES_FILE="${3:-$(basename -- "$T_SRC_FILE")}"

    # Validate file
    if [ ! -f "$T_SRC_FILE" ]; then
        echo "Error: File not found: $T_SRC_FILE" >&2
        return 1
    fi

    # Calculate MD5 in base64 (for upload validation)
    local T_MD5_BASE64
    T_MD5_BASE64=$(openssl md5 -binary "$T_SRC_FILE" | base64)

    local T_MD5_HEX
    T_MD5_HEX=$(openssl md5 "$T_SRC_FILE" | awk '{print $2}')

    local T_SHA512_HEX
    T_SHA512_HEX=$(openssl sha512 "$T_SRC_FILE" | awk '{print $2}')

    # File info (safer)
    local T_FILE_INFO
    T_FILE_INFO=$(file -b --mime-type -- "$T_SRC_FILE")
    T_FILE_INFO=$(file "$T_SRC_FILE" | awk -F': '  '{print $2}')    

    SAFE_FILE_INFO=$(echo "$T_FILE_INFO" | tr ' ' '_' | tr -d ';')
    
    aws s3api put-object \
        --bucket "$T_BUCKET" \
        --key "$T_DES_FILE" \
        --body "$T_SRC_FILE" \
        --content-md5 "$T_MD5_BASE64" \
        --content-type "$T_FILE_INFO" \
        --metadata "{\"md5\":\"$T_MD5_HEX\",\"sha512\":\"$T_SHA512_HEX\",\"fileinfo\":\"$T_FILE_INFO\"}"

} # f u n c t i o n [END] #############################################
#######################################################################
# f u n c t i o n                                       [2026_02_20 ] #
                   aws_s3_bucket_objects_ls() {
# $1 : AWS_S3_BUCKET_NAME					   
#######################################################################
#aws s3api list-object-versions --bucket "$1"  --output=json --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}'
    if [ $# -lt 1 ]; then
       echo -e "\e[1;94mUSAGE\e[0m aws_s3_bucket_objects_ls \e[1;95m<AWS_S3_BUCKET_NAME>\e[0m "
       return 1
    fi

    local BUCKET="$1"

    # List object versions
    local OBJECTS=$(aws s3api list-object-versions --bucket "$BUCKET" --query 'Versions[].{Key:Key,VersionId:VersionId}'  --output json)

    # Loop through objects and show metadata
    echo "$OBJECTS" | jq -c '.[]' | while read -r obj; do
        local KEY=$(echo "$obj" | jq -r '.Key')
        local VERSION=$(echo "$obj" | jq -r '.VersionId')

        echo "Object: $KEY (version: $VERSION)"
        aws s3api head-object \
            --bucket "$BUCKET" \
            --key "$KEY" \
            --version-id "$VERSION" \
            --query '{ETag: ETag, Metadata: Metadata}' \
            --output json
        echo
    done	


} # f u n c t i o n [END] #############################################


s11_user_rename() {
    local OLD_USER="$1"
    local NEW_USER="$2"

    # 1. Safety Checks: Ensure arguments are provided and user runs as root
    if [[ -z "$OLD_USER" || -z "$NEW_USER" ]]; then
        echo "Error: Usage: rename_user <old_username> <new_username>"
        return 1
    fi

    if [[ $EUID -ne 0 ]]; then
        echo "Error: This function must be run as root (sudo)."
        return 1
    fi

    # 2. Rename the home directory (if it exists)
    if [ -d "/home/$OLD_USER" ]; then
        echo "Renaming home directory from /home/$OLD_USER to /home/$NEW_USER..."
        mv "/home/$OLD_USER" "/home/$NEW_USER"
    fi

    # 3. Perform the global string replacement in configuration files
    echo "Updating system files..."
    sed -i "s/${OLD_USER}/${NEW_USER}/g" /etc/passwd
    sed -i "s/${OLD_USER}/${NEW_USER}/g" /etc/group

    # 4. Sync changes to the shadow files (/etc/shadow and /etc/gshadow)
    pwconv
    grpconv

    # 5. Fix SELinux contexts on the new home directory (optional but recommended)
    if command -v restorecon &> /dev/null; then
        echo "Restoring SELinux contexts..."
        restorecon -R "/home/$NEW_USER" 2>/dev/null
    fi

    # 6. Verify (Fixed typos from original snippet)
    echo -e "\n--- Verification ---"
    grep "${NEW_USER}" /etc/passwd /etc/group /etc/shadow
}


#######################################################################
# f u n c t i o n                                      [ 2025_01_30 ] #
                   s11_user_add(){
# $1 : USER_NAME
# $2 : USER_HOME
# $3 : USER_SHELL
# $4 : USER_COMMENT
# $5 : USER_PASWORD
# $6 : USER_KEY_PUB
# $7 : USER_SUDO [YES|NO|NO_PASS]
#######################################################################
if [ $# -lt 6 ]
then 
echo "Usage : s11_user_add USER_NAME USER_HOME USER_SHELL USER_COMMENTS USER_PASWORD USER_KEY_PUB USER_SUDO[YES|NO|NO_PASS]"
fi


if [[   "0" = "$(id -u)"  ]]
then # root
unset SUDO
else # sudo_user
SUDO="sudo "
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# USER
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
${SUDO} useradd -m -d "$2" -s  "$3" -c "$4"  "$1"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# PASSWORD
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
echo "${1}:${5}" | ${SUDO} chpasswd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# KEY
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
${SUDO}  "rm"  -rf                      ${2}/.ssh
${SUDO}  mkdir -pv                      ${2}/.ssh
${SUDO}  echo "$6" |     ${SUDO} tee -a ${2}/.ssh/authorized_keys
${SUDO}  chown -R ${1}:$(id -g "$1" )   ${2}/.ssh 
${SUDO}  chmod 700                      ${2}/.ssh
${SUDO}  chmod 600                      ${2}/.ssh/authorized_keys
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# SUDO
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
if [[   "YES" = "$7"  ]]
then
${SUDO} usermod -a -G sudo  "$1" || ${SUDO} usermod -a -G wheel "$1"
fi

if [[   "NO_PASS" = "$7"  ]]
then
echo "$1 ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee  /etc/sudoers.d/${1}_CONF
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
} # f u n c t i o n [END] #############################################


set_volumes_n8n() {
    set -euo pipefail
    set -x
    local APP_DIR="/opt/containers/n8n"
    local VOL_DIR="/opt/volumes/n8n"

    echo "==> Creating directories..."

    sudo install -d -m 755 "${APP_DIR}" "${VOL_DIR}" "${VOL_DIR}/postgres" "${VOL_DIR}/data"
    echo "==> Creating files..."
    sudo touch "${APP_DIR}/compose.yml" "${APP_DIR}/.env" "${APP_DIR}/README.md"

    echo "==> Setting permissions..."

    # Application files
    sudo chown -R root:root "${APP_DIR}"
    sudo find "${APP_DIR}" -type d -exec chmod 755 {} \;
    sudo find "${APP_DIR}" -type f -exec chmod 644 {} \;

    # PostgreSQL data directory (UID 999)
    sudo chown -R 70:70 "${VOL_DIR}/postgres"
    sudo chmod 700 "${VOL_DIR}/postgres"

    # n8n data directory (UID 1000)
    sudo chown -R 1000:1000 "${VOL_DIR}/data"
    sudo chmod 755 "${VOL_DIR}/data"

    echo
    echo "Directory structure:"
    tree /opt/containers/n8n /opt/volumes/n8n 2>/dev/null || true

    echo
    echo "✓ n8n directories initialized."
    
    sudo tree /opt
}

