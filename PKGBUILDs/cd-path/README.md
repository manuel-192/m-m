# cd-path

Another enhanced `cd` replacement, implemented as a bash *function*.

Works like traditional builtin `cd`, but enhances the usage of the `CDPATH` variable with ways to *exclude* certain folders found by the `CDPATH` feature.<br>
Otherwise function `cd` supports the same options and features as the builtin `cd` command.

# Synopsis
```
cd [options] folder
```

where
Item | Description
:--- | :---
options | Options for the builtin `cd`.
folder | Folder specification like with the builtin `cd`.

<br>

# Installation and further preparations

After installing package `cd.bash` you need to write the following lines to your `~/.bashrc` (most likely in the end of that file):
```
source $HOME/.config/cd.conf
source /etc/skel/cd.bash
```
and then copy file `/etc/skel/cd.conf` into your `$HOME/.config` folder:
```
cp /etc/skel/cd.conf ~/.config/
```

After the above, modify the configuration file `~/.config/cd.conf` to contain *your* preferred values for variables:

Variable | Description
:--- | :---
CDPATH_ARR | Same as CDPATH but as an array.
CDPATH_EXCLUDE | Similar array but defines (absolute or relative) paths to be excluded.
CDPATH_EXCLUDE_FILES | Names of files that make the folder excluded (example filename: `.no-cd`).
CDOUT | Verbosity option. Supported values: `important` (default), and `all` (for additional debug info).

Note that it is best to select carefully the values of the arrays, otherwise `cd` may not find the folders you are trying to go to or avoid.<br>
See also the examples below.

<br>

## Adding bash completion support (optional)

You can make bash completion for the `cd` command to take folder exclusions into account by
modifying function `_cd()` in file `/usr/share/bash-completion/bash_completion` as follows:

### From (around lines 1829..1838)
```
# we have a CDPATH, so loop on its contents
for i in ${CDPATH//:/$'\n'}; do
    # create an array of matched subdirs
    k="${#COMPREPLY[@]}"
    for j in $(compgen -d -- $i/$cur); do
        if [[ ($mark_symdirs && -L $j || $mark_dirs && ! -L $j) && ! -d ${j#$i/} ]]; then
            j+="/"
        fi
        COMPREPLY[k++]=${j#$i/}
    done
done
```
### to
```
# we have a CDPATH, so loop on its contents
# we also have arrays CDPATH_EXCLUDE and CDPATH_EXCLUDE_FILES, so take them into account too
local exclude xx
for i in ${CDPATH//:/$'\n'}; do
    # create an array of matched subdirs
    k="${#COMPREPLY[@]}"
    for j in $(compgen -d -- $i/$cur); do
        if [ -n "$CDPATH_EXCLUDE" ]; then
            exclude=no
            for xx in "${CDPATH_EXCLUDE[@]}"; do
                if [ "$j" = "$xx" ] || [ "$j" -ef "$i/$xx" ] || [ "$j" -ef "$xx" ]; then
                    exclude=yes
                    break
                fi
            done
            [ "$exclude" = "yes" ] && continue
            for xx in "${CDPATH_EXCLUDE_FILES[@]}"; do
                if [ -r "$j/$xx" ]; then
                    exclude=yes
                    break
                fi
            done
            [ "$exclude" = "yes" ] && continue
        fi
        if [[ ($mark_symdirs && -L $j || $mark_dirs && ! -L $j) && ! -d ${j#$i/} ]]; then
            j+="/"
        fi
        COMPREPLY[k++]=${j#$i/}
    done
done
```

<br>

# Examples of usage

## Basic examples

Command | What happens
:--- | :---
`cd` | Go $HOME
`cd -` | Go the the previous folder.
`cd ..` | Go to the parent folder.

<br>

## Examples assuming configured variables in file<br>`~/.config/cd.conf`

Assume the following folders exist:
```
$HOME/Documents/Work
$HOME/Documents/Family/Maggie
$HOME/Documents/Family/Homer
$HOME/Documents/Family/Children
$HOME/Documents/Family/Children/Lisa/School
$HOME/Documents/Family/Children/Lisa/Private
$HOME/Documents/Family/Children/Bart/School
$HOME/Documents/Family/Children/Bart/Secret
$HOME/Documents/Family/Children/Bart/Foobar
```
and this file exists:
```
$HOME/Documents/Family/Children/Lisa/Private/.no-cd
```

With the following values of variables:

```
CDPATH_ARR=(
    $HOME/Documents
    $HOME/Documents/Family/Maggie
    $HOME/Documents/Family/Homer
    $HOME/Documents/Family/Children/Lisa
    $HOME/Documents/Family/Children/Bart
)
CDPATH_EXCLUDE=(
    $HOME/Documents/Family/Children/Bart/Secret
    $HOME/Documents/Family/Children/Lisa/Private
    Foobar
)
CDPATH_EXCLUDE_FILES=(.no-cd)
CDOUT=important
```

e.g. the following commands could be run:

Command | What happens
:--- | :---
`cd Work` | Go to `$HOME/Documents/Work`
`cd School` | Goes to the first matched folder, and shows information about the other matches.<br>Running the same command again will go to the next match.
`cd Foobar` | Nothing, because excluded by `CDPATH_EXCLUDE` value `Foobar`.<br>A small message will explain the reason.
`cd Private` | Nothing, because excluded by `$CDPATH_EXCLUDE_FILE` in that folder.<br>A small message will explain the reason.
<code>cd Bart <br>cd Foobar</code> | First goes to `Bart`, then to `Foobar` even though Foobar was excluded above!<br>See Note 2 below.

<br>

# Notes

1. To have full bash completion support (press the `tab` key to complete the word) while writing the folder names, add the bash completion support as described above.
2. The `cd` function can go to given (and existing) absolute path even though it is excluded. The same is true for a *direct* relative path.<br>
3. If you have an existing CDPATH value, it will be overwritten by the config file (by default).
4. To make sure all CDPATH related variables get their proper values, it is recommended to re-login into the machine, or simply reboot.<br>The *minimum* is to start a new terminal instance because bash completion may not work with existing terminal instances.