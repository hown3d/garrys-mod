FROM cm2network/steamcmd:root
ENV STEAMAPPID=4020


WORKDIR /gmod

RUN apt-get update && apt-get install -y tmux curl && \
  chown -R steam:steam /gmod

USER steam

RUN bash "/home/steam/steamcmd/steamcmd.sh" \
	+force_install_dir "/gmod" \
  +login anonymous \
	+app_update "${STEAMAPPID}" validate \
	+quit

ENV SRCDS_PORT=27015 \
  SRCDS_MAP=gm_construct \
  SRCDS_MAX_PLAYERS=16 \
  SRCDS_GAMEMODE=terrortown

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]