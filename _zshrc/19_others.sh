#!/bin/sh

# 補完時に濁点・半濁点を <3099> <309a> のように表示させない
setopt combining_chars

# curl で no matches found と怒られるのを防ぐ
# alias curl='noglob curl'
