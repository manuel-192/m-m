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

Note: `ncd` does not support cd options -L nor -P.

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
The two configuration files mentioned above contain full or partial path definitions, one definition per line.<br>
There is a third configuration file ~/.config/ncd/ncd.conf that sets general ncd options.
### ~/.config/ncd/paths example
```
~/Documents
~/MyData/Projects
```
These paths are the starting points for recursive search of *leaf* folders (last in any path in a tree).<br>
For example, if folders ~/Documents/Work/Projects and ~/Documents/Work/Admin exist, then command
```
ncd Proj
```
would change directory to ~/Documents/Work/Projects.<br>
See more examples below.

### ~/.config/ncd/excludes example
```
/.git/
/.git$/
/OldStuff/
/OldStuff$
```
They are used for excluding (full) paths that contain these strings.<br>
Note: these paths can contain `grep` expression syntax (see the trailing '$' above).

### ~/.config/ncd/ncd.conf example
```
NCD_OPTS=(--showdir)
NCD_PATHS_OPTS=(--follow-symlinks)
NCD_EXCLUDES_OPTS=()
```
This configuration file sets properties for the ncd function.

Currently the following options are supported:

Variable | Supported options | Description
:--- | :--- | :---
NCD_OPTS | --showdir | Makes ncd show the new directory name after changing to it.
NCD_PATHS_OPTS | --follow-symlinks | ncd will follow symbolic links when searching for paths.<br>Note that following symbolic links may cause endless loops,<br>so be careful with this option if you have symbolic links in the search paths.<br>That's why it is not enabled by default.
NCD_EXCLUDES_OPTS | (none)

