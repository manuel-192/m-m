# pkexec2
is a <b>pkexec</b> wrapper and is designed to fix the slightly annoying feature of pkexec:
it changes the working directory to /root before executing the command.
Because of that, pkexec is not as easy to use as sudo
since, for example, you have to write the absolute paths of command parameter files and directories yourself.
<br>
<br>
Example: compare the output of the following commands (executed as a non-root user):
<pre>
pkexec pwd
pkexec2 pwd
</pre>
PKGBUILD causes makepkg to install two programs: /usr/bin/pkgexec2 and a helper program /usr/bin/cmdindir.
<br>
<br>
DISCLAIMER: this program has <b>not</b> been extensively tested and may contain (serious) bugs. Use it at your own risk!

