HOW TO WRITE THE SCRIPT

 #!/bin/bash (She-Bang): to force bash execute the script. Bash has more advanced features than Shell. Having more advanced features just makes Bash more usable and effective in its functioning. That is why Bash is more commonly used as compared to Shell.

A big advantage of Bash is that it can easily be debugged as compared to Shell. Finding errors and fixing scripts in Shell are considerably harder than finding errors in a script written in Bash:

```
 #!/bin/bash
```

After it we are defining variables for our script.

Architecture of operating system and its kernel version:

```
ARCH=$(uname -a)
```

lscpu gathers together info from /proc/cpuinfo (try lscpu and cat /proc/cpuinfo) to make it more readable for user. I’ll be also using it here to get CPU and vCPU.

Only architectures with a weak memory model (such as ARM and ARM64) does support multicore emulation (on ARM) - so i’m getting 4 and 4 as result.

We use grep command to search for PATTERN in each file or standard input.

Number of physical processors:

```
PCPU=$(lscpu | grep 'Core(s) per socket' | grep -oE "[0-9]+$")
```

Number of virtual processors:

```
VCPU=$(lscpu | grep 'CPU(s):'| head -1 | grep -oE "[0-9]+$")
```

Available RAM on your server, it's utilization rate as a percentage. Free command gives us memory information, in MB using -m flag.

```
RAM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
RAM_USED=$(free -m | grep Mem | awk '{print $3}')
RAM_PERC=$(free | grep Mem | awk '{printf("%.2f%%"), $3 / $2 * 100}')
```

df is Disk Space Usage command.