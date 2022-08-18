Project was done on M1 Mac.

In case of automated partition, 2 boot partitions will be created: /boot, /boot/efi.

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

Since i didn't succed with EFI only, i reproduced manual partition, created:
EFI partition (~500 MB), /boot (~500 MB, mounted as a boot),
created crypto partition,
configured LVM/mounts.
