#! /bin/bash

perl -lane 'print ((join "?", ($F[0])x5) . " " . (join ",", ($F[1])x5))' input.txt | perl part2.pl
