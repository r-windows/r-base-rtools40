#!/bin/bash

# adamleerich
# 2021-08-16
#
# Return the location of pdflatex if on the path OR if MiKTeX is installed
# Works on MSYS2/Windows only!
#
# TODO could probably extend this to work for TeXLive, too
# TODO what if the user has build pdflatex locally as part of MSYS2?
#


# Check for pdflatex in PATH, then look for registry keys
# that MiKTeX uses to store the install directory

PDFLATEX=$(which 'pdflatex' 2> /dev/null)
if [ -n "$PDFLATEX" ]
then
  echo $(dirname "$PDFLATEX")
  exit 0
fi


# Check the registry to see where MiKTeX is installed
# Location of the registry keys (as of 2021-08-16)
REG_ONE=/proc/registry/HKEY_CURRENT_USER/Software/MiKTeX.org/MiKTeX/*/Core/UserInstall
REG_ALL=/proc/registry/HKEY_LOCAL_MACHINE/SOFTWARE/MiKTeX.org/MiKTeX/*/Core/CommonInstall


# MiKTeX recommends a single-user install, so check that first
KEYFILE=$(dir $REG_ONE 2>/dev/null | sort -r | head -1)
if [ -z "$KEYFILE" ]
then
  KEYFILE=$(dir $REG_ALL 2>/dev/null | sort -r | head -1)
fi


if [ -z "$KEYFILE" ]
then
  echo "ERROR: Cannot find MiKTeX on the PATH or in Windows Registry" > /dev/stderr
  exit 1
fi



# The contents of $KEYFILE may contain a terminating nul string,
# so we use `sed` to remove it.  Otherwise, we get a
# "warning: command substitution: ignored null byte in input"
#
# FYI use `cat -vET $KEYFILE` to see nul strings as "^@"
#
WINPATH=$(cat "$KEYFILE" | sed 's|\x0$||')
CYGPATH=$(cygpath "$WINPATH")
PDFLATEX=$(find "$CYGPATH" -type f 2> /dev/null | grep "/pdflatex[.]exe")

if [ -z "$PDFLATEX" ]
then
  echo "ERROR: pdflatex not found in registered location" > /dev/stderr
  exit 1
fi


echo $(dirname "$PDFLATEX")
exit 0

