# monitoring script (M1)

SIC! ‘Ctrl + L’ cleares shell

SIC! to search for manual:

```
<command> --help
```

**HOW TO WRITE THE SCRIPT (used for M1 MAC, UTM, ARM Debian)**

Table of content**:**

1. **#!/bin/bash (She-Bang)**
2. **Command substitutions**
3. **Wall**
4. **Possible look**
5. **Possible output**
6. **Some useful links**

---

**#!/bin/bash (She-Bang)**

Essentially it tells your terminal that when you run the script it should use bash to execute it. It can be vital since you may be using a different shell in your machine ( zsh , fish , sh , etc.), but you designed the script to work specifically with bash.

Bash has more advanced features than Shell. Having more advanced features just makes Bash more usable and effective in its functioning. That is why Bash is more commonly used as compared to Shell.

A big advantage of Bash is that it can easily be debugged as compared to Shell. Finding errors and fixing scripts in Shell are considerably harder than finding errors in a script written in Bash:

```
 #!/bin/bash
```

---

**COMMAND SUBSTITUTIONS**

**Architecture**

‘uname’ command,

‘-a’ flag (add details):

```
ARCH=$(uname -a)
```

**CPU, number of physical processors.**

‘lscpu’ command gathers together info from /proc/cpuinfo (try lscpu and cat /proc/cpuinfo) to make it more readable for user. I’ll be also using it here to get CPU and vCPU.

SIC! only architectures with a weak memory model (such as ARM and ARM64) does support multicore emulation (on ARM) - so i’m getting 4 and 4 as result.

‘nproc’ prints the number of processing units available to the current process, which may be less than the number of online processors

‘-all’ prints the number of installed processors

‘grep’ command searches for PATTERN in each file or standard input. 

‘awk’ command searches file for text containing a pattern. When a line or text matches, awk performs a specific action on that line/text. The Program statement tells awk what operation to do.

'{print $4}' is the column we need to print (4th argument).

```
PCPU=$(nproc --all)                                        
or
PCPU=$(lscpu | grep 'Core(s) per socket' | grep -oE "[0-9]+$")
or
PCPU=$(lscpu | grep 'Core(s) per socket' | awk '{print $4}')
```

**vCPU, number of virtual processors.**

’wc’ (word count) command in Unix/Linux operating systems is used to find out number of newline count, word count, byte and characters count in a files specified by the file arguments. Try ‘wc —help’.

‘-l‘ flag to count number of newlines in a file, which prints the number of lines from a given file.

```
VCPU=$(lscpu | grep 'CPU(s):'| head -1 | grep -oE "[0-9]+$")
or
VCPU=$(lscpu | grep 'CPU(s):'| head -1 | awk '{print $2}')
or
VCPU=$(grep processor /proc/cpuinfo | wc -l)
```

**Memory usage**

‘free’ command.

‘-m’ flag gives us information in MB.

```
RAM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
RAM_USED=$(free -m | grep Mem | awk '{print $3}')
RAM_PERC=$(free | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')
```

**Disk Space Usage**

‘df’ command.

‘-h’ flag for displaying data in Gb.

‘—total’ flag gives total amount of space on all discs:

```
DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
DISK_USED=$(df -h --total | grep total | awk '{print $3}')
DISK_PERC=$(df --total | grep total | awk '{print $5}')
```

**CPU Load.** 

‘top’ (**t**able **o**f **p**rocesses) command shows a real-time view of running processes in Linux and displays kernel-managed tasks. The command also provides a system information summary that shows resource utilisation, including CPU and memory usage.

‘-b’ - batch mode, allowing to send the command's output to a file or other programs. ’top’ doesn't accept input in batch mode and runs until killed or until it reaches the specified iteration limit.

‘-n[X]’ (for ‘X’ specify number of times you want top to refresh the output) - to instruct ‘top’ to quit automatically after refreshing the stats for a specified number of times.

You can use ^ and $ to force a regex to match only at the start or end of a line.

%% to show % sign.

‘head -1’ will output only first line, and then you can pipe that output to grep.

```
CPU_LOAD=$(top -bn1 | grep '^%Cpu' | xargs | awk '{printf("%.1f%%"), $2 + $4}')
or
CPU_LOAD=$(top -bn2 | grep '^%Cpu'| head -1 | awk '{printf("%.1f%%"), $2 + $4}')
or
CPU_LOAD=$(top -bn1 | grep load | awk '{printf "%.2f%%\n", $(NF-2)}')
```

