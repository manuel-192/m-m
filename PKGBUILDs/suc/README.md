# suc
Command 'suc' is about the same as command 'su -c'.

The main difference is that 'suc' understands spaces in command parameters
in bash scripts.

Example: assume
- you are a non-privileged user, no root and not even a sudoer
- you have files containing spaces in their names, like "foo bar" and "foo baz"

and you wish to list files starting with 'foo'. As a non-privilegeed user you can run e.g.
<pre>
    ls -l foo*
</pre>
and it shows the files properly.

But if you wish to run the same command with elevated privileges, you cannot use sudo (as you are not a sudoer), and even pkexec does not work (because it doesn't find the files!). Try them!
<pre>
    sudo ls -l foo*        # fails!
    pkexec ls -l foo*      # fails!
</pre>
Note that command
<pre>
    su -c "ls -l foo*"
</pre>
works. And so does
<pre>
    suc ls -l foo*
</pre>
Then you wish to write a bash script that does the same thing. Like
<pre>
    # Contents of script1:
    su -c "$@"
</pre>
and run:
<pre>
    bash script1 ls -l foo*
</pre>
but it fails!

With the 'suc' command you can write the script like this:
<pre>
    # Contents of script2:
    suc "$@"
</pre>
and
<pre>
    bash script2 ls -l foo*
</pre>
works as expected.
