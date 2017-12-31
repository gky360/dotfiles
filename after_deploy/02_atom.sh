#!/bin/sh

if command_exists apm ; then
  read -p "install atom packages? (Ny) > " yn
  case $yn in
    [Yy]* )
      echo "install atom packages ..."
      apm install --packages-file ${DOTPATH}/_atom/packages-list.txt
      ;;
  esac
fi
