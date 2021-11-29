#!/bin/bash
set -e

function setup {

if [ -z $RCON_PASS ]; then
  echo "RCON_PASS env Var needs to be set!"
  exit 1
fi

printf "\nrcon_password \"$RCON_PASS\"" >> /gmod/garrysmod/cfg/game.cfg

if test ! -z $SERVER_PASS; then
  printf "\nsv_password \"$SERVER_PASS\"" >> /gmod/garrysmod/cfg/game.cfg
fi

}

function start {

  # Running the program in background and save the pid in child_for_exec
  rm /tmp/log 2>/dev/null || true
  mkfifo /tmp/log
  #screen -LS server /gmod/srcds_run -game garrysmod \
  tmux new -d -s server /gmod/srcds_run -game garrysmod \
  -strictportbind \
  -ip 0.0.0.0 \
  -port $SRCDS_PORT \
  -tickrate 66 \
  +host_workshop_collection $SRCDS_WORKSHOP_COLLECTION \
  +clientport 27005 \
  +tv_port 27020 \
  +gamemode $SRCDS_GAMEMODE \
  +map $SRCDS_MAP \
  +sv_setsteamaccount \
  +servercfgfile game.cfg \
  -maxplayers $SRDCS_MAX_PLAYERS \
  -disableluarefresh \
  +workshop_start_map $SRDCS_WORKSHOP_START_MAP \
  -console \
  -usercon
  tmux pipe-pane -t server -o 'cat > /tmp/log'
  cat /tmp/log
}

setup
start