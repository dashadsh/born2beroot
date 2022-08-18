Project was done on M1 Mac.

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
