#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# @Author：   Super
# @Time:   2025/5/1
# description： 构建一个网络包并发送


from scapy.all import *
import binascii

# 源地址和端口
src_ip = "1.1.1.1"
src_port = 18848
# 目标地址和端口
target_ip = "127.0.0.1"
target_port = 10002

# 构造 64 位（8 字节）的负载数据
payload = (
    b"\xDE\xAD"          # 前 2 字节: 固定值 0xDEAD (示例)
    b"\xBE\xEF"          # 中间 2 字节: 固定值 0xBEEF
    b"\xCA\xFE\xBA\xBE"  # 后 4 字节: 固定值 0xCAFEBABE
)

# 构造 TCP 数据包
packet = IP(src=src_ip,dst=target_ip) / TCP(sport=src_port,dport=target_port,flags="S") / Raw(load=payload)

# 发送数据包
send(packet, verbose=True)

print(f"Sent TCP packet to {target_ip}:{target_port} with payload: {binascii.hexlify(payload)}")