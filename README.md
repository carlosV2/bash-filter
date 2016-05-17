bash-filter
===========

This script provides the missing filter functionality for bash.

Installation
============

Checkout the source code:
```
$ cd ~
$ git clone https://github.com/carlosV2/bash-filter.git .bash-filter
```

Link it to your bash profile file:
```
$ echo "source $(pwd)/.bash-filter/filter.sh" >> ~/.bash_profile
```

Usage
=====

Once you have installed this script, you then have the function `filter` available to be used as a **pipe**.
This function reads the standard input line by line and applies the specified filters to it. The output
will be all those lines that match the given filters.

Filters are defined as regular parameter strings. For example, the string `foo` would match any text that
contains `foo`. They are also case insensitive so `foo`, `Foo`, `fOo`, `FOO`, etc match among them.

This command appends some stats at the end. Those stats contains:
- The number of matching lines
- The total number of lines
- The number of (skipped) blank lines

If you don't want those stats to be appended you can set the `$FILTER_STATS` variable to `false`:
```
$ export FILTER_STATS=false
```

In case you want the stats but you don't want to color them you can set the `$FILTER_COLORS` variable to `false`:
```
$ export FILTER_COLORS=false
```

You can also make these variable persistent by writing them into your bash profile:
```
$ echo "export FILTER_STATS=false" >> ~/.bash_profile
$ echo "export FILTER_COLORS=false" >> ~/.bash_profile
```


+ metacharacter:
----------------

The plus (+) metacharacter states that the given filter **must be** contained in the line to match it.

For example, the filter `+foo` will match a line if there is any occurrence of `foo` in it.


- metacharacter:
----------------

The minus (-) metacharacter states that the given filter **must not be** contained in the line to match it.

For example, the filter `-foo` will match a line if there are not occurrences of `foo` in it.


~ metacharacter:
----------------

The tilde (~) metacharacter states that the given filter should be searched as itself and any morphologic
derivative of it.

For example, the filter `~foo` will be searching for occurrences of `foo` and `foos`.

Note: Currently, this functionality is limited to the English language and singular/plural words. It is also
recommended to input the word in the singular form for a better performance. However, plural words may also
work. If you find an issue with this functionality, please, don't hesitate to open an issue.


= metacharacter:
----------------

The equals (=) metacharacter states that the given filter should be searched as a standalone word to match it.

For example, the filter `=foo` will match a line only if `foo` is it preceded and followed by spaces.


Combining metacharacters:
-------------------------

Metacharacters can be combined to form more accurate filters.
However, the combination order must be as follows:

1. =
2. ~
3. +/-

Examples:
- `=-foo`: Will match a line if `foo` is not contained in as a standalone word (it might be contained as part of
bigger words, though).
- `=~foo`: Will match a line if either `foo` or `foos` are contained as words.
- `~-foo`: Will match a line if neither `foo` or `foos` are contained in it. 
- `+~foo`: Because the combination order is broken, this filter will match a line if it contains `~foo` in it (being
`~` a regular character and not a metacharacter) 

By default, if no `+` or `-` metacharacter is provided, the `+` metacharacter is applied automatically.


Examples
========

Imagine we have the following file:
```
$ cat bestsellers.txt
Fantastic Beasts and Where to Find Them - J. K. Rowling
Harry Potter and the Cursed Child - J. K. Rowling
The Girl on the Train - Paula Hawkins
Night School - Lee Child
The Reader on the 6.27 - Jean-Paul Didierlaurent
The Girl of Ink & Stars - Kiran Millwood-Hargrave
The World's Worst Children - David Walliams
The Road to Little Dribbling - Bill Bryson
Career of Evil - Robert Galbraith
Hitman Anders and the Meaning of it All - Jonas Jonasson
Lost Girls - Angela Marsons
```

We can filter the books that contain `the`:
```
$ cat bestsellers.txt | filter the
Fantastic Beasts and Where to Find Them - J. K. Rowling
Harry Potter and the Cursed Child - J. K. Rowling
The Girl on the Train - Paula Hawkins
The Reader on the 6.27 - Jean-Paul Didierlaurent
The Girl of Ink & Stars - Kiran Millwood-Hargrave
The World's Worst Children - David Walliams
The Road to Little Dribbling - Bill Bryson
Hitman Anders and the Meaning of it All - Jonas Jonasson

Found 8 of 11 (0 blank lines)
```

Alternatively, the `+` metacharacter can be applied with the same result:
```
$ cat bestsellers.txt | filter +the
```

This filter is matching `them` too but we only want to match the word `the`:
```
$ cat bestsellers.txt | filter =the
Harry Potter and the Cursed Child - J. K. Rowling
The Girl on the Train - Paula Hawkins
The Reader on the 6.27 - Jean-Paul Didierlaurent
The Girl of Ink & Stars - Kiran Millwood-Hargrave
The World's Worst Children - David Walliams
The Road to Little Dribbling - Bill Bryson
Hitman Anders and the Meaning of it All - Jonas Jonasson

Found 7 of 11 (0 blank lines)
```

If we don't want to match any book from J. K. Rowling, we can use:
```
$ cat bestsellers.txt | filter =the -rowling
The Girl on the Train - Paula Hawkins
The Reader on the 6.27 - Jean-Paul Didierlaurent
The Girl of Ink & Stars - Kiran Millwood-Hargrave
The World's Worst Children - David Walliams
The Road to Little Dribbling - Bill Bryson
Hitman Anders and the Meaning of it All - Jonas Jonasson

Found 6 of 11 (0 blank lines)
```

Finally, if we want to match any book about girls, we can use:
```
$ cat bestsellers.txt | filter ~girl
The Girl on the Train - Paula Hawkins
The Girl of Ink & Stars - Kiran Millwood-Hargrave
Lost Girls - Angela Marsons

Found 3 of 11 (0 blank lines)
```