<br>

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
drwxr-xr-x 2 manuel manuel 4096 2020-09-20 18:54 EndeavourOS-archiso-builder
drwxr-xr-x 3 manuel manuel 4096 2020-09-24 23:33 akm
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 b43-firmware
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 calamares_august_2020
drwxr-xr-x 2 manuel manuel 4096 2020-09-19 13:00 calamares_offline_online
drwxr-xr-x 2 manuel manuel 4096 2020-09-08 18:21 calamares_test
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 ckbcomp
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 endeavouros-developer-mirrorlist
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 endeavouros-keyring
drwxr-xr-x 3 manuel manuel 4096 2020-09-19 23:47 endeavouros-mirrorlist
drwxr-xr-x 2 manuel manuel 4096 2020-09-21 17:39 endeavouros-theming
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 endeavouros-xfce4-terminal-colors
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 eos-base
drwxr-xr-x 3 manuel manuel 4096 2020-09-25 10:22 eos-bash-shared
drwxr-xr-x 3 manuel manuel 4096 2020-09-12 22:30 eos-hooks
drwxr-xr-x 4 manuel manuel 4096 2020-09-04 17:31 eos-log-tool
drwxr-xr-x 3 manuel manuel 4096 2020-09-05 23:26 eos-pkgbuild-setup
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 eos-rankmirrors
drwxr-xr-x 3 manuel manuel 4096 2020-09-23 15:52 eos-update-notifier
drwxr-xr-x 2 manuel manuel 4096 2020-09-18 23:21 grub-theme-endeavouros
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 grub-tools
drwxr-xr-x 3 manuel manuel 4096 2020-09-04 17:32 keyserver-rank
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 nvidia-installer
drwxr-xr-x 3 manuel manuel 4096 2020-09-24 21:06 nvidia-installer-db
drwxr-xr-x 3 manuel manuel 4096 2020-09-10 18:22 nvidia-installer-dkms
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 openswap
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 pahis
drwxr-xr-x 2 manuel manuel 4096 2020-09-04 17:26 reflector-auto
drwxr-xr-x 3 manuel manuel 4096 2020-09-20 19:35 reflector-simple
drwxr-xr-x 4 manuel manuel 4096 2020-09-22 20:41 welcome
drwxr-xr-x 6 manuel manuel 4096 2020-09-04 17:26 z_archived
-rw-r--r-- 1 manuel manuel  200 2020-09-04 17:26 README.md
$
$ ls -l ~/EndeavourOS/PKGBUILDS/welcome
total 368
drwxr-xr-x 2 manuel manuel      4096 2020-09-04 17:26 wiki-pictures
-rw-r--r-- 1 manuel manuel      8686 2020-09-04 17:26 Adding-own-commands.md
-rw-r--r-- 1 manuel manuel      7126 2020-09-22 20:40 PKGBUILD
-rw-r--r-- 1 manuel manuel       751 2020-09-04 17:26 README.md
-rwxr-xr-x 1 manuel manuel      1508 2020-09-04 17:26 calamares-update
-rw-r--r-- 1 manuel manuel       645 2020-09-04 17:26 changelog.md
-rw-r--r-- 1 manuel manuel       484 2020-09-04 17:26 changelog.txt
-rwxr-xr-x 1 manuel manuel       493 2020-09-04 17:26 eos-kill-yad-zombies
-rwxr-xr-x 1 manuel manuel      1610 2020-09-15 13:22 eos-set-background-picture
-rw-r--r-- 1 manuel manuel       986 2020-09-04 17:26 ksetwallpaper.py
-rw-r--r-- 1 manuel manuel     11552 2020-09-15 16:51 translations-welcome-de.bash
-rw-r--r-- 1 manuel manuel     10752 2020-09-15 10:44 translations-welcome-en.bash
-rw-r--r-- 1 manuel manuel     10823 2020-09-04 17:26 translations-welcome-es.bash
-rw-r--r-- 1 manuel manuel     11187 2020-09-15 13:27 translations-welcome-fi.bash
-rw-r--r-- 1 manuel manuel     11645 2020-09-13 18:50 translations-welcome-fr.bash
-rw-r--r-- 1 manuel manuel      9057 2020-09-04 17:26 translations-welcome-it.bash
-rw-r--r-- 1 manuel manuel      8854 2020-09-04 17:26 translations-welcome-pl.bash
-rw-r--r-- 1 manuel manuel     10147 2020-09-04 17:26 translations-welcome-pt.bash
-rw-r--r-- 1 manuel manuel      8442 2020-09-04 17:26 translations-welcome-reference.bash
-rw-r--r-- 1 manuel manuel      9169 2020-09-04 17:26 translations-welcome-ro.bash
-rw-r--r-- 1 manuel manuel     14345 2020-09-22 20:39 translations-welcome-ru.bash
-rw-r--r-- 1 manuel manuel      8807 2020-09-04 17:26 translations-welcome-se.bash
-rw-r--r-- 1 manuel manuel     12066 2020-09-16 12:39 translations-welcome-sk.bash
-rw-r--r-- 1 manuel manuel      9681 2020-09-05 23:22 translations-welcome-zh.bash
-rw-r--r-- 1 manuel manuel      7893 2020-09-04 17:26 translations-welcome.bash
-rwxr-xr-x 1 manuel manuel      1421 2020-09-20 19:36 wallpaper-once
-rw-r--r-- 1 manuel manuel       331 2020-09-04 17:26 wallpaper-once.desktop
-rwxr-xr-x 1 manuel manuel     57766 2020-09-27 21:23 welcome
-rwxr-xr-x 1 manuel manuel      4065 2020-09-04 17:26 welcome-dnd
-rw-r--r-- 1 manuel manuel     33684 2020-09-04 17:26 welcome-dnd-tips.png
-rw-r--r-- 1 manuel manuel     17909 2020-09-04 17:26 welcome-dnd-window.png
-rwxr-xr-x 1 manuel manuel       495 2020-09-04 17:26 welcome.desktop
```
this is the output of the following commands (note: option --showdir is used):
```
$ ncd ~/Documents
~/Documents
$ ncd
~
$ ncd wel
~/EndeavourOS/PKGBUILDS/welcome
$ ncd nvidi
 1   ~/EndeavourOS/PKGBUILDS/nvidia-installer
 2   ~/EndeavourOS/PKGBUILDS/nvidia-installer-db
 3   ~/EndeavourOS/PKGBUILDS/nvidia-installer-dkms
Select number or Q: 3
~/EndeavourOS/PKGBUILDS/nvidia-installer-dkms
$ ncd wiki-pic
~/EndeavourOS/PKGBUILDS/welcome/wiki-pictures
$ ncd -
~/EndeavourOS/PKGBUILDS/nvidia-installer-dkms
```
