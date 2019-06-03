#! /bin/bash

function showcode() {
  filetype=$1
  file=$2
  which highlight > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    highlight -O ansi --syntax $filetype $file
  else
    cat $2
  fi
}

function comment() {
  comment=$1
  echo -e "\e[36m# $comment\e[39m"
}

function simple_comment() {
  comment=$1
  comment "$comment"
  read -p ""
}

function cmd() {
  comment=$1
  cmd=$2
  comment "$comment"
  echo -n -e "\e[93m\$ \e[95m$cmd \e[39m"
  read -p ""
  eval "$cmd"
  echo -e "\e[93mDone\e[39m"
  read -p ""
}
