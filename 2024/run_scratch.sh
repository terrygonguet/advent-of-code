#!/bin/bash

odin build scratchpad -debug -out=./scratchpad/bin
time ./scratchpad/bin 1>&1 2>&1