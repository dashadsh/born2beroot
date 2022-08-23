```
# installation M1, UTM, ARM Debian 11

Project was done on M1 Mac.

**PARTITION**

AUTOMATED

In case of automated partition, 2 boot partitions will be created: /boot, /boot/efi plus crypto partition with LVM.

MANUAL USING EFI BOOT PARTITION ONLY

Debian 11 arm64 cd image boots and installs just fine under UTM (QEMU) on an Apple M1 Mac, but when the VM reboots you’ll be thrown to the UEFI screen instead of seeing the usual GRUB boot menu with no clue as to what the problem might be.

Here’s a workaround that will let you boot from the install disk again.

- Type ‘exit’ in shell
- Go to Boot Maintenance Manager
- Boot Options
- Add Boot Option
- Select the volume, it should be the only volume there
- Select EFI
- Select debian
- Select grubaa64.efi
- Give the Boot Option a description
- Commit your changes

Now go back and change the boot order so that the newly created Boot Option is at the top of the list.

Thats it, your Debian VM should now boot and stay bootable between restarts.

MANUAL USING 2 BOOT PARTITIONS

Manual partition with creating 2 boot partition works as well.

**VIRTUALIZATION VS. PARAVIRTUALIZATION**

Partitions will be displayed as 'vda' disks.

**SIGNATURE**

To retrieve retrieve the signature from the ".qcow2" file: open an Image folder inside born2beroot.utm (example: /Users/dariagoremykina/Library/Containers/com.utmapp.UTM/Data/Documents/born2beroot.utm/Images).

Run 'shasum data.qcow2' command.