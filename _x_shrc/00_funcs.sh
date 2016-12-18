#!/bin/sh

set -e

command_exists () {
  command -v "$1" >/dev/null 2>&1 ;
}
