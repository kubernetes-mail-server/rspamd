#!/usr/bin/env sh

function required () {
    eval v="\$$1";

    if [ -z "$v" ]; then
        echo "$1 envvar is not configured, exiting..."
        exit 0;
    else
        [ ! -z "${ENTRYPOINT_DEBUG}" ] && echo "Rewriting required variable '$1' in file '$2'"
        sed -i "s~{{ $1 }}~$v~g" $2
    fi
}

function optional () {
    eval v="\$$1";

    [ ! -z "${ENTRYPOINT_DEBUG}" ] && echo "Rewriting optional variable '$1' in file '$2'"
    sed -i "s~{{ $1 }}~$v~g" $2
}

for file in $(find /etc/rspamd/local.d -type f); do
    required RSPAMD_PASSWORD ${file}
    required RSPAMD_WORKER_PROXY_PORT ${file}
    required RSPAMD_WORKER_CONTROLLER_PORT ${file}
    required CLAMAV_HOSTNAME ${file}
    required CLAMAV_PORT ${file}
    required REDIS_HOSTNAME ${file}
    required REDIS_PORT ${file}
done

echo "Running '$@'"
exec $@