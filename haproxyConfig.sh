#!/bin/bash

# Define log directory and file (定义日志目录和文件)
LOG_DIR="./log"
mkdir -p $LOG_DIR  # Ensure log directory exists (确保日志目录存在)
LOG_FILE="$LOG_DIR/$(date '+%Y-%m-%d').log"

create_config() {
    echo "Creating new HAProxy configuration... (创建新的 HAProxy 配置...)"

    # Ask for the name of the configuration file (询问配置文件的名称)
    read -p "Enter the name of the configuration file (输入配置文件的名称): " CONFIG_NAME
    CONFIG_NAME=${CONFIG_NAME:-haproxy_generated.cfg}

    # Ask for basic configurations (询问基本配置)
    read -p "Frontend IP (default: *): " FRONTEND_IP
    read -p "Frontend Port (default: 1935): " FRONTEND_PORT
    read -p "Backend IP (default: 127.0.0.1): " BACKEND_IP
    read -p "Backend Port: " BACKEND_PORT

    # Set default values (设置默认值)
    FRONTEND_IP=${FRONTEND_IP:-*}
    FRONTEND_PORT=${FRONTEND_PORT:-1935}
    BACKEND_IP=${BACKEND_IP:-127.0.0.1}

    # Initialize advanced settings variables (初始化高级设置变量)
    REVERSE_PROXY_SETTINGS=""
    OTHER_SETTINGS=""

    # Loop for advanced settings (轮询高级设置)
    while true; do
        echo "Advanced settings: (高级设置:)"
        echo "1. Custom log file location (自定义日志文件位置)"
        echo "2. Reverse proxy settings (反向代理设置)"
        echo "3. Other common settings (其他常用设置)"
        echo "4. Finish advanced settings (完成高级设置)"
        read -p "Select an option (选择一个选项) (1-4): " ADVANCED_OPTION

        case "$ADVANCED_OPTION" in
            1)
                read -p "Enter log file location: " CUSTOM_LOG_LOCATION
                if [[ -n $CUSTOM_LOG_LOCATION ]]; then
                    LOG_FILE=$CUSTOM_LOG_LOCATION
                fi
                ;;
            2)
                read -p "Enter reverse proxy IP: " REVERSE_PROXY_IP
                read -p "Enter reverse proxy Port: " REVERSE_PROXY_PORT
                if [[ -n $REVERSE_PROXY_IP && -n $REVERSE_PROXY_PORT ]]; then
                    REVERSE_PROXY_SETTINGS="acl is_websocket hdr(Upgrade) -i WebSocket\n    use_backend ws_backend if is_websocket\nbackend ws_backend\n    server ws $REVERSE_PROXY_IP:$REVERSE_PROXY_PORT"
                fi
                ;;
            3)
                # Other common settings (例如，超时设置) (Other common settings (e.g., timeout settings))
                read -p "Enter connect timeout: " TIMEOUT_CONNECT
                read -p "Enter client timeout: " TIMEOUT_CLIENT
                read -p "Enter server timeout: " TIMEOUT_SERVER
                if [[ -n $TIMEOUT_CONNECT && -n $TIMEOUT_CLIENT && -n $TIMEOUT_SERVER ]]; then
                    OTHER_SETTINGS="timeout connect $TIMEOUT_CONNECT\n    timeout client $TIMEOUT_CLIENT\n    timeout server $TIMEOUT_SERVER"
                fi
                ;;
            4)
                # Finish advanced settings (完成高级设置)
                break
                ;;
            *)
                echo "Invalid option. (无效选项)"
                ;;
        esac
    done

    # Generate configuration file content (生成配置文件内容)
    CONFIG_CONTENT=$(cat <<EOF
global
    log /dev/log local0
    log /dev/log local1 notice
    chroot /var/lib/haproxy
    user haproxy
    group haproxy
    daemon
    log-send-hostname
    log-tag HAProxy

defaults
    log     global
    mode    tcp
    option  tcplog
    option  dontlognull
    log-format "%ci:%cp [%t] %ft %b/%s %Tw/%Tc/%Tt %B %ts %ac/%fc/%bc/%sc/%rc %sq/%bq"
    $OTHER_SETTINGS

frontend rtmp_in
    bind $FRONTEND_IP:$FRONTEND_PORT
    mode tcp
    default_backend rtmp_servers

backend rtmp_servers
    mode tcp
    server rtmp1 $BACKEND_IP:$BACKEND_PORT check

$REVERSE_PROXY_SETTINGS
EOF
)
    
    # Save the configuration content to file (将配置文件内容保存到文件)
    echo "$CONFIG_CONTENT" > $CONFIG_NAME
    echo "Configuration file created: $CONFIG_NAME (配置文件已创建: $CONFIG_NAME)"
}

create_config
