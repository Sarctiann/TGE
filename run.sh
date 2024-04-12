#!/bin/bash

eval "$(luarocks path --bin)"
lua src/main.lua
