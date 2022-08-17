**HOW TO WRITE THE SCRIPT (used for M1 MAC, UTM, ARM Debian)**

Structure:

1. She-Bang
2. Variables
3. Wall

 **#!/bin/bash (She-Bang):** to force bash execute the script. Bash has more advanced features than Shell. Having more advanced features just makes Bash more usable and effective in its functioning. That is why Bash is more commonly used as compared to Shell.

A big advantage of Bash is that it can easily be debugged as compared to Shell. Finding errors and fixing scripts in Shell are considerably harder than finding errors in a script written in Bash:

```
 #!/bin/bash
```

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
```

**Memory usage** using free command with -m flag (gives us information in MB) and grep. 

awk command searches file for text containing a pattern. When a line or text matches, awk performs a specific action on that line/text. The Program statement tells awk what operation to do. ([https://www.tutorialspoint.com/unix_commands/awk.htm](https://www.tutorialspoint.com/unix_commands/awk.htm))

'{print $2}' is the column we need to print.

```
RAM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
RAM_USED=$(free -m | grep Mem | awk '{print $3}')
RAM_PERC=$(free | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')
```

**Disk Space Usage** command is df. Flag -h for displaying data in Gb. flag —total gives total amount of space on all discs. 

```
DISK_TOTAL=$(df -h --total | grep total | awk '{print $2}')
DISK_USED=$(df -h --total | grep total | awk '{print $3}')
DISK_PERC=$(df -k --total | grep total | awk '{print $5}')
```

**CPU Load.**

```

```

**Date and time of last boot** using who command. Flag -b is showing time of last boot (apparently same information is given w/o the flag).