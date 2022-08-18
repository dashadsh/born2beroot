# vm settings

You must create at least 2 encrypted partitions using LVM:

```
CHECK PARTITION
$ lsblk
```

AppArmour should run at startup:

```
TEST APP-ARMOUR
$ sudo aa-status
```

In order to install packages update APT (Advanced Packaging Tool):

```
APT
$ apt update
$ apt upgrade
```

Depends on text editor you may install vim or use preinstalled nano:

```
FOR VIM USERS(optional)
$ sudo apt install vim
```

The hostname of your virtual machine must be your login ending with 42 (e.g., dgoremyk42). You will have to modify this hostname during your evaluation:

```
CHECK HOSTNAME
$ sudo hostnamectl
OR
$ hostnamectl status

CHANGE HOSTNAME
$ sudo hostnamectl set-hostname <new_hostname> 
OR
nano /etc/hostname
```

To be able execute commands as a root install sudo (You have to install and configure sudo following strict rules, see below):

```
SUDO INSTALLATION
$ apt install sudo
$ sudo --version
```

To switch between users:

```
HOW TO SWITCH USER
$ su root OR $ su -
$ su exit (login as a last user before logging in as a root)
$ su dgoremyk
```

Add user to sudo group:

```
ADD USER TO SUDO GROUP
$ sudo usermod -aG sudo <username>
$ getent group sudo
OR
$ sudo visudo ($nano /etc/sudoers)
add "dgoremyk   ALL=(ALL:ALL) ALL"

CHECK IF IT WORKED
$ sudo whoami
```

Create a new group (’dgoremyk42’ in my case) and add ‘dgoremyk’ user to it:

```
CREATE GROUP AND ADD USER
$ addgroup dgoremyk42
$ getent group dgoremyk42
$ sudo usermod -aG dgoremyk42 <username>

CHECK USER BELONG TO GROUPS
$ groups sudo
$ groups dgoremyk
```

Optional commands for reboot and shutdown:

```
$ sudo shutdown now
$ sudo reboot
```

SSH will be running on port 4242 only. It must be not possible to connect using SSH as a root:

```
SSH CONFIGURATION
$ sudo apt install openssh-server
$ sudo systemctl status ssh
$ sudo nano /etc/ssh/sshd_config

change "Port 22" to "Port 42" (uncommented!) 
add "PermitRootLogin no"

APPLY NEW SETTINGS
$ sudo systemctl restart ssh
```

Configure UFW firewall, leave only 4242 port open:

```
UFW INSTALLATION
$ apt install ufw
$ ufw status
$ ufw enable
$ ufw status

UFW STATUS
$ sudo ufw status verbose

CHANGE UFW SETTINGS
$ sudo ufw default deny incoming
$ sudo ufw default allow outgoing
$ ufw allow 4242
```

Before we can connect to VM from another machine using SSH, there should be some settings done in UTM.

```
open VM settings->network
from 'network mode'->select 'emulated VLAN'
from 'port forward'-> select 'new'
guest port-> enter '4242'
host port-> enter '4242'
```

Establish SSH connection from host machine. Open terminal:

```
$ ssh <username>@localhost -p 4242
enter password (for <username> user)
exit (if needed)
```

Set up strong password policy:

```
SET UP PASSWORD EXPIRATION POLICY
$ nano /etc/login.defs
PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7

(If the /var/log/sudo directory doesn’t exist, you might have to mkdir sudo in /var/log/)

APPLY NEW SETTINGS
$ sudo chage -M 30 <username/root>
$ sudo chage -m 2 <username/root>
$ sudo chage -W 7 <username/root>

CHECK THAT SETTINGS WERE APPLIED
$ sudo chage -l <username/root>

INSTALL PACKAGE CONTROLLING PASSWORD QUALITY
$ sudo apt install libpam-pwquality

ADD NEW PASSWORD RULES
$ nano /etc/pam.d/common-password (or edit /etc/security/pwquality.conf)
password        requisite	pam_pwquality.so retry=3 maxrepeat=3 minlen=10 dcredit=-1 ucredit=-1 reject_username difok=7 enforce_for_root
(how to create different dw policies?)

CHANGE PASSWORD
$passwd user
$passwd root
```

Implement strong configuration for sudo group. 

```
SUDO SETTINGS
$ sudo visudo 
Defaults     passwd_tries=3
Defaults     badpass_message="Wrong password. Try again!"
Defaults     logfile="/var/log/sudo/sudo.log" (Each action using sudo has to be archived, both inputs and outputs. The log file has to be saved in the /var/log/sudo/ folder)
Defaults     log_input
Defaults     log_output
Defaults     requiretty (the TTY mode has to be enabled for security reasons)

TEST IF SUDO LOGS ARE PRESENT
$ nano /var/log/sudo/sudo.log
```

Change some TTY settings (optionally):

```
TTY SETTINGS (optional)
$ nano /etc/systemd/logind.conf

NAutoVTs=6 (uncomment)
ReserveVT=6 (uncomment)
```

Set up monitoring.sh:

```
INSTALL NET-TOOLS(package is a collection of programs for controlling the network subsystem of the Linux kernel.)
$ apt-get install net-tools

CREATE SCRIPT
$ su <username>
$ cd ~/
$ touch monitoring.sh
$ ls -la monitoring.sh

GIVE THE SCRIPT EXECUTABLE RIGHTS
$ chmod +x ./monitoring.sh OR chmod 755 monitoring.sh
$ ls -la monitoring.sh

FORCE SCROPT EXECUTION
$ sudo bash monitoring.sh

EDIT SCRIPT
$ nano monitoring.sh 
```

Use crontab for script to be able run every 10 minutes:

```
CRONTAB INSTALLATION
$ sudo systemctl status cron
$ systemctl enable cron
$ sudo crontab -e

*/10 * * * * sh /home/dgoremyk/monitoring.sh

CHECK CRONTAB IS WORKING
$ sudo crontab -u root -l

DISABLE CRON (for defense)
$ sudo systemctl disable cron 
```