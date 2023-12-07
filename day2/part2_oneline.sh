#! /bin/bash

perl -MList::Util=max -lne '$sum += (max (m/(\d+) red/g) * max (m/(\d+) green/g) * max (m/(\d+) blue/g)); END { print $sum }' input.txt
