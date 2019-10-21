# yaygg
Yet another yad-based launcher generator. Generates a simple GUI launcher based on the given input definitions.<br>
An example input definition is in the end of the file <b>yaygg</b>.

<H2>Usage</H2>
<pre>
yaygg [options] inputfile
options:
  --out=X     X is the output file (default is standard output)
  --icons=X   X=1: show button icons, X=0: no button icons (default)
  --help|-h   Help stuff
</pre>

<H2>Changes</H2>

0.1.19: 2019-Jan-06
- added support for bash functions
- support for comment lines (lines starting with the '#' character)
- bug fixes

0.1.13: 2018-Mar-20
- support for predefined environment variable $HOME for the input file
- fixed a bug in variable handling

0.1.12: 2018-Mar-16
- support for variables in the input file, see the end of file yaygg for examples

0.1.11: 2018-Mar-16
- supporting more icons automatically

0.1.10: 2018-Mar-16
- gathered possible warning messages into one popup window instead of many popups

0.1.9: 2018-Mar-15
- support for <i>always-on-top</i> window feature, see the end of file yaygg (option <b>on-top</b> in the input file)
- support for option <b>use-icons</b> in the input file (alternative to command line option --icons)

0.1.6: 2018-Mar-14
- automatic support for icons in the buttons, no need to change input file
- support for tooltips on buttons
- modified usage as shown above

Note that icon generation is fairly slow, thus option --icons can be used to enable/disable it.

0.1.5: 2018-Mar-13
- generated programs can now be run to create multiple instances (previously only one instance was possible)

0.1.4: 2018-Mar-13
- modified usage: now title is in the input file, not a parameter (see the end of file yaygg)

0.1.3: 2018-Mar-12
- fixed tab titles if they contain spaces

0.1.2: 2018-Mar-12
- initial release
