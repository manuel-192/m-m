# eos-r8168-helper

Helps finding the correct Ethernet driver for r8168.<br>
Uses a database of recommended (known-to-work) drivers; information is provided by the distribution users.

Users who have **r8168** Ethernet card hardware are urged to run this program in order to help the development of the installer of this distribution. See **How to contribute** below.

## Usage

```
eos-r8168-helper [options]
```

Option | Description
:--- | :---
`--save`<br>`-s` | Stores information about your Ethernet card and *working* driver<br> into a local database.
`--display`<br>`-d` | Display the known working driver name from the local database.<br>This is the default if options are not given.
`--sendlog` | Send the local database to internet using eos-sendlog.
`--help`<br>`-h` | Show this help and exit.

If a recommended driver is *not* available in the database, an error message will be shown.

Note that it is of great help to deliver *your* database information to the devs of this distribution.

## How to contribute

Users who wish to provide information about their Ethernet cards should
- Make sure your system has a **r8168** ethernet card.
- Make sure your system with ethernet (wired) connection is *working without issues*.
- Run the two commands below.
- Provide the returned URL address to the devs of this distribution.


Run these commands to help the distribution development:

1. Store your current and *working* driver in the local database.
2. Send your database to internet, and deliver the returned URL to the EndeavourOS devs<br>(via forum or github).

```
eos-r8168-helper --save
eos-r8168-helper --sendlog
```
