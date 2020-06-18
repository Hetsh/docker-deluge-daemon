FROM library/debian:stable-20200607-slim
RUN DEBIAN_FRONTEND="noninteractive" && \
    apt-get update && \
    apt-get install --assume-yes \
        deluged=1.3.15-2

# App user
ARG APP_USER="deluge"
ARG APP_UID=1364
ARG HOME_DIR="/var/lib/deluged"
RUN useradd --uid "$APP_UID" --no-create-home --home "$HOME_DIR" --user-group --shell /sbin/nologin "$APP_USER"

# Volumes
ARG CONF_DIR="$HOME_DIR/config"
ARG DATA_DIR="$HOME_DIR/data"
RUN mkdir "$DATA_DIR" && \
    chown -R "$APP_USER":"$APP_USER" "$HOME_DIR"
VOLUME ["$CONF_DIR", "$DATA_DIR"]

# Configuration
RUN echo '{\
  "file": 1, \
  "format": 1\
}{\
  "info_sent": 0.0, \
  "lsd": true, \
  "max_download_speed": -1.0, \
  "send_info": false, \
  "natpmp": true, \
  "move_completed_path": "$HOME_DIR/Downloads", \
  "peer_tos": "0x00", \
  "enc_in_policy": 1, \
  "queue_new_to_top": false, \
  "ignore_limits_on_local_network": true, \
  "rate_limit_ip_overhead": true, \
  "daemon_port": 58846, \
  "torrentfiles_location": "$HOME_DIR/Downloads", \
  "max_active_limit": -1, \
  "geoip_db_location": "/usr/share/GeoIP/GeoIP.dat", \
  "upnp": true, \
  "utpex": true, \
  "max_active_downloading": 1, \
  "max_active_seeding": -1, \
  "allow_remote": true, \
  "outgoing_ports": [\
    0, \
    0\
  ], \
  "enabled_plugins": [], \
  "max_half_open_connections": 50, \
  "download_location": "$HOME_DIR/Downloads", \
  "compact_allocation": false, \
  "max_upload_speed": -1.0, \
  "plugins_location": "$HOME_DIR/config/plugins", \
  "max_connections_global": 200, \
  "enc_prefer_rc4": true, \
  "cache_expiry": 60, \
  "dht": true, \
  "stop_seed_at_ratio": false, \
  "stop_seed_ratio": 2.0, \
  "max_download_speed_per_torrent": -1, \
  "prioritize_first_last_pieces": false, \
  "max_upload_speed_per_torrent": -1, \
  "auto_managed": true, \
  "enc_level": 2, \
  "copy_torrent_file": false, \
  "max_connections_per_second": 20, \
  "listen_ports": [\
    6881, \
    6891\
  ], \
  "max_connections_per_torrent": -1, \
  "del_copy_torrent_file": false, \
  "move_completed": false, \
  "autoadd_enable": true, \
  "proxies": {\
    "peer": {\
      "username": "", \
      "password": "", \
      "hostname": "", \
      "type": 0, \
      "port": 8080\
    }, \
    "web_seed": {\
      "username": "", \
      "password": "", \
      "hostname": "", \
      "type": 0, \
      "port": 8080\
    }, \
    "tracker": {\
      "username": "", \
      "password": "", \
      "hostname": "", \
      "type": 0, \
      "port": 8080\
    }, \
    "dht": {\
      "username": "", \
      "password": "", \
      "hostname": "", \
      "type": 0, \
      "port": 8080\
    }\
  }, \
  "dont_count_slow_torrents": true, \
  "add_paused": false, \
  "random_outgoing_ports": true, \
  "max_upload_slots_per_torrent": -1, \
  "new_release_check": false, \
  "enc_out_policy": 1, \
  "seed_time_ratio_limit": -1, \
  "remove_seed_at_ratio": false, \
  "autoadd_location": "$HOME_DIR/Downloads", \
  "max_upload_slots_global": -1, \
  "seed_time_limit": 180, \
  "cache_size": 512, \
  "share_ratio_limit": -1, \
  "random_port": true, \
  "listen_interface": ""\
}' > "$CONF_DIR/core.conf"

#      CONTROL   TRAFFIC TCP     TRAFFIC UDP
EXPOSE 58846/tcp
#EXPOSE 58846/tcp 56881:56889/tcp 56881:56889/udp

USER "$APP_USER"
WORKDIR "$HOME_DIR"
ENV CONF_DIR="$CONF_DIR"
ENTRYPOINT exec deluged --do-not-daemonize --config "$CONF_DIR"