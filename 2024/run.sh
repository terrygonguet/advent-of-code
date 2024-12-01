#!/bin/bash

odin build $1 -debug -out=./bin
./bin <&0 1>&1 2>&1