#!/bin/bash

set -eu

BASE=~/.rakudobrew
if [[ ! -d $BASE ]]; then
  mkdir -p $BASE
fi

if [[ ! -d $BASE/.git ]]; then
  git clone git://github.com/tadzik/rakudobrew.git $BASE
fi

cd $BASE
git pull origin master

for file in bin/*; do
  if [[ $file =~ rakudobrew ]]; then
    true
  else
    rm -f $file
  fi
done

if [[ -d moar-nom ]]; then
  ( cd moar-nom && git clean -xfd )
fi

rm -f CURRENT

perl bin/rakudobrew build moar
if [[ ! -d moar-nom/panda ]]; then perl bin/rakudobrew build-panda; fi
export PATH=$BASE/moar-nom/install/share/perl6/site/bin:$BASE/moar-nom/install/bin:$PATH
curl -sSkL https://raw.githubusercontent.com/perl6-users-jp/perl6-examples/master/bin/perl6-precompile-all | perl -
