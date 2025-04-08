#!/bin/bash
# 检查TCP监听端口连接并发数

# 检查是否提供了端口号
if [ $# -eq 0 ]; then
    PORT=""  # 默认不检查特定端口
else
    PORT=$1  # 使用用户提供的端口号
fi

# 检查当前用户的文件描述符限制
echo "=== 当前用户的文件描述符限制 ==="
ulimit -n

# 检查系统级别的文件描述符最大值
echo -e "\n=== 系统级别的文件描述符最大值 ==="
sysctl fs.file-max

# 检查连接跟踪表最大值
echo -e "\n=== 连接跟踪最大值 ==="
sysctl net.netfilter.nf_conntrack_max

# 检查半连接SYN队列大小
echo -e "\n=== 半连接SYN队列大小,受限全连接队列 ==="
sysctl net.ipv4.tcp_max_syn_backlog

# 检查当前的SYN-RECV连接数量
echo -e "\n=== 当前半连接SYN-RECV连接数量 ==="
ss -n state syn-recv | grep -v 'State' | wc -l

# 检查全连接队列大小
echo -e "\n=== 全连接队列大小,限制SYN队列 ==="
sysctl net.core.somaxconn

# 检查当前的ESTABLISHED连接数量
echo -e "\n=== 当前ESTABLISHED连接数量 ==="
ss -n state established | grep -v 'State' | wc -l

# 如果提供了端口号，检查该端口的监听状态和连接数量
if [ -n "$PORT" ]; then
    echo -e "\n=== 当前$PORT端口的监听状态 ==="
    ss -tunlp | grep ":$PORT"

    echo -e "\n=== 当前$PORT端口的SYN-RECV连接数量 ==="
    ss -n state syn-recv sport = :$PORT | wc -l

    echo -e "\n=== 当前$PORT端口的ESTABLISHED连接数量 ==="
    ss -n state established sport = :$PORT | wc -l
fi