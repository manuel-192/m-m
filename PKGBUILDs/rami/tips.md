## Tips for `rami`

`rami` is a program for ranking Arch mirrors.<br>
This document describes only options considered most useful in normal usage.

By default `rami` will rank all known Arch mirrors in the world.
User can select which mirrors to include or exclude which saves both time and network resources.

If option `--save` is not given, `rami` will simply show the ranking result on the terminal.

## Configuration files

File | Description
:--- | :---
`/etc/skel/rami.conf` | Template file when creating a new user.
`~/.config/rami.conf` | Actual configuration file for a user.

A configuration file uses `bash` syntax containing one array variable `CONFIG_OPTIONS` that may include
any number of `rami` options.<br>
Each mirror name in a `<list>` (see below) needs to be a part of the mirror name but also
unique to separate it from other mirror names.<br>
A mirror can be from any country, even if the country is not explicitly set to be included.

Example of `~/.config/rami.conf`:

```

CONFIG_OPTIONS=(
    --ranking-data
    --country DE,FR,GB
    # --ignore-mirrors name1,name2,name3
    --favorite DE:thaller,GB:london,SE:accum    # 'accum' can be a favorite too
)
```

### Main options

Option | Description
:--- | :---
`--save` | Save the generated mirrorlist to `/etc/pacman.d/mirrorlist`.
`--help` | Gives more details about available `rami` options.
`--ranking-data` | Include the ranking data in the mirrorlist.
`--timeout-rank` | Max time in seconds to rank a mirror. Default: 20.

### Selecting mirrors to rank

These options will limit the amount of mirrors to be included in ranking.

Option | Description
:--- | :---
`--country <list>` | Rank mirrors only from the given countries.
`--ignore-countries <list>` | Exclude mirrors of given countries.
`--ignore-mirrors <list>` | Exclude given mirrors. A given mirror can be a partial, unique name of the mirror.
`--continent-given <continent-code>` | Rank mirrors of the given continent.<br>See also options `--continent` and `--list-continent-codes`.
`--continent` | Rank mirrors of the current continent.
`--ignore-continents <list>` | Exclude mirrors of given continents.

### Informative options

Option | Description
:--- | :---
`--list-country-codes-names` | Shows a list of country codes and names.
`--list-continent-codes` | Shows a list of continent codes.
`--list-continents-countries` | Shows country names along with their country and continent codes.

### Misc options

Option | Description
:--- | :---
`--favorite <list>` | Favorite mirrors, will be listed before the ranked mirrors in the mirrorlist.<br>Note that the country code prefix is required. Example: `GB:london`
`--max <number>` | Limit the amount of shown mirrors to the given number.

### About the parameters above

Parameter | Description
:--- | :---
`<list>` | A comma separated list of items. Values are specific to the option.<br>Example: `rami --country DE,FR,GB`
`<continent-code>` | A two letter code referring to a continent, one of: AF AN AS EU NA OC SA.<br>Get a list of country codes with their continent codes:<br>`location list-countries --show-continent`
`<number>` | A non-negative integer.
