#!/bin/sh

set -e

echo "deploying .atom ..."

cd $DOTPATH


ATOM_HOME=~/.atom

if [ -e $ATOM_HOME ] ; then
  ln -snfv ${DOTPATH}/_atom/config.cson   $ATOM_HOME
  ln -snfv ${DOTPATH}/_atom/init.coffee   $ATOM_HOME
  ln -snfv ${DOTPATH}/_atom/keymap.cson   $ATOM_HOME
  ln -snfv ${DOTPATH}/_atom/snippets.cson $ATOM_HOME
  ln -snfv ${DOTPATH}/_atom/styles.less   $ATOM_HOME
fi
