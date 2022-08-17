**HOW TO WRITE THE SCRIPT (used for M1 MAC, UTM, ARM Debian)**

**Structure:**

1. **#!/bin/bash (She-Bang)**
2. **Command substitutions**
3. **Wall**
4. **Possible look**
5. **Output**

---

**#!/bin/bash (She-Bang)**

To force bash execute the script. Bash has more advanced features than Shell. Having more advanced features just makes Bash more usable and effective in its functioning. That is why Bash is more commonly used as compared to Shell.

A big advantage of Bash is that it can easily be debugged as compared to Shell. Finding errors and fixing scripts in Shell are considerably harder than finding errors in a script written in Bash:

```
 #!/bin/bash
```

---

**COMMAND SUBSTITUTIONS**

**Architecture** of operating system and its kernel version using uname (outputs “Linux”) with -a(adds details):

```
ARCH=$(uname -a)
```

**CPU and vCPU:**

Lscpu command gathers together info from /proc/cpuinfo (try lscpu and cat /proc/cpuinfo) to make it more readable for user. I’ll be also using it here to get CPU and vCPU.

Only architectures with a weak memory model (such as ARM and ARM64) does support multicore emulation (on ARM) - so i’m getting 4 and 4 as result.

We use grep command to search for PATTERN in each file or standard input.

Number of physical processors:

```
PCPU=$(lscpu | grep 'Core(s) per socket' | grep -oE "[0-9]+$")
or
PCPU=$(lscpu | grep 'Core(s) per socket' | awk '{print $4}')
```

Number of virtual processors:

```
VCPU=$(lscpu | grep 'CPU(s):'| head -1 | grep -oE "[0-9]+$")
or
VCPU=$(lscpu | grep 'CPU(s):'| head -1 | awk '{print $2}')
or
VCPU=$(grep processor /proc/cpuinfo | wc -l)
```

**Memory usage** using free command with -m flag (gives us information in MB) and grep. 

awk command searches file for text containing a pattern. When a line or text matches, awk performs a specific action on that line/text. The Program statement tells awk what operation to do. ([https://www.tutorialspoint.com/unix_commands/awk.htm](https://www.tutorialspoint.com/unix_commands/awk.htm))

'{print $2}' is the column we need to print:

```
RAM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
RAM_USED=$(free -m | grep Mem | awk '{print $3}')
RAM_PERC=$(free | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')
```

**Disk Space Usage** command is df. Flag -h for displaying data in Gb. flag —total gives total amount of space on all discs:

```
DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
DISK_USED=$(df -h --total | grep total | awk '{print $3}')
DISK_PERC=$(df -k --total | grep total | awk '{print $5}')
```

**CPU Load.** top command, -bn1 shows 1st iteration. 

You can use ^ and $ to force a regex to match only at the start or end of a line ([https://www.cyberciti.biz/faq/howto-use-grep-command-in-linux-unix/](https://www.cyberciti.biz/faq/howto-use-grep-command-in-linux-unix/), [https://www.cyberciti.biz/faq/grep-regular-expressions/?utm_source=Linux_Unix_Command&utm_medium=faq&utm_campaign=nixcmd](https://www.cyberciti.biz/faq/grep-regular-expressions/?utm_source=Linux_Unix_Command&utm_medium=faq&utm_campaign=nixcmd))

```
CPU_LOAD=$(top -bn1 | grep '^%Cpu' | xargs | awk '{printf("%.1f%%"), $2 + $4}')
```

**Date and time of last boot** using who command. Flag -b is showing time of last boot (apparently same information is given w/o the flag).

```
LAST_BOOT=$(who -b | awk '{print($3 " " $4)}')
```

---

**Wall**

Wall is a command that allows you to write a message to all users, in all terminals. It can receive either a text (it broadcasts message like `echo`) or a file content (like `cat`).

By default, `wall` broadcasts message with a banner on top. For this project, the banner is optional.

To use wall you have two options:

- `wall <"message">`
- `wall -n <"message">` - displays with no banner:

```
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
```

Instead of wall we can use echo:

```
## Shows the architecture of the operating system and its kernel version
echo "#Architecture: ${ARCH}"

## Shows the number of physical processors (CPUs)
echo "#CPU physical: ${PCPU}"

## Shows the number of virtual processors (vCPUs)
echo "#vCPU: ${VCPU}"

## Shows the current available RAM on your server and its utilization rate as percentage
echo "#Memory Usage: ${USEDRAM}/${FULLRAM}MB (${PCTRAM}%)"

## Shows the current available memory on your server and its utilization rate as a percentage
echo "#Disk Usage: ${USEDDISK}/${FULLDISK}Gb (${PCTDISK}%)"

## Shows the current utilization rate of your processors as a percentage
echo "#CPU load: ${CPU}"

## Shows the date and time of the last reboot
echo "#Last boot: ${LASTBOOT}"

## Shows whether LVM is active or not
echo "#LVM use: ${LVM}"

## Shows the number of active connections
echo "#Connections TCP: ${TCP} ${TCPMSSG}"

## Shows the number of users using the server
echo "#User log: ${USERLOG}"

## Shows the IPv4 address of your server and its MAC (Media Access Control) address
echo "#Network: IP ${IP}"

## Shows the number of commands executed with the sudo program
echo "#Sudo: ${SUDO} cmd"
```

---

So that’s how script can look like:

```
#!/bin/bash

#Architecture of operating system and its kernel version
ARCH=$(uname -a)

#Number of physical processors
PCPU=$(lscpu | grep 'Core(s) per socket' | grep -oE "[0-9]+$")

#Number of virtual processors
VCPU=$(lscpu | grep 'CPU(s):'| head -1 | grep -oE "[0-9]+$")

#Available RAM on your server, it's utilization rate as a percentage
RAM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
RAM_USED=$(free -m | grep Mem | awk '{print $3}')
RAM_PERC=$(free | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')

#Disk usage
DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
DISK_USED=$(df -h --total | grep total | awk '{print $3}')
DISK_PERC=$(df -k --total | grep total | awk '{print $5}')

#Utilization rate of your processors as a percentage
CPU_LOAD=$(top -bn1 | grep '^%Cpu' | xargs | awk '{printf("%.1f%%"), $2 + $4}')

#Date and time of last boot
LAST_BOOT=$(who -b | awk '{print($3 " " $4)}')

#LVM activity
LVM=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

#Active connections
TCP=$(grep TCP /proc/net/sockstat | awk '{print $3}')

#Users on server
USER_LOG=$(who | wc -l)

#IPv4 address of server and it's Media Access Control address
IP_ADDR=$(hostname -I | awk '{print $1}')
MAC_ADDR=$(ip link show | grep link/ether | awk '{print $2}')

#Amount commands executed with sudo
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
```

---

And its output:

```
       Architecture    : Linux dgoremyk42 5.10.0-17-arm64 #1 SMP Debian 5.10.136-1 (2022-08-13) aarch64 GNU/Linux
       CPU physical    : 4
       vCPU            : 4
       Memory Usage    : 67/977MB (6.95%)
       Disk Usage      : 1.4G/12G (13%)
       CPU Load        : 0.0%
       Last Boot       : 2022-08-17 18:12
       LVM use         : yes
       Connections TSP : 1 established
       User log        : 1
       Network         : IP 10.0.2.15 (6a:8c:80:93:eb:df)
       Sudo            : 0 commands executed
```