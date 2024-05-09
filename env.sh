#!/bin/sh

FALSE='0'
TRUE='1'
APK_PATHS='/sbin/apk /etc/apk /lib/apk /usr/share/apk /var/lib/apk'
API_SFX='API_ENDPOINT_'

### Ids #######################################################################
COLLECTOR_ID='collector'
CONTROLLER_ID='controller'
EDITOR_ID='editor'
JUMPER_ID='jumper'
OWNER_ID='tiawl'
PROXY_ID='proxy'
COMPONENT_ID='component'
ITERATOR_ID='iterator'
RUNNER_ID='runner'
SPACEPORN_ID='spaceporn'
ZIG_ID='zig'
SPACEPORN_RUNNER_ID="${RUNNER_ID}/${SPACEPORN_ID}"
ZIG_COMPONENT_ID="${COMPONENT_ID}/${ZIG_ID}"
ZIG_ITERATOR_ID="${ITERATOR_ID}/${ZIG_ID}"

### Tags ######################################################################
ALPINE_TAG='3.19'
BASH_TAG='5.2'
COLLECTOR_TAG='latest'
CONTROLLER_TAG='latest'
DOCKER_TAG='dind'
EDITOR_TAG='latest'
JUMPER_TAG='latest'
LINUXSERVER_PROXY_TAG='latest'
PROXY_TAG='latest'
SPACEPORN_RUNNER_TAG='latest'
ZIG_TAG='0.12.0'

### Extern Images #############################################################
# into the shell: export http_proxy='https://you.custom.proxy:<port>'
#ALPINE_IMG='local_alpine'
#BASH_IMG='local_bash'
#DOCKER_IMG='local_docker'
#LINUXSERVER_PROXY_IMG='local_proxy'
ALPINE_IMG="docker.io/alpine:${ALPINE_TAG}"
BASH_IMG="docker.io/bash:${BASH_TAG}"
DOCKER_IMG="docker.io/docker:${DOCKER_TAG}"
LINUXSERVER_PROXY_IMG="lscr.io/linuxserver/socket-proxy:${LINUXSERVER_PROXY_TAG}"

### Intern Images #############################################################
### Final Images ##############################################################
COLLECTOR_IMG="${OWNER_ID}/${COLLECTOR_ID}:${COLLECTOR_TAG}"
CONTROLLER_IMG="${OWNER_ID}/${CONTROLLER_ID}:${CONTROLLER_TAG}"
EDITOR_IMG="${OWNER_ID}/${EDITOR_ID}:${EDITOR_TAG}"
JUMPER_IMG="${OWNER_ID}/${JUMPER_ID}:${JUMPER_TAG}"
PROXY_IMG="${OWNER_ID}/${PROXY_ID}:${PROXY_TAG}"
### Runners Images ############################################################
SPACEPORN_RUNNER_IMG="${OWNER_ID}/${SPACEPORN_RUNNER_ID}:${SPACEPORN_RUNNER_TAG}"
### Iterators Images ##########################################################
ZIG_ITERATOR_IMG="${OWNER_ID}/${ZIG_ITERATOR_ID}:${ZIG_TAG}"
### Components Images #########################################################
ZIG_COMPONENT_IMG="${OWNER_ID}/${ZIG_COMPONENT_ID}:${ZIG_TAG}"

### Paths #####################################################################
DATA_PATH='/opt/data'
CRONTABS_PATH='/etc/crontabs'
CRONTABS_LOG_PATH='/var/log/cron.log'
ETC_NGX_PATH='/etc/nginx'
DOCKER_PATH='/usr/local/bin'
OPT_SCRIPTS_PATH='/opt/scripts'
OPT_SSH_PATH='/opt/ssh'
SOCKET_PATH='/var/run/docker.sock'
SSH_ROOT_PATH='/root/.ssh'
VAR_LOG_PATH='/var/log'
WORKSPACES_PATH='/workspaces'
COMPLETION_PATH="${DATA_PATH}/99completion"
ENTRYPOINT_PATH="${OPT_SCRIPTS_PATH}/docker_entrypoint.sh"
CRON_LOG_PATH="${VAR_LOG_PATH}/cron.log"
MY_WHALE_FLEET_PATH="${WORKSPACES_PATH}/my-whale-fleet"

### Volumes ###################################################################
MY_WHALE_FLEET_VOLUME='my-whale-fleet'
PROXY_FS_VOLUME="${PROXY_ID}-fs"
COLLECTOR_VAR_LOG_VOLUME="${COLLECTOR_ID}-var-log-fs"
COLLECTOR_ETC_CRONTABS_VOLUME="${COLLECTOR_ID}-etc-crontabs-fs"
COLLECTOR_OPT_DATA_VOLUME="${COLLECTOR_ID}-opt-data-fs"
COLLECTOR_OPT_SCRIPTS_VOLUME="${COLLECTOR_ID}-opt-scripts-fs"
SSH_VOLUME='shared-ssh'

### Networks ##################################################################
JUMP_AREA_NET='jump-area'
PROXIFIED_SOCKET_NET='proxified-socket'
NET_PREFIX='172.17'
SUBNET_MASK='/24'

### Subnets ###################################################################
PROXIFIED_SOCKET_PREFIX="${NET_PREFIX}.1"
JUMP_AREA_PREFIX="${NET_PREFIX}.2"
PROXIFIED_SOCKET_SUB="${PROXIFIED_SOCKET_PREFIX}.0${SUBNET_MASK}"
JUMP_AREA_SUB="${JUMP_AREA_PREFIX}.0${SUBNET_MASK}"

### IPs #######################################################################
PROXIFIED_SOCKET_GATEWAY_IP="${PROXIFIED_SOCKET_PREFIX}.1"
JUMP_AREA_GATEWAY_IP="${JUMP_AREA_PREFIX}.1"
PROXY_IP="${PROXIFIED_SOCKET_PREFIX}.2"
COLLECTOR_IP="${PROXIFIED_SOCKET_PREFIX}.3"
CONTROLLER_IP="${PROXIFIED_SOCKET_PREFIX}.4"

### Ports #####################################################################
PROXY_PORT='2363'

### Users #####################################################################
UNPRIVILEGED_USER='visitor'

### URLs ######################################################################
API_URL='https://raw.githubusercontent.com/moby/moby/master/docs/api'
MY_WHALE_FLEET_URL='https://github.com/tiawl/my-whale-fleet'
ZIG_BUILDS_URL='https://ziglang.org/builds'

### Docker host ###############################################################
DOCKER_HOST="${PROXY_ID}:${PROXY_PORT}"
HTTP_DOCKER_HOST="http://${DOCKER_HOST}"
TCP_DOCKER_HOST="tcp://${DOCKER_HOST}"

###############################################################################

OS_IMG="${ALPINE_IMG}"
