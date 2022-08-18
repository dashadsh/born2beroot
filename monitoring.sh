#!/bin/bash

# Architecture of operating system and its kernel version
ARCH=$(uname -a)

# Number of physical processors
PCPU=$(lscpu | grep 'Core(s) per socket' | grep -oE "[0-9]+$")

# Number of virtual processors
VCPU=$(lscpu | grep 'CPU(s):'| head -1 | grep -oE "[0-9]+$")

# Available RAM on your server, it's utilization rate as a percentage
RAM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
RAM_USED=$(free -m | grep Mem | awk '{print $3}')
RAM_PERC=$(free | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')

# Disk usage
DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
DISK_USED=$(df -h --total | grep total | awk '{print $3}')
DISK_PERC=$(df -k --total | grep total | awk '{print $5}')

# Utilization rate of your processors as a percentage
CPU_LOAD=$(top -bn1 | grep '^%Cpu' | xargs | awk '{printf("%.1f%%"), $2 + $4}')

# Date and time of last boot
LAST_BOOT=$(who -b | awk '{print($3 " " $4)}')

# LVM activity
LVM=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

# Active connections
TCP=$(grep TCP /proc/net/sockstat | awk '{print $3}')

# Users on server
USER_LOG=$(who | wc -l)

# IPv4 address of server and it's Media Access Control address
IP_ADDR=$(hostname -I | awk '{print $1}')
MAC_ADDR=$(ip link show | grep link/ether | awk '{print $2}')

# Amount commands executed with sudo
SUDO_LOG=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)

wall -n " 
		Architecture    : $ARCH
       	CPU physical    : $PCPU
       	vCPU            : $VCPU
       	Memory Usage    : $RAM_USED/${RAM_TOTAL}MB ($RAM_PERC) # use{} to insert MB correctly
       	Disk Usage      : $DISK_USED/$DISK_TOTAL ($DISK_PERC)
       	CPU Load        : $CPU_LOAD
       	Last Boot       : $LAST_BOOT
       	LVM use         : $LVM
       	Connections TSP : $TCP established
		User log        : $USER_LOG
       	Network         : IP $IP_ADDR ($MAC_ADDR)
       	Sudo            : $SUDO_LOG commands executed"