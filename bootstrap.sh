#!/bin/bash

DIR='/jagoancoin/.jagoancoincore'
BOOTSTRAP_TAR='https://bootstrap.jagoancoin.org/bootstrap_with_indexes.tar.xz'

if [ ! -d $DIR ]; then
  mkdir -p $DIR
  curl -L $BOOTSTRAP_TAR | tar xJ -C $DIR
else
  echo "Datadir has been detected so bootstrap will not be used..."
fi
