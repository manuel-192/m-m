# Getting started with EndeavourOS

Thank you for installing and using EndeavourOS!

EndeavourOS is based on the Arch operating system. This means EndeavourOS has all the features of the Arch system. In addition, EndeavourOS has a graphical installer and a few additional apps.

EndeavourOS is using the Arch package repositories directly, and has a small own repository for the additional apps. This means the EndeavourOS installation gets also Arch updates without any additional delay.

This article is about showing some useful *terminal* commands available in Arch and/or EndeavourOS systems, including some commonly useful tips.

## Installation

To download the latest ISO, see https://endeavouros.com/latest-release.

To burn the ISO to a USB stick, see https://discovery.endeavouros.com/installation/create-install-media-usb-key.

If dual booting with Windows, the following preparations are required:
- disable Secure Boot
- disable Fast Boot

Then plug in the USB stick and reboot. Installation will start. Simply follow the instructions provided by the installer.

Tip: the basic installation will take about 4..10 gigabytes of disk space, depending on what features were selected.

## Basic maintenance of the installed system

Tip: starting a terminal is desktop dependent, e.g. `konsole` on *KDE* or `xfce4-terminal` on *Xfce*. Should be easy to find from the menu.

To get information about various (Arch) commands, use the `man` command on the terminal.<br>
For example:
```
man pacman          # Tip: learn how to use 'pacman' !
```
Note that there's a related program
```
eos-apps-info
```
for describing most of the EndeavourOS apps.

Tip: commands below have a lot more *options* than presented here. It is strongly advisable to learn more about the available options using the `man` command.

### Update system

```
sudo pacman -Syu    # Update Arch & EndeacourOS (=native) packages
yay                 # Update all packages (including AUR (=foreign))
```
Related EndeavourOS app:
```
eos-update          # Update the native packages (makes some additional checks)
eos-update --yay    # The same (including AUR)
```

### Installing packages

```
sudo pacman -S <name-of-a-package>   # installs a named package (native)
yay -S <name-of-a-package>           # installs a named package (native or AUR)
```

Tip: it is a good idea to get system fully updated while installing packages (especially if update hasn't been done lately).<br>
For example, you might want to use options `-Syu` instead: `yay -Syu <name-of-a-package>`.

### Mirror lists

Mirror lists describe which package sources you are currently using for installing or updating native packages.<br>
EndeavourOS is using two mirror lists:

```
/etc/pacman.d/mirrorlist                # mirrors for the Arch packages
/etc/pacman.d/endeavouros-mirrorlist    # mirrors for the EndeavourOS packages
```

Sometimes one or more mirrors become temporarily (or permanently) offline, and then you may need to re-order (i.e. *rank*) the list of mirrors in order to properly update or install packages.<br>
You can re-order the lists either *manually* (mirrors are used by pacman in the order they are listed), or using a specific program like
```
rate-mirrors          # can update Arch and EndeavourOS mirrorlist (separately)
reflector             # can update only Arch mirrorlist
reflector-simple      # can update only Arch mirrorlist (GUI)
eos-rankmirrors       # can update only EndeavourOS mirrorlist
```

Tip: some commands do not have a man page, or the man page is rather limited. Then you can get some help with option `--help` after the command name, e.g.

```
reflector --help | less
```


After you change either of the mirror lists, you should update the system with command

```
sudo pacman -Syyu     # note the double 'y'
```

### Managing disk space

In the long run the disk space may run out for many reasons. One obvious reason is the **package cache** which may grow without limits if not taken care of.

Program `paccache` can be used to manually manage packages in the package cache.<br>
For example,

```
paccache -rk3     # deletes cached package versions older than the latest 3
paccache -ruk0    # deletes cached packages that are no more installed
```
Tip: EndeavourOS has program
```
paccache-service-manager
```
that provides a simple way to automate the management of the package cache.

### Welcome

The `welcome` app provides a simple (GUI-ish) way to handle some of the system maintenance tasks described above.

To start Welcome, run

```
eos-welcome        # if Welcome is not disabled
eos-welcome -1     # if Welcome is disabled
```

or simply click the Welcome icon on the system menu.

## More information

[The EndeavourOS wiki](https://discovery.endeavouros.com) includes useful articles about using the EndeavourOS system.

[The Arch wiki](https://discovery.endeavouros.com) contains lots of detailed articles about the Arch system. These are applicable to EndeavourOS systems as well.

### EndeavourOS forum

If you encounter any problem that you cannot solve on your own, be sure to join the [EndeavourOS forum](https://forum.endeavouros.com) and ask for help. Friendly and knowledgeable community members are willing to find and share the solution.

Or simply join the forum to enjoy the chat in a friendly atmosphere!
