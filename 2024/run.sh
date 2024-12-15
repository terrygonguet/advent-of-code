#!/bin/bash

if [ ! -d "$1" ]; then
	cp -r ./scaffold "$1"
fi

odin build $1 -debug -out=./bin
time ./bin <"$1/$2.txt" 1>&1 2>&1