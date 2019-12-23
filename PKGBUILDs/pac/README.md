# pac
Command 'pac' wraps command 'pacman' in order to ask for
elevated permissions only when needed.
So pac can be called without explicit sudo prefix.

Example (note: sudo not used, pac will ask for password):
<pre>
  pac -S firefox
</pre>
Note: pac supports bash completion.
