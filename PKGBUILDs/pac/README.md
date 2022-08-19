# pac
'pac' is an package updater that uses pacman and/or an AUR helper
depending on how it is called.

To make the updat experience smoother, it also checks and manages certain special things like explained below.

## Detect pacman database lock

When you start `pac`, another package management process *may* be running in the backgound and the pacman database may be locked. Or a previous update session may have left the database unnecessarily locked.<br>
`pac` detects this and removes the lock if no process is using the lock.

## Install keyring packages before others

`pac` always tries to "update" the Arch and EndeavourOS keyring packages first. Then it handles other updates.

## Check nvidia vs. kernel updates

For systems with Nvidia graphics, `pac` checks rh´that packages
- `linux` and `nvidia`
- `linux-lts` and `nvidia-lts`

will be updated *together*.

## Run sync command after an update

`pac` runs the `sync` command after update. This is meant to make sure all changed files are properly stored to the disk instead of just the cache.