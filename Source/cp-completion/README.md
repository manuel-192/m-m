# cp-completion
The cp.completion file provides a bash completion for the 'cp' command.<br>
It handles more options and their values than the 'official' cp completion.<br>
Copy this file into <b>/usr/share/bash-completion/completions/cp</b>.<br><br>
Note: in file <b>/usr/share/bash-completion/bash_completion</b> the list of commands using the \_longopt function includes
the 'cp' command (currently it is at line number 1886). The 'cp' word should be removed from the list in order to use this new cp completion.<br>
The following command does that:
<pre>
sudo sed -i 's|^\(complete -F _longopt .*\) cp \(.*\)$|\1 \2|' /usr/share/bash-completion/bash_completion
</pre>
