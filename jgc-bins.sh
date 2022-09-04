#!/bin/bash

COIN_NAME='jagoancoin'
COIN_DAEMON='jagoancoind'
COIN_CLI='jagoancoin-cli'
COIN_TX='jagoancoin-tx'
COIN_PATH='/usr/local/bin'
WALLET_TAR=$(curl -s https://api.github.com/repos/jagoanpilot/jagoancoin/releases/latest | jq -r '.assets[] | select(.name|test("ubuntu18.")) | .browser_download_url')

# fetch latest release using github api
if pgrep $COIN_DAEMON; then
  $COIN_CLI stop
  mkdir temp
  curl -L $WALLET_TAR | tar xz -C ./temp; mv ./temp/$COIN_DAEMON ./temp/$COIN_CLI ./temp/$COIN_TX $COIN_PATH
  $COIN_DAEMON
else
  mkdir temp
  curl -L $WALLET_TAR | tar xz -C ./temp; mv ./temp/$COIN_DAEMON ./temp/$COIN_CLI ./temp/$COIN_TX $COIN_PATH
  rm -rf temp
fi
 