#!/bin/bash

set -eu

BASE=~/.rakudobrew
mkdir -p $BASE
git clone git://github.com/tadzik/rakudobrew.git $BASE
perl $BASE/bin/rakudobrew build moar
