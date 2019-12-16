# pacmanwrapper
Command 'pacmanwrapper' wraps command 'pacman' in order to ask for elevated permissions only when needed.
So pacmanwrapper can be called without explicit sudo prefix.

Example (note: sudo not used, pacmanwrapper will ask for password):
<pre>
pacmanwrapper -S firefox
</pre>
