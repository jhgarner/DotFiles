#! /usr/bin/env bash

if setxkbmap -print | grep "3l"; then
  setxkbmap us
else
  setxkbmap us 3l
fi
