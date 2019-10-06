# eat
Helper for sending e.g. logs to the Internet.

Some highlights:
- automatically hides certain user specific information ($LOGNAME, $USER, $HOSTNAME) before sending to the internet
- information about each send is automatically saved to your $HOME folder for later inspection

## Usage
eat -help
## Examples
Combine many different outputs into one and send it to pastebin:
<pre>
journalctl -b -0 | eat
lspci -vnn | eat
cat /var/log/Xorg.0.log | eat -send "various logs from my machine"
</pre>
