#! /bin/bash

perl -lpe 's/(\w+:)|\s//g;' input.txt | perl part1.pl
