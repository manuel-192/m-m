# wallpaper-changer

Wallpaper-changer changes the wallpaper periodically.

User can specify
- the local folder(s) containing the wallpaper files
- if folders will be searched recursively or not
- the time period between changing wallpapers
- case sensitivity for searching the wallpaper files
- supported wallpaper filename endings

## Installing

Install package `wallpaper-changer`. Then run program `install-wallpaper-changer` for the current user. This program installs a *user specific* systemd service `wallpaper-changer`.

## Configuration

File `/etc/wallpaper-changer.conf` contains available configurations like folders and time period as mentioned above.<br>
This file includes documentation about the configuration in comments.
