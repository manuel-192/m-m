# remirror-arch
Generate a mirrorlist for Arch mirrors and
show it on the screen (default) or save it
to /etc/pacman.d/mirrorlist with option -s.

## Usage
To get help, use command
<pre>
remirror-arch --help
</pre>

## Notes
- Configuration file <b>/etc/remirror-arch.conf</b> may contain remirror-arch options.
- Option -c supports both country codes (like DE) and country names (like Germany).
- Option -l lists supported country codes and names.
