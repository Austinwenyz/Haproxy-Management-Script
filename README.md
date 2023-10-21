## README

### 文件名: README.md

---

### HAProxy 管理和配置脚本 (HAProxy Management and Configuration Scripts)

这两个脚本提供了一个简单的方式来管理和配置您的 HAProxy 实例。`haproxySet.sh` 脚本允许您启动、停止和重启 HAProxy，而 `haproxyConfig.sh` 脚本可以帮助您创建一个新的 HAProxy 配置文件。

These two scripts provide a simple way to manage and configure your HAProxy instance. The `haproxySet.sh` script allows you to start, stop, and restart HAProxy, while the `haproxyConfig.sh` script helps you create a new HAProxy configuration file.

---

### 使用方法 (Usage)

1. **管理 HAProxy (`haproxySet.sh`):**

   - 运行脚本，然后按照提示选择要执行的操作，例如启动、停止或重启 HAProxy。
   - 在数字菜单中选择 "Create HAProxy Configuration" (创建 HAProxy 配置) 以运行 `haproxyConfig.sh` 脚本并创建新的配置文件。

   - Run the script and then choose the operation you want to perform, such as starting, stopping, or restarting HAProxy, as prompted.
   - Select "Create HAProxy Configuration" from the numbered menu to run the `haproxyConfig.sh` script and create a new configuration file.

2. **创建 HAProxy 配置 (`haproxyConfig.sh`):**

   - 运行脚本，然后按照提示输入基本配置参数，例如前端和后端的 IP 地址和端口。
   - 在高级设置菜单中选择高级设置选项，或者选择 "Finish advanced settings" (完成高级设置) 以跳过高级设置。
   - 配置文件将根据您的输入生成，并保存到您指定的文件名中。

   - Run the script, then input the basic configuration parameters such as frontend and backend IP addresses and ports, as prompted.
   - Select advanced settings options from the advanced settings menu, or select "Finish advanced settings" to skip advanced settings.
   - The configuration file will be generated based on your inputs and saved to the file name you specified.

---

### 注意事项 (Notes)

- 确保 HAProxy 已经在您的系统上安装。
- 这两个脚本应该在具有适当权限的用户下运行，以确保可以正确地启动 HAProxy 并写入配置和日志文件。

- Ensure that HAProxy is installed on your system.
- These scripts should be run under a user with appropriate permissions to ensure that HAProxy can be started correctly and configuration and log files can be written.

---
