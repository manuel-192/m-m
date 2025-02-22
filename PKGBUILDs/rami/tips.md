## Tips for `rami`

`rami` is a command line program for ranking Arch mirrors.

`rami-fzf` is another program which makes usage of `rami` very simple:
it lets the user select which main features to use with a very small number of questions.
`rami-fzf` also tips you about `rami` options to use if it finds anything that might help creating
the actual mirrorlist file.

This document describes only options of `rami` considered most useful in normal usage.

By default `rami` will rank all known Arch mirrors in the world and show the result on the terminal.<br>
Note that the mirrorlist will *not* be saved by default, you need to apply option `--save` for that.<br>
User can use various options to include or exclude mirrors which saves both time and network resources.

Bash command completion (use the **Tab** key) works as expected, helping to write options and their parameters.

### Configuration files

File | Description
:--- | :---
`/etc/skel/rami.conf` | Template file for creating a new user.
`~/.config/rami.conf` | Actual configuration file of a user.

A configuration file uses `bash` syntax. An array variable `CONFIG_OPTIONS` may include
any number of `rami` options. A configuration file is *not required*, but may be helpful.<br>
Each mirror name in a `<list>` (see below) needs to be a part of the mirror name but also
unique to separate it from other mirror names.<br>
A mirror can be from any country, even if the country is not explicitly included.

Example of `~/.config/rami.conf` (see below for more details):

```
CONFIG_OPTIONS=(
    --ranking-data
    --country DE,FR,GB                     # use country codes instead of names!
    # --ignore-mirrors name1,name2,name3
    --favorite DE:thaller,SE:accum         # 'accum' (not in DE,FR,GB) can be used too
)
```

### Main options

Option | Description
:--- | :---
`--save` | Save the generated mirrorlist to `/etc/pacman.d/mirrorlist`.
`--help` | Gives more details about available `rami` options.
`--ranking-data` | Include the ranking data in the mirrorlist.<br>This data reveals for each mirror when it was updated, and how fast the download occurred.
`--timeout-rank` | Max time in seconds to rank each mirror. Default: 20.

### Informative options

Option | Description
:--- | :---
`--list-continents-countries` | Shows all supported continent codes, country codes, and country names.

### Selecting mirrors to rank

These options will limit the amount of mirrors to be included in ranking.

Option | Description
:--- | :---
`--country <list>` | Rank mirrors only from the listed countries. Use country codes.
`--ignore-countries <list>` | Exclude mirrors of listed countries. Use country codes.
`--ignore-mirrors <list>` | Exclude listed mirrors. A listed mirror must be a unique (even partial) name of the mirror.
`--continent-given <continent-code>` | Rank mirrors of the given continent.<br>See also: option `--list-continents-countries`.
`--continent` | Rank mirrors of the current continent.
`--ignore-continents <list>` | Exclude mirrors of the listed continents.
`--all` | Rank all supported mirrors everywhere.

### Misc options

Option | Description
:--- | :---
`--favorite <list>` | The listed favorite mirrors will be placed before the other ranked mirrors in the mirrorlist.<br>Note that the country code prefix is required. Example: `GB:london`
`--max <number>` | The given value limits the number of mirrors shown. Default: 1000.

### About the parameters above

Parameter | Description
:--- | :---
`<list>` | A comma separated list of items. Values are specific to the option.<br>Example: `rami --country DE,FR,GB`
`<continent-code>` | A two letter code referring to a continent, one of: AF AN AS EU NA OC SA.<br>See also: option `--list-continents-countries`.
`<number>` | A non-negative integer.
