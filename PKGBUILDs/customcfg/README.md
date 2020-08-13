# customcfg

Generates grub-compatible boot menu entries into file **/boot/grub/custom.cfg**
in Arch based and other supported operating systems.<br>
Currently recognized systems: Arch, Antergos, EndeavourOS, Manjaro, LinuxMint and Windows.<br>
The generated custom.cfg is very similar to <i>/boot/grub/grub.cfg</i>,
but may be helpful if an entry in current grub.cfg is unable to boot,
so it can be seen also as a helpful addition to grub.cfg.

Prevously this tool was named 'antergos-customcfg'.

Note that this tool is not extensively tested,
so there may be bugs lying around.

Try command 'customcfg --help' for more info about options and usage.

## Caveats

- Tested only with the following filesystems: ext4, ext2, vfat, ntfs. Currently other filesystems are simply ignored.
- Tested only with Arch, Antergos, EndeavourOS, Manjaro, and LinuxMint. May still work (partially) on other systems.
- The tool recognizes the latest Windows systems, but this is not extensively tested and may generate false results.

## Changes
0.2: 2020-Aug-13
- Shortened the generated OS names by removing the suffix/prefix "Linux".

0.1.71: 2019-Jul-18
- added support for EndeavourOS (experimental, not yet tested)
- added support for amd-ucode
- option --extras-isofile supports ISOs from Arch, Antergos, EndeavourOS and Manjaro.

0.1.68: 2019-Jun-27
- minor bug fixes: no more trying to delete a mounted folder, better cleanup
- new option --extras-nogui for generating menu entries for login without GUI

0.1.65: 2019-Apr-02
- recognizing swap partitions
- generating menu entries for booting without a graphical desktop (currently only Antergos)

0.1.64: 2019-Feb-16
- menu entries have now also label info if it exists

0.1.63: 2019-Feb-02
- bug fixes

0.1.57: 2018-Jun-20
- added Shutdown and Restart menu entries
- added support for booting Arch and Manjaro ISO files 
- added support for kernel parameters using variable GRUB_CMDLINE_LINUX_DEFAULT from /etc/default/grub
- showing devices at menu entry title
- added config file /boot/grub/custom.conf (see example file here!)
- creating a backup (file name with a date suffix) of current custom.cfg before overwriting it

0.1.42: 2018-Apr-19
- added option --extras-savedefault for adding support for 'savedefault' in custom.cfg (and grub.cfg)

0.1.41: 2018-Mar-28
- minor fix for Windows detection

0.1.40: 2018-Mar-07
- added option --extras-isofile that enables booting directly from Antergos installer ISO file

0.1.38: 2018-Mar-06
- added check for existence of intel-ucode.img on Arch based systems

0.1.37: 2018-Mar-04
- Windows fixes
- show output directly about found OSs

0.1.36: 2018-Feb-27
- generate a "separating info line" before custom.cfg entries
- fixed an unnecessary warning message for Windows generation

0.1.34: 2018-Feb-25
- bug fixes for Windows generation

0.1.30: 2018-Feb-23
- fixed LinuxMint generation for old kernels

0.1.29: 2018-Feb-22
- generate inclusion of another file (/boot/grub/custom01.cfg) which is used if it exists
- chmod the output file properly

0.1.27: 2018-Feb-18
- fixed a bug in Windows menuentry generation

0.1.26: 2018-Feb-17
- more bug fixes

0.1.24: 2018-Feb-17
- several bug fixes

0.1.23: 2018-Feb-17
- added options --debug and --genprefer
- minor other modifications

0.1.22: 2018-Feb-16
- added options --help and --verbose
- minor layout changes
- minor change in Windows menuentry generation

0.1.21: 2018-Feb-16
- Code rewrite.
- Not using <i>os-prober</i> anymore.
- Added support for separate /boot partition.
