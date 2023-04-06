# local-repo-manager

## Overview
To be written.

## Options

To be written.

## Configuration file

Configuration file is `/etc/local-repo-manager.conf`.<br>
Below there's an artificial example with one (fake) AUR package **my-test-git** and a helper function that changes the value of `pkgrel` in the PKGBUILD file.

### Names of AUR packages for the local repo

First you need to specify the names of AUR packages for the local repository. The names will be given in a bash variable PKGNAMES (it is a simple array of package names):

```
PKGNAMES=(
    ## Add names of AUR packages here.
    my-test-git                            # a non-existing example!
)
```

### Setting up other information

The following bash variables are supported as "settings" for `local-repo-manager`. Some of them are mandatory while others are optional.<br>The initial value for them is `""` (an empty string). Mandatory variables will need a value with a non-empty string.

Variable | Initial value | Mandatory? | Description
:---            | :--- | :---      | :---
WORKDIR         | `""` | yes | Working directory, built packages will be stored here.
REPONAME        | `""` | yes | Name of the local repository to be used in /etc/pacman.conf.
SIGNER          | `""` | no  | Package signer gpg name; if empty, packages will not be signed.
PACKAGED_BY     | `""` | no  | The person (gpg) who built the package(s).
VERSION_COMPAT  | `""` | no  | Compatibility version of the configuration file. If not set, version 0 is assumed.

### Customizing the build (build modifiers)

If changes are needed *before* or *after* building the package (with makepkg), you need to
write a function for each package that requires modifications.<br>We call this function a *build modifier*.<br>
A *build modifier* will be executed in the folder where file PKGBUILD (for the package) exists.

The function name MUST be formatted as follows:
```
   _packagename_
```
i.e. a package name (in PKGNAMES) surrounded by one leading and one trailing underscore.

Typical changes *before* makepkg can be related to modifying the PKGBUILD contents for particular reasons.<br>
Typical changes *after* makepkg can be e.g. cleaning up leftovers of the PKGBUILD.

When implementing a *build modifier* for a package, the following helper functions can be used:

Function | Description
:--- | :---
   FuncnameToPkgname          | Extracts the package name from the given function name.
   Add_BeforeAfter_func       | Adds a function name to the database of the caller.
   GetPkgbuildValue           | Finds the value of the given variable in the PKGBUILD file.
   PutPkgbuildValue           | Changes the value of a given variable in PKGBUILD.
   Pushd                      | Same as `pushd`, but standard output is redirected to /dev/null.
   Popd                       | Same as `popd`, but standard output is redirected to /dev/null.
   echo2                      | Same as `echo`, but output is redirected to standard error.
   printf2                    | Same as `printf`, but output is redirected to standard error.
   INFO                       | Prints the given info message with `echo2`.
   DIE                        | Prints the given error message with `echo2` (and also to a log file) and exits with code 1.<br>The log file is `$HOME/.cache/local-repo-manager.errlog`.

The build log file is `$HOME/.cache/local-repo-manager.buildlog`.


The *build modifier* will be called with one parameter, a string with word: `before` or `after`.<br>
Thus it should implement a `case...esac` construct with the following patterns:

Pattern | Description
:--- | :---
`before` | The commands will be executed *before* `makepkg` in the folder where file PKGBUILD exists.
`after`  | The commands will be executed *after*  `makepkg` in the folder where file PKGBUILD exists.

#### Example:

```
_my-test-git_() {
    case "$1" in
        before)
                 local PKGNAME=$(FuncnameToPkgname "$FUNCNAME")      # get the package name from the current function name
                 local PKGREL=""                                     # this example will change the 'pkgrel' value

                 GetPkgbuildValue pkgrel PKGREL                      # get the value of 'pkgrel' from PKGBUILD into PKGREL
                 ((PKGREL++))                                        # value changes

                 PutPkgbuildValue pkgrel "$PKGREL"                   # write the changed value to 'pkgrel' in PKGBUILD
                 # sed -i PKGBUILD -e "s|^pkgrel=.*|pkgrel=$PKGREL|" # sed alternative to the call of PutPkgbuildValue
                 ;;

         after)
                 rm -f *.{xml,tar}.gz                                # cleanup
                 ;;
     esac
}

Add_BeforeAfter_func _my-test-git_                                    # to use the new function, add it to the database

```
