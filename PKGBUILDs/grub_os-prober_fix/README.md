# grub_os-prober_fix

Fixes generation of grub.cfg for Arch based distros.

IMPORTANT: updates `/boot/grub/grub.cfg`. You *may* need to run `grub-install` (with proper parameters for your system) before reboot!

Name | Description
---- | -----------
eos-grub-fix-initrd-generation | Fixes generation of 'initrd' lines in grub.cfg.
eos-grub-fix-initrd-generation.hook | Runs the fixer when <b>grub</b> or <b>os-prober</b> is updated.

<br>

## eos-grub-fix-initrd-generation

Upstream command `grub-mkconfig` may generate file **/boot/grub/grub.cfg** incorrectly for some operating systems.
The problem is that generated **initrd** lines may lack the essential **initramfs** parameter:
```
initrd  /boot/intel-ucode.img   # error: missing initramfs image!
```
This is because packages `grub` and `os-prober` do not co-operate well.
Now `eos-grub-fix-initrd-generation` fixes files in both `grub` and `os-prober` which helps in generating the **initrd** line properly:
```
initrd  /boot/intel-ucode.img /boot/initramfs-linux.img
```

## eos-grub-fix-initrd-generation.hook

This hook runs `eos-grub-fix-initrd-generation` when at least one of packages
- `os-prober`
- `grub`
- `grub-silent`

is upgraded.

But *if* upstream fixes the **initrd** issue in `grub` and `os-prober`, then
- remove hook `eos-grub-fix-initrd-generation.hook`
- reinstall packages `grub` and `os-prober`
