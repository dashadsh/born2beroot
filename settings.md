```
CHECK PARTITION
$ lsblk

APT
$ apt update
$ apt upgrade

HOW TO SWITCH USER?
$ su root
$ su dgoremyk OR exit
$ su - (login as root)

SUDO INSTALLATION
$ apt install sudo
$ sudo --version

SSH CONFIGURATION
$ sudo apt install openssh-server
$ sudo systemctl status ssh
$ sudo nano /etc/ssh/sshd_config
(here change "Port 22" to "Port 42" (uncommented!) and add "PermitRootLogin no")
$ sudo systemctl restart ssh (to apply new settings)

ADD USER TO SUDO GROUP
$ sudo usermod -aG sudo <username>
$ getent group sudo
OR
$ sudo visudo ($nano /etc/sudoers)
add "dgoremyk   ALL=(ALL:ALL) ALL"

$ sudo whoami (check if it worked)

CREATE GROUP AND ADD USER
$ addgroup dgoremyk42
$ getent group dgoremyk42
$ sudo usermod -aG dgoremyk42 dgoremyk

OPTIONAL
$ sudo shutdown now
$ sudo reboot

SYSTEM SNAPSHOT (OPTIONAL)

ADDING PORT SETTING TO UTM
open VM settings->network
network mode->"emulated VLAN"
port forward->new
guest port->4242
host port->4242

SSH CONNECTION FROM HOST TERMINAL
$ ssh <username>@localhost -p 4242
enter password (for <username> user)
exit (if needed)

CHECK USER BELONG TO GROUPS
$ groups sudo dgoremyk (or "groups sudo", "groups user" - dgoremyk should appear in sudo group)

EDIT HOSTNAME
$ sudo hostnamectl (check hostname) 
$ sudo hostnamectl set-hostname <new_hostname> (change hostname)
OR
nano /etc/hostname
$ hostnamectl status

SUDO SETTINGS
$ sudo visudo 
Defaults     passwd_tries=3
Defaults     badpass_message="Wrong password. Try again!"
Defaults     logfile="/var/log/sudo/sudo.log" (Each action using sudo has to be archived, both inputs and outputs. The log file has to be saved in the /var/log/sudo/ folder)
Defaults     log_input
Defaults     log_output
Defaults     requiretty (the TTY mode has to be enabled for security reasons)

$ nano /var/log/sudo/sudo.log (to test if logs are present)

TTY (kind of multiple desktops)
$ nano /etc/systemd/logind.conf

NAutoVTs=6 (uncomment)
ReserveVT=6 (uncomment)

UFW (FIREWALL)

$ apt install ufw
$ ufw status
$ ufw enable
$ ufw status

$ sudo ufw status verbose

$ sudo ufw default deny incoming
$ sudo ufw default allow outgoing

$ ufw allow 4242

PASSWORDS
$ nano /etc/login.defs
PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7

(If the /var/log/sudo directory doesn’t exist, 
we might have to mkdir sudo in /var/log/)

$ sudo chage -M 30 <username/root>
$ sudo chage -m 2 <username/root>
$ sudo chage -W 7 <username/root>
$ sudo chage -l <username/root>

$ sudo apt install libpam-pwquality

$ nano /etc/pam.d/common-password (or edit /etc/security/pwquality.conf)
password        requisite	pam_pwquality.so retry=3 maxrepeat=3 minlen=10 dcredit=-1 ucredit=-1 reject_username difok=7 enforce_for_root
(how to create different dw policies?)

$passwd user
$passwd root

TEST APP-ARMOUR
$ sudo aa-status

??? ADDUSER/USERADD
adduser - user/group/password
useradd - user only

FOR SCRIPT
$ apt-get install net-tools
$ su <username>
$ cd ~/
$ touch monitoring.sh
$ ls -la monitoring.sh
$ chmod +x ./monitoring.sh OR chmod 755 monitoring.sh
$ ls -la monitoring.sh

CRONTAB
$ sudo systemctl status cron
$ systemctl enable cron (optional "sudo systemctl disable cron")
$ sudo crontab -e
*/10 * * * * sh /home/dgoremyk/monitoring.sh

FORCE THE SCRIPT
$ sudo bash monitoring.sh

MONITORING.SH
$ nano monitoring.sh       

```