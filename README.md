# Collection of Manuel's packages.

This repo includes packages created by Manuel (repository [m-m]).
<br><br>

How to use this repo? Check these [instructions](../../../m-repo-info/blob/master/README.md).<br>
[List of packages](../../../m-m/releases) (same as the <b>Releases</b> button above).

## NEWS
- 2019-10-21: added pahis, paccache-service-manager, reboot-required, suc.
- 2019-08-26: added 'arch-news-for-you' and 'remirror-arch'.
- 2019-08-04: the old server address works no more. I has been replaced with another, see [instructions](../../../m-repo-info/blob/master/README.md).
- 2019-07-30: now you can use also
<pre>
<strike>Server = https://github.com/manuel-192/antergos-m/releases/download/assets</strike>
</pre>
The old server address has been removed.

## Packages

Name | Description
---- | ----
akm | Simple Antergos kernel manager.
arch-cl | Shows the changelog of an Arch package.
cp-completion | Replacement for the official bash completion for the 'cp' command.<br> Supports many more options of the 'cp' command than the official version.<br>Note: this package also installs a program <b>remove_cp_command_from_common_completions</b> that can be used for removing the 'cp' command from the official bash completion.<br>It needs to be run only once, and after every upgrade of package <b>bash-completion</b>.
customcfg | Creates a new file /boot/grub/custom.cfg containing boot menu entries. Meant to supplement /boot/grub/grub.cfg that is generated by grub.<br>Previously named as <i>antergos-customcfg</i>.<br>See [changelog](https://github.com/manuel-192/m-m/tree/master/PKGBUILDs/customcfg)
eat | An easy to use pastebin helper.<br>"Eat" file contents or command outputs and send them to pastebin.
paccache-service-manager | Manages the systemd service that limits the number of packages in the package cache.
pahis | Pacman package history viewer.
pkexec2 | Wrapper for pkexec, retaining the current working directory instead of changing it to /root.
reboot-required | A hook to recommend a reboot when certain system packages have been upgraded.
remirror | Rank mirrors on Arch (used to do so also on Antergos).<br>See [changelog](https://github.com/manuel-192/m-m/tree/master/PKGBUILDs/remirror)<br>
remirror-arch | Rank Arch mirrors. Like remirror above, but with a new implementation.<br>More: https://github.com/manuel-192/m-m/tree/master/Source/remirror-arch
suc | A simple wrapper for command 'su -c'.<br>Useful especially in bash scripts because it supports spaces in the command parameters.
syu | A very simple pacman wrapper.
UserManager | Simple graphical user manager.<br>Mainly for Xfce users in systems where there is no graphical user manager.
yaygg | A simple GUI based launcher generator, based on the yad framework.<br>See [changelog](PKGBUILDs/yaygg)
