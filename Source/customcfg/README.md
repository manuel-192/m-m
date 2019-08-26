# customcfg
Generates grub boot menu entries into file <b>/boot/grub/custom.cfg</b> in Arch and derivatives.
Recognizes also other operating system installations, such as Arch, Antergos, EndeavourOS, Manjaro, LinuxMint and Windows.
Generated custom.cfg is very similar to <i>/boot/grub/grub.cfg</i>,
but may be helpful if an entry in current grub.cfg is unable to boot, so it can be seen also as a helpful addition to grub.cfg.

Note that this project is not extensively tested, so there may be bugs lying around.

Try command 'customcfg --help' for more info about options and usage.

## Caveats

- Tested only with the following filesystems: ext4, ext2, vfat, ntfs. Currently other filesystems are simply ignored.
- Tested only with Arch, Antergos, EndeavourOS, Manjaro, and LinuxMint. May still work (partially) on other systems.
- Generation basically works with the latest Windows systems, but they are not extensively tested.
