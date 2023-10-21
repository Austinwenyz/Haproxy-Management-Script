#!/bin/bash

# Define log directory and file (定义日志目录和文件)
LOG_DIR="./log"
mkdir -p $LOG_DIR  # Ensure log directory exists (确保日志目录存在)
LOG_FILE="$LOG_DIR/$(date '+%Y-%m-%d').log"

# Get the path of haproxy (获取 haproxy 的路径)
HAPROXY_PATH=$(which haproxy)
if [[ -z $HAPROXY_PATH ]]; then
    echo "HAProxy is not installed or not in the PATH. (HAProxy 没有安装或不在 PATH 中)"
    exit 1
fi

# Get configuration files in the current directory (获取当前目录中的配置文件)
CONFIG_FILES=($(ls *.cfg 2> /dev/null))
NUM_CONFIG_FILES=${#CONFIG_FILES[@]}

# Select configuration file (选择配置文件)
CONFIG_FILE=""
if (( NUM_CONFIG_FILES == 0 )); then
    echo "No configuration files found in the current directory. (当前目录中没有找到配置文件)"
    exit 1
elif (( NUM_CONFIG_FILES == 1 )); then
    CONFIG_FILE=${CONFIG_FILES[0]}
else
    echo "Multiple configuration files found. Please select one: (找到多个配置文件，请选择一个:)"
    select CONFIG_FILE in "${CONFIG_FILES[@]}"; do
        break
    done
fi

# Define functions to start, stop, and restart HAProxy (定义启动、停止和重启 HAProxy 的函数)
start_haproxy() {
    echo "Starting HAProxy with $CONFIG_FILE... (使用 $CONFIG_FILE 启动 HAProxy...)"
    nohup $HAPROXY_PATH -f $CONFIG_FILE >> $LOG_FILE 2>&1 &
    echo "HAProxy started. (HAProxy 已启动)"
}

stop_haproxy() {
    echo "Stopping HAProxy... (停止 HAProxy...)"
    pkill -f "$HAPROXY_PATH -f $CONFIG_FILE"
    echo "HAProxy stopped. (HAProxy 已停止)"
}

restart_haproxy() {
    echo "Restarting HAProxy... (重启 HAProxy...)"
    stop_haproxy
    start_haproxy
    echo "HAProxy restarted. (HAProxy 已重启)"
}

# Numbered navigation functionality (数字导航功能)
echo "1. Start HAProxy (启动 HAProxy)"
echo "2. Stop HAProxy (停止 HAProxy)"
echo "3. Restart HAProxy (重启 HAProxy)"
echo "4. Create HAProxy Configuration (创建 HAProxy 配置)"
read -p "Select an option (选择一个选项) (1-4): " OPTION

case "$OPTION" in
    1)
        start_haproxy
        ;;
    2)
        stop_haproxy
        ;;
    3)
        restart_haproxy
        ;;
    4)
        ./haproxyConfig.sh
        ;;
    *)
        echo "Invalid option. (无效选项)"
        echo "Usage: $0 (用法)"
        exit 1
        ;;
esac

exit 0
