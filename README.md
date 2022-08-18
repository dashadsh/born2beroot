Project was done on M1 Mac. 

1. Partition
In case of automated partition, 2 boot partitions will be created: /boot, /boot/efi plus crypto partition with LVM.

Apparently creating EFI partition would be enough - but it opens GNU-GRUB shell on a startup. 
Using ‘exit’ command bootloader should be configured:
Boot Maintenance Manager 
→ Boot Options 
→ Add Boot Option 
→ NO VOLUME LABEL 
→ EFI 
→ debian 
→ grubaa64.efi 
→ Input description, commit changes.
Boot sequence can be changed.

Manual partition with creating 2 boot partition works.

2. Full virtualization vs. paravirtualization 
Partitions will be displayed as 'vda' disks.

3. Signature
To retrieve retrieve the signature from the ".qcow2" file:
open an Image folder inside born2beroot.utm
(example:
/Users/dariagoremykina/Library/Containers/com.utmapp.UTM/Data/Documents/born2beroot.utm/Images).

Run 'shasum data.qcow2' command.
