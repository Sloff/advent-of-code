#! /bin/bash

perl -lanE 'BEGIN { $, = " " }; my @nF = reverse @F; say @nF' input.txt | perl part1.pl
