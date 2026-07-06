#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
CRT_BASE_PATH="/usr/syno/etc/certificate"
CRT_PATH_NAME=$(cat ${CRT_BASE_PATH}/_archive/DEFAULT)
CRT_PATH=${CRT_BASE_PATH}/_archive/${CRT_PATH_NAME}

echo "==== $(date '+%Y-%m-%d %H:%M:%S') START ===="

lastUpdate="$(stat -c %Y ${CRT_PATH}/cert.pem)"
now="$(date +%s)"
diff=$(( (now - lastUpdate) / 86400 ))

echo "证书上次更新时间（epoch）: $lastUpdate"
echo "当前时间（epoch）: $now"
echo "已过天数: $diff"

if (( diff > 85 )); then
    echo "证书接近过期，开始更新..."

    ${SCRIPT_DIR}/cert-up.sh update

    if [ $? -eq 0 ]; then
        echo "证书更新成功：*.weix.one"
    else
        echo "证书更新失败：*.weix.one" >&2
        exit 1
    fi
else
    echo "证书未到更新时间（$diff 天）"
fi

echo "==== $(date '+%Y-%m-%d %H:%M:%S') END ===="
