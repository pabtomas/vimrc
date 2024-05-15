#! /bin/sh

path 'bash_aliases' '/etc/profile.d/99aliases.d'
path 'bash_completion' '/etc/profile.d/99completion.d'
path 'data' '/opt/data'
path 'crontabs' '/etc/crontabs'
path 'crontabs_log' '/var/log/cron.log'
path 'etc_ngx' '/etc/nginx'
path 'docker' '/usr/local/bin'
path 'opt_scripts' '/opt/scripts'
path 'opt_ssh' '/opt/ssh'
path 'safedeposit' '/root/.password-store'
path 'socket' '/var/run/docker.sock'
path 'ssh_root' '/root/.ssh'
path 'tpm' '/root/.tmux/plugins/tpm'
path 'var_log' '/var/log'
path 'workspaces' '/workspaces'
path 'completion' "${DATA_PATH}/99completion"
path 'entrypoint' "${OPT_SCRIPTS_PATH}/docker_entrypoint.sh"
path 'entrypointd' "$(dirname "${ENTRYPOINT_PATH}")/$(basename -s '.sh' "${ENTRYPOINT_PATH}").d"
path 'cron_log' "${VAR_LOG_PATH}/cron.log"
path 'my_whale_fleet' "${WORKSPACES_PATH}/${COMPOSE_PROJECT_NAME}"
path 'spaceporn' "${WORKSPACES_PATH}/${SPACEPORN_ID}"