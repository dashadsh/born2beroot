```
--------PROJECT OVERVIEW-------

Q: How does it works?
Simulates virtual hardware through *virtualization*
Runs applications and other operating systems independent from host machine
Physical machine: *host*, virtual machine(s): *guest*

Q: Why Debian?
A: It's easier to install and configure than CentOS 
(and i haven't use CentOS before)

Q: Basic differences between CentOS and Debian
CentOS	                                      Debian
rebuild from Red Hat commercial distribution	build by independent developers
more user-friendly	                          not so user-friendly
very stable, less updates	                    stable, more updates
few packages	                                huge amount of packages
Q: What is virtual machine?
A: A Virtual Machine (VM) is a compute resource that uses software instead of a physical computer to run programs and deploy
apps. Each virtual machine runs its own operating system and functions separately from the other VMs, even when they are all
running on the same host. For example, you can run a virtual MacOS machine on a physical PC.

Q: What it's purpose?
A: VMs may be deployed to accommodate different levels of processing power needs, to run software that requires a different
operating system, or to test applications in a safe, sandboxed environment.

Q: Diff between aptitude and apt?
A: Aptitude is a high-level package manager while APT is lower-level package manager which can be used by other
higher-level package managers
(read more: [https://www.tecmint.com/difference-between-apt-and-aptitude/](https://www.tecmint.com/difference-between-apt-and-aptitude/))

Q: What is AppArmor?
A: AppArmor ("Application Armor") is a Linux kernel security module that allows the system administrator to restrict programs'
capabilities with per-program profiles.
(read more: [https://en.wikipedia.org/wiki/AppArmor](https://en.wikipedia.org/wiki/AppArmor))
```

```
-------SIMPLE SETUP-------

Check that UFW is running:
$ sudo ufw status

Check that SSH is running:
$ systemctl status ssh

Check Distrubution/Operating System:
$ uname -a
```

```
-------USER-------

Check that user belongs to groups 'sudo' and 'user42':
$ groups

Create a new user:
$ sudo adduser <username>
for verifying: $ sudo chage -l <username>

Explain how to setup password policy:
        for password quality: sudo nano /etc/pam.d/common-password
        for password expiration: sudo nano /etc/login.defs
        for badpass message: sudo visudo

!!! Create a new group 'evaluating':
$ sudo groupadd evaluating
for verifying: $ cat /etc/group

!!! Assign user to group 'evaluating':
$ sudo usermod -aG evaluating <username>
OR $ sudo adduser <username> evaluating             

!!! Check if user belongs to group 'evaluating':
$ sudo groups <username>

Advantages and disadvantages of the password policy:
Advantages: forces stronger passwords, no '123456'
Disadvantages: hard to remember, easy to guess for computers
https://i0.wp.com/www.sapien.com/blog/wp-content/uploads/2020/10/password-strength.png?w=740&ssl=1
```

```
-------HOSTNAME AND PARTITIONS-------

Check the hostname:
$ hostname

Modify the hostname:
1. change hostname in /etc/hostname
OR
$ sudo hostnamectl set-hostname <new_hostname>  
2. To be sure, add the following line after the existing hosts in /etc/hosts: 
127.0.1.1 <newhostname> 
3. $ sudo reboot
4. $ hostname

Restore old hostname:
1. change hostname in /etc/hostname to your old hostname (<yourlogin>42)
2. remove the line you added in /etc/hosts
3. reboot with sudo reboot

Show the partitions of the VM:
$ lsblk

LVM, Logical Volume Management:
Volumes can be resized dynamically as space requirements change and can be migrated between physical devices.
It's easy change partitions, add and remove hardware storage devices.
```

```
-------SUDO--------

Check that 'sudo' is installed:
$ sudo --version

Assign new user to group 'sudo':
$ sudo usermod -aG sudo <new_user>

Show the sudo rule implementations:
$ sudo visudo

Check that '/var/log/sudo/' exists and has at least one file:
Run one command with sudo and check that it was registered by running 
$ sudo ls /var/log/sudo.
```

```
-------UFW-------

UFW is properly installed:
$ sudo ufw --version

UFW is working:
$ sudo systemctl status ufw

List active rules in UFW:
$ sudo ufw status

Add rule to open port 8080:
$ sudo ufw allow 8080

Check that 8080 has been added:
$ ufw status

Delete the new rule:
$ sudo ufw status - check the number of the row you want to delete
$ sudo ufw delete <numberofrow>  - delete row
```

```
-------SSH-------

SSH is installed:
$ shh -V

SSH is working:
$ sudo systemctl status ssh

What is SSH:
short for Secure SHell
protocol for securely logging into remote machines across a network, 
with encryption to protect the transferred information and authentication 
to ensure access only for authorized users

SSH only uses port 4242:
$sudo nano /etc/ssh/sshd_config - scroll to Port 4242

SSH works for newly created user:
open a terminal at your local machine
$ssh <new_user>@localhost -p 4242
login with the credentials of the newly created user

Check that SSH is disabled for root login:
$sudo nano /etc/ssh/sshd_config - scroll to PermitRootLogin
```

```
-------SCRIPT MONITORING-------

How does the script work:
bash script that saves the output of different commands in variables and 
displays them in the format given in the subject paper when run with bash command.
Runs every ten minutes with 'cron' command

What is 'cron':
system utility to schedule programs to run automatically at predetermined intervals/dates/times

Cron setup:
$ sudo crontab -e
*/10 * * * * bash /<path_to_your_monitoring_script>

Modify the script to run every minute (cannot go under 1 minute):
$ sudo crontab -e
*/10 * * * * bash /<path_to_your_monitoring_script> modify to
*/1 * * * * bash /<path_to_your_monitoring_script>

Stop the script running from startup without modifying the script itself:
$ sudo systemctl disable cron
$ sudo reboot

check $ sudo systemctl status cron to verify it's not running
```