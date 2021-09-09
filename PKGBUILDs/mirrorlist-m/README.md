# mirrorlist-m

Installs file /etc/pacman.d/mirrorlist-m that contains
repository definitions for packages in
- https://github.com/manuel-192/m-more2
- https://github.com/manuel-192/m-aur
- https://github.com/manuel-192/m-m

You may add a references to this file in the end of your /etc/pacman.conf, e.g.:
<pre>
[m-m]
Include = /etc/pacman.d/mirrorlist-m
SigLevel = Required

[m-aur]
Include = /etc/pacman.d/mirrorlist-m
SigLevel = Required

[m-more2]
Include = /etc/pacman.d/mirrorlist-m
SigLevel = Required
</pre>