Alternative solution could be installing ‘systat’. After installing the above function, you can run the necessary commands to check the CPU usage (like ‘mpstat’) and use them for script:

```
$ apt install sysstat
$ mpstat
```

**Date and time of last boot**

‘who’ command. 

‘-b’ flag s showing time of last boot (apparently same information is given w/o the flag).

```
LAST_BOOT=$(who -b | awk '{print($3 " " $4)}')
```

**LVM use**

‘if…fi’ statement is the fundamental control statement that allows Shell to make decisions and execute statements conditionally:

```
if [ expression ] 
then 
   Statement(s) to be executed if expression is true 
fi
```

```
LVM=$(if [ $(lsblk | grep lvm | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
```

**Connections TSP**

```
TCP=$(grep TCP /proc/net/sockstat | awk '{print $3}')
```

**User log**

```
USER_LOG=$(who | wc -l)
```

**Network (IPv4 address of server and it's Media Access Control address)**

‘I’, --all-ip-addresses all addresses for the host

```
IP_ADDR=$(hostname -I | awk '{print $1}')
MAC_ADDR=$(ip link show | grep link/ether | awk '{print $2}')
```

**SUDO (Amt. of commands executed with ‘sudo’)**

```
SUDO_LOG=$(grep COMMAND /var/log/sudo/sudo.log | wc -l)
```

---

**Wall**

Wall is a command that allows you to write a message to all users, in all terminals. It can receive either a text (it broadcasts message like ‘echo’) or a file content (like ’cat’).

By default, ‘wall’ broadcasts message with a banner on top. For this project, the banner is optional.

To use wall you have two options:

- wall <”message”>
- wall  -n <”message”> - displays with no banner:

```
wall -n " 
       Architecture    : $ARCH
       CPU physical    : $PCPU
       vCPU            : $VCPU
       Memory Usage    : $RAM_USED/${RAM_TOTAL}MB ($RAM_PERC)               #use {} to insert MB correctly
       Disk Usage      : $DISK_USED/$DISK_TOTAL ($DISK_PERC)
       CPU Load        : $CPU_LOAD
       Last Boot       : $LAST_BOOT
       LVM use         : $LVM
       Connections TSP : $TCP established
			 User log        : $USER_LOG
       Network         : IP $IP_ADDR ($MAC_ADDR)
       Sudo            : $SUDO_LOG commands executed"
```

We can use ‘echo’ instead of ‘wall’:

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
```

---

And its output:

```
       Architecture    : Linux dgoremyk42 5.10.0-17-arm64 #1 SMP Debian 5.10.136-1 (2022-08-13) aarch64 GNU/Linux
       CPU physical    : 4
       vCPU            : 4
       Memory Usage    : 67/977MB (6.95%)
       Disk Usage      : 1.4G/12G (13%)
       CPU Load        : 1.6%
       Last Boot       : 2022-08-17 18:12
       LVM use         : yes
       Connections TSP : 1 established
       User log        : 1
       Network         : IP 10.0.2.15 (6a:8c:80:93:eb:df)
       Sudo            : 128 commands executed
```

---

**SOME USEFUL LINKS**

grep

[https://www.cyberciti.biz/faq/howto-use-grep-command-in-linux-unix/](https://www.cyberciti.biz/faq/howto-use-grep-command-in-linux-unix/)

[https://www.cyberciti.biz/faq/grep-regular-expressions/?utm_source=Linux_Unix_Command&utm_medium=faq&utm_campaign=nixcmd](https://www.cyberciti.biz/faq/grep-regular-expressions/?utm_source=Linux_Unix_Command&utm_medium=faq&utm_campaign=nixcmd)

awk

[https://www.tutorialspoint.com/unix_commands/awk.htm](https://www.tutorialspoint.com/unix_commands/awk.htm)

xagrs

[https://flaviocopes.com/linux-command-xargs/](https://flaviocopes.com/linux-command-xargs/)

if…fi

[https://www.tutorialspoint.com/unix/if-fi-statement.htm](https://www.tutorialspoint.com/unix/if-fi-statement.htm)

CPU

[https://www.baeldung.com/linux/get-cpu-usage](https://www.baeldung.com/linux/get-cpu-usage)

[https://phoenixnap.com/kb/top-command-in-linux](https://phoenixnap.com/kb/top-command-in-linux)

wall

[https://en.wikipedia.org/wiki/Wall_(Unix)](https://en.wikipedia.org/wiki/Wall_(Unix))