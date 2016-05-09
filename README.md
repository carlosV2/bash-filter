bash-filter
===========

This script provides the missing filter functionality for bash pipes.

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

Once you have installed this script, you have the function `filter` available to be used as a **pipe**.
This function reads the standard input line by line and applies the specified filters to it. The output
will be all those lines that match the given filters.

Filters are defined as regular parameter string. For example, the string `abc` would match any text that
contains `abc`. They are also case insensitive so `abc`, `Abc`, `aBc`, `ABC`, etc match among them.

There are also metacharacters to modify the behaviour of each filter:
- **+filter**: The `+` metacharacter states that `filter` must be contained for the line to match it.
- **-filter**: The `-` metacharacter states that `filter` must not be contained for the line to match it.
- **=filter**: The `=` metacharacter states that `filter` must be a word for the line to match it (i.e.
surrounded by spaces)

Metacharacters can be stacked together having in mind that `=` metacharacter needs to precede the others.
For example, the filter `=-word` would match any line without `word` but `-=word` would much any line that
does not contain `=word`.

By default, if no `+` or `-` metacharacter is provided, the `+` metacharacter is applied automatically.

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

Examples
========

Imagine we have the following file:
```
$ cat bestsellers.txt
Book - Author
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
```

We can filter the books that contain "the" in the name:
```
$ cat bestsellers.txt | filter the
Fantastic Beasts and Where to Find Them - J. K. Rowling
Harry Potter and the Cursed Child - J. K. Rowling
The Girl on the Train - Paula Hawkins
The Reader on the 6.27 - Jean-Paul Didierlaurent
The Girl of Ink & Stars - Kiran Millwood-Hargrave
The World's Worst Children - David Walliams
The Road to Little Dribbling - Bill Bryson

Found 7 of 10 (0 blank lines)
```

This filter is matching "them" too but we only want to match the word "the":
```
$ cat bestsellers.txt | filter =the
Harry Potter and the Cursed Child - J. K. Rowling
The Girl on the Train - Paula Hawkins
The Reader on the 6.27 - Jean-Paul Didierlaurent
The Girl of Ink & Stars - Kiran Millwood-Hargrave
The World's Worst Children - David Walliams
The Road to Little Dribbling - Bill Bryson

Found 6 of 10 (0 blank lines)
```

Finally, if we don't want to match any book from J. K. Rowling, we can use:
```
$ cat bestsellers.txt | filter =the -rowling
The Girl on the Train - Paula Hawkins
The Reader on the 6.27 - Jean-Paul Didierlaurent
The Girl of Ink & Stars - Kiran Millwood-Hargrave
The World's Worst Children - David Walliams
The Road to Little Dribbling - Bill Bryson

Found 5 of 10 (0 blank lines)
```

You can use `filter` in combination with any other command that writes to the standard
output: `cat`, `find`, `apt-get`, etc  