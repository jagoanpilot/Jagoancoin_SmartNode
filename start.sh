#!/bin/bash

EXECUTABLE='jagoancoind'
DIR='/jagoancoin/.jagoancoincore'
CONF_FILE='jagoancoin.conf'
FILE=$DIR/$CONF_FILE


# Create directory and config file if it does not exist yet
if [ ! -e "$FILE" ]; then
  mkdir -p $DIR
  if [ -n "$BLS_KEY" ]; then
    cat << EOF > $FILE
rpcuser=$(pwgen -1 8 -n)
rpcpassword=$(pwgen -1 20 -n)
rpcallowip=127.0.0.1
rpcbind=127.0.0.1
index=1
txindex=1
addressindex=1
server=1
listen=1
par=2
dbcache=1024
smartnodeblsprivkey=${BLS_KEY}
externalip=${EXTERNALIP}
addnode=explorer.jagoancoin.org
addnode=block.jagoancoin.org
addnode=194.233.175.188
addnode=203.194.112.206
addnode=47.254.192.216
addnode=108.136.131.161
addnode=47.250.38.177
addnode=93.114.133.183
EOF
  else
    cat << EOF > $FILE
rpcuser=$(pwgen -1 8 -n)
rpcpassword=$(pwgen -1 20 -n)
rpcallowip=127.0.0.1
rpcbind=127.0.0.1
server=1
listen=1
addnode=explorer.jagoancoin.org
addnode=block.jagoancoin.org
addnode=194.233.175.188
addnode=203.194.112.206
addnode=47.254.192.216
addnode=108.136.131.161
addnode=47.250.38.177
addnode=93.114.133.183
EOF
  fi
fi

# Create script for HEALTHCHECK
if [ ! -e /usr/local/bin/healthcheck.sh ]; then
  touch healthcheck.sh
  cat << EOF > healthcheck.sh
#!/bin/bash

POSE_SCORE=\$(curl -s "https://explorer.jagoancoin.org/api/protx?command=info&protxhash=${PROTX_HASH}" | jq -r '.state.PoSePenalty')
if ((POSE_SCORE>0)); then
  kill -15 -1
  sleep 15
  kill -9 -1
else
  echo "Smartnode seems to be healthy..."
fi
EOF
  chmod 755 healthcheck.sh
  mv healthcheck.sh /usr/local/bin
fi

exec $EXECUTABLE -datadir=$DIR -conf=$FILE
