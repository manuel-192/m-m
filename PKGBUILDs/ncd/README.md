# ncd - cd and $CDPATH combined and more

**ncd** is a bash function that can be used for changing directories in very much the same way as the traditional `cd` command.<br>
`ncd` simply provides more control in selecting the target directory.

For `cd` user may create a variable CDPATH which cd uses as potential "root" directories where the
"leaf" directories reside.

`ncd` can use CDPATH too. In addition to CDPATH, `ncd` can use two configuration files
```
$HOME/.config/ncd/paths
$HOME/.config/ncd/excludes
```
to better define which directories to use or *not* to use.

Note: `ncd` does not support cd option -L nor -P.

## Install
Install ncd in the normal Arch way:
```
sudo pacman -S ncd
```
This will write file **ncd-helper.bash** into `/etc/skel`.<br>
Another step is still needed: user should *source* file ncd-helper.bash in $HOME/.bashrc by adding the following line into `~/.bashrc`:
```
source /etc/skel/ncd-helper.bash
```
Finally, user needs to *source* file ~/.bashrc. This can be done in several alternative ways, e.g. directly `source ~/.bashrc`, or log out and log in, or reboot and log in.

## Configuration files
The two configuration files (mentioned above) contain full or partial path detinitions, one definition per line.
### ~/.config/ncd/paths example
```
~/Documents
~/MyData/Projects
```
### ~/.config/ncd/excludes example
```
/.git/
/.git$/
/OldStuff/
/OldStuff$
```
They are used for excluding (full) paths that contain these strings.<br>
Note: these paths can contain `grep` expression syntax (see the trailing '$' above).

## Full example
Assuming the following paths in ~/.config/ncd/paths:
```
~/EndeavourOS/PKGBUILDS
```
and the following exclude definitions in ~/.config/ncd/excludes:
```
/.git/
/.git$
```
and the following directory contents:
```
$ ls -l ~/EndeavourOS/PKGBUILDS
total 128
drwxr-xr-x 2 edi edi 4096 2020-09-20 18:54 EndeavourOS-archiso-builder
drwxr-xr-x 3 edi edi 4096 2020-09-24 23:33 akm
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 b43-firmware
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 calamares_august_2020
drwxr-xr-x 2 edi edi 4096 2020-09-19 13:00 calamares_offline_online
drwxr-xr-x 2 edi edi 4096 2020-09-08 18:21 calamares_test
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 ckbcomp
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 endeavouros-developer-mirrorlist
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 endeavouros-keyring
drwxr-xr-x 3 edi edi 4096 2020-09-19 23:47 endeavouros-mirrorlist
drwxr-xr-x 2 edi edi 4096 2020-09-21 17:39 endeavouros-theming
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 endeavouros-xfce4-terminal-colors
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 eos-base
drwxr-xr-x 3 edi edi 4096 2020-09-25 10:22 eos-bash-shared
drwxr-xr-x 3 edi edi 4096 2020-09-12 22:30 eos-hooks
drwxr-xr-x 4 edi edi 4096 2020-09-04 17:31 eos-log-tool
drwxr-xr-x 3 edi edi 4096 2020-09-05 23:26 eos-pkgbuild-setup
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 eos-rankmirrors
drwxr-xr-x 3 edi edi 4096 2020-09-23 15:52 eos-update-notifier
drwxr-xr-x 2 edi edi 4096 2020-09-18 23:21 grub-theme-endeavouros
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 grub-tools
drwxr-xr-x 3 edi edi 4096 2020-09-04 17:32 keyserver-rank
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 nvidia-installer
drwxr-xr-x 3 edi edi 4096 2020-09-24 21:06 nvidia-installer-db
drwxr-xr-x 3 edi edi 4096 2020-09-10 18:22 nvidia-installer-dkms
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 openswap
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 pahis
drwxr-xr-x 2 edi edi 4096 2020-09-04 17:26 reflector-auto
drwxr-xr-x 3 edi edi 4096 2020-09-20 19:35 reflector-simple
drwxr-xr-x 4 edi edi 4096 2020-09-22 20:41 welcome
drwxr-xr-x 6 edi edi 4096 2020-09-04 17:26 z_archived
-rw-r--r-- 1 edi edi  200 2020-09-04 17:26 README.md
```
this is the output of the following commands:
```
$ pwd
/home/manuel/Documents
$ ncd
$ pwd
/home/manuel
$ ncd wel
$ pwd
/home/manuel/EndeavourOS/PKGBUILDS/welcome
$ ncd nvidi
 1   ~/EndeavourOS/PKGBUILDS/nvidia-installer
 2   ~/EndeavourOS/PKGBUILDS/nvidia-installer-db
 3   ~/EndeavourOS/PKGBUILDS/nvidia-installer-dkms
Select number or Q: 3
$ pwd
/home/manuel/EndeavourOS/PKGBUILDS/nvidia-installer-dkms
$ ncd -
$ pwd
/home/manuel/EndeavourOS/PKGBUILDS/welcome
```
