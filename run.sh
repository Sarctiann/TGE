#!/bin/bash

if [[ $1 != "" ]]; then
	EXE=$1
else
	EXE="main.lua"
fi

eval "$(luarocks path --bin)"
lua "examples/$EXE"
