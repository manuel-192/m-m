# pau
<strong>pau</strong> is a package updater app that uses pacman and/or an AUR helper (like `paru` or `yay`)
depending on how it is called.
<strong>pau</strong> is also a package including more apps described below.

To make the update experience smoother, it has additional features.

## Pau features

Feature | Description
:--- | :---
Unlock pacman database | When you start <strong>pau</strong>, another package management process *may* be running in the backgound and the pacman database may be locked. Or a previous package management session may have left the database unnecessarily locked.<br><strong>pau</strong> detects this and removes the lock if no process is using the lock.
Update keyring packages before others | To help dealing with some keyring keys being outdated, <strong>pau</strong> always tries to update the Arch and EndeavourOS keyring packages first. Then it handles other updates.
Check nvidia vs. kernel updates | For systems with Nvidia graphics, <strong>pau</strong> checks that packages<br>- `linux` and `nvidia`<br>- `linux-lts` and `nvidia-lts`<br>will be updated *together*, respectively.<br>Note: this feature depends on another EndeavourOS specific package.
Run sync command after an update | <strong>pau</strong> runs the `sync` command after update. This is meant to make sure all changed files are properly stored to the disk instead of just the filesystem cache.
Disk space check | <strong>pau</strong> checks that available disk space is above a common minimum or a limit that can be set by the user. If the disk space is low, <strong>pau</strong> gives a warning message.

## Usage of pau

See the usage with command
```
pau -h
```

## Additional apps

App | Description
:--- | :---
pac | pacman with additional features for<br>- update and AUR (via pau)<br>- avoiding sudo (via Pacman)
Pacman | Like pacman, but use sudo only if needed.
