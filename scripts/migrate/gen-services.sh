#!/usr/bin/env bash
set -euo pipefail

INIT=${1:-}
USER=${2:-john}

if [ -z "$INIT" ]; then
  echo "Usage: $0 <systemd|runit|openrc|s6> [user]" >&2
  exit 1
fi

case "$INIT" in
  systemd)
    mkdir -p "/home/${USER}/.config/systemd/user"

    cat > "/home/${USER}/.config/systemd/user/pcloud-bisync.service" << 'EOM1'
[Unit]
Description=rclone bisync pCloud <-> ~/pCloud
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/pcloud-bisync
EOM1

    cat > "/home/${USER}/.config/systemd/user/pcloud-bisync.timer" << 'EOM2'
[Unit]
Description=Timer: rclone bisync pCloud every 2 hours

[Timer]
OnBootSec=10m
OnUnitActiveSec=2h
RandomizedDelaySec=5m
Persistent=true

[Install]
WantedBy=timers.target
EOM2

    cat > "/home/${USER}/.config/systemd/user/syncthing.service" << 'EOM3'
[Unit]
Description=Syncthing (user)
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/syncthing -no-browser -no-restart -logflags=0
Restart=on-failure

[Install]
WantedBy=default.target
EOM3

    cat > "/home/${USER}/.config/systemd/user/pipewire.service" << 'EOM4'
[Unit]
Description=PipeWire

[Service]
ExecStart=/usr/bin/pipewire
Restart=on-failure

[Install]
WantedBy=default.target
EOM4

    cat > "/home/${USER}/.config/systemd/user/pipewire-pulse.service" << 'EOM5'
[Unit]
Description=PipeWire Pulse
After=pipewire.service

[Service]
ExecStart=/usr/bin/pipewire-pulse
Restart=on-failure

[Install]
WantedBy=default.target
EOM5

    cat > "/home/${USER}/.config/systemd/user/wireplumber.service" << 'EOM6'
[Unit]
Description=WirePlumber
After=pipewire.service

[Service]
ExecStart=/usr/bin/wireplumber
Restart=on-failure

[Install]
WantedBy=default.target
EOM6

    echo "systemd user services written for ${USER}. Enable with:" >&2
    echo "  systemctl --user daemon-reload" >&2
    echo "  systemctl --user enable --now pcloud-bisync.timer syncthing.service pipewire.service pipewire-pulse.service wireplumber.service" >&2
    ;;

  runit)
    sudo mkdir -p /etc/sv/pcloud-bisync /etc/sv/syncthing

    sudo tee /etc/sv/pcloud-bisync/run >/dev/null << 'EOM4'
#!/bin/sh
exec 2>&1
while true; do
  /usr/local/bin/pcloud-bisync
  sleep 7200
DONE
EOM4
    sudo sed -i 's/^DONE$/done/' /etc/sv/pcloud-bisync/run

    sudo tee /etc/sv/syncthing/run >/dev/null << EOM5
#!/bin/sh
exec 2>&1
exec chpst -u ${USER} /usr/bin/syncthing -no-browser -no-restart -logflags=0
EOM5

    sudo mkdir -p /etc/sv/pipewire /etc/sv/pipewire-pulse /etc/sv/wireplumber

    sudo tee /etc/sv/pipewire/run >/dev/null << EOM6
#!/bin/sh
exec 2>&1
exec chpst -u ${USER} /usr/bin/pipewire
EOM6

    sudo tee /etc/sv/pipewire-pulse/run >/dev/null << EOM7
#!/bin/sh
exec 2>&1
exec chpst -u ${USER} /usr/bin/pipewire-pulse
EOM7

    sudo tee /etc/sv/wireplumber/run >/dev/null << EOM8
#!/bin/sh
exec 2>&1
exec chpst -u ${USER} /usr/bin/wireplumber
EOM8

    sudo chmod +x /etc/sv/pcloud-bisync/run /etc/sv/syncthing/run /etc/sv/pipewire/run /etc/sv/pipewire-pulse/run /etc/sv/wireplumber/run

    echo "Enable runit services:" >&2
    echo "  sudo ln -s /etc/sv/pcloud-bisync /var/service/" >&2
    echo "  sudo ln -s /etc/sv/syncthing /var/service/" >&2
    echo "  sudo ln -s /etc/sv/pipewire /var/service/" >&2
    echo "  sudo ln -s /etc/sv/pipewire-pulse /var/service/" >&2
    echo "  sudo ln -s /etc/sv/wireplumber /var/service/" >&2
    ;;

  openrc)
    sudo tee /etc/init.d/pcloud-bisync >/dev/null << 'EOM6'
#!/sbin/openrc-run
name="pcloud-bisync"
command="/usr/local/bin/pcloud-bisync"
command_background="yes"
pidfile="/run/pcloud-bisync.pid"

start() {
  ebegin "Starting ${name}"
  start-stop-daemon --start --make-pidfile --pidfile "${pidfile}" \
    --background --startas /bin/sh -- -c 'while true; do /usr/local/bin/pcloud-bisync; sleep 7200; done'
  eend $?
}

stop() {
  ebegin "Stopping ${name}"
  start-stop-daemon --stop --pidfile "${pidfile}"
  eend $?
}
EOM6

    sudo tee /etc/init.d/syncthing >/dev/null << EOM7
#!/sbin/openrc-run
name="syncthing"
command="/usr/bin/syncthing"
command_user="${USER}"
command_args="-no-browser -no-restart -logflags=0"

start() {
  ebegin "Starting ${name}"
  start-stop-daemon --start --make-pidfile --pidfile /run/syncthing.pid \
    --background --startas /bin/sh -- -c "su - ${USER} -s /bin/sh -c '/usr/bin/syncthing -no-browser -no-restart -logflags=0'"
  eend $?
}

stop() {
  ebegin "Stopping ${name}"
  start-stop-daemon --stop --pidfile /run/syncthing.pid
  eend $?
}
EOM7

    sudo tee /etc/init.d/pipewire >/dev/null << EOM8
#!/sbin/openrc-run
name="pipewire"
command="/usr/bin/pipewire"
command_user="${USER}"
command_background="yes"
pidfile="/run/pipewire.pid"
EOM8

    sudo tee /etc/init.d/pipewire-pulse >/dev/null << EOM9
#!/sbin/openrc-run
name="pipewire-pulse"
command="/usr/bin/pipewire-pulse"
command_user="${USER}"
command_background="yes"
pidfile="/run/pipewire-pulse.pid"
EOM9

    sudo tee /etc/init.d/wireplumber >/dev/null << EOM10
#!/sbin/openrc-run
name="wireplumber"
command="/usr/bin/wireplumber"
command_user="${USER}"
command_background="yes"
pidfile="/run/wireplumber.pid"
EOM10

    sudo chmod +x /etc/init.d/pcloud-bisync /etc/init.d/syncthing /etc/init.d/pipewire /etc/init.d/pipewire-pulse /etc/init.d/wireplumber

    echo "Enable OpenRC services:" >&2
    echo "  sudo rc-update add pcloud-bisync default" >&2
    echo "  sudo rc-update add syncthing default" >&2
    echo "  sudo rc-update add pipewire default" >&2
    echo "  sudo rc-update add pipewire-pulse default" >&2
    echo "  sudo rc-update add wireplumber default" >&2
    echo "  sudo rc-service pcloud-bisync start" >&2
    echo "  sudo rc-service syncthing start" >&2
    echo "  sudo rc-service pipewire start" >&2
    echo "  sudo rc-service pipewire-pulse start" >&2
    echo "  sudo rc-service wireplumber start" >&2
    ;;

  s6)
    sudo mkdir -p /etc/s6-rc/source/pcloud-bisync /etc/s6-rc/source/syncthing

    sudo tee /etc/s6-rc/source/pcloud-bisync/type >/dev/null << 'EOM8'
longrun
EOM8
    sudo tee /etc/s6-rc/source/pcloud-bisync/run >/dev/null << 'EOM9'
#!/bin/sh
exec 2>&1
while true; do
  /usr/local/bin/pcloud-bisync
  sleep 7200
DONE
EOM9
    sudo sed -i 's/^DONE$/done/' /etc/s6-rc/source/pcloud-bisync/run

    sudo tee /etc/s6-rc/source/syncthing/type >/dev/null << 'EOM10'
longrun
EOM10
    sudo tee /etc/s6-rc/source/syncthing/run >/dev/null << EOM11
#!/bin/sh
exec 2>&1
exec s6-setuidgid ${USER} /usr/bin/syncthing -no-browser -no-restart -logflags=0
EOM11

    sudo mkdir -p /etc/s6-rc/source/pipewire /etc/s6-rc/source/pipewire-pulse /etc/s6-rc/source/wireplumber

    sudo tee /etc/s6-rc/source/pipewire/type >/dev/null << 'EOM12'
longrun
EOM12
    sudo tee /etc/s6-rc/source/pipewire/run >/dev/null << EOM13
#!/bin/sh
exec 2>&1
exec s6-setuidgid ${USER} /usr/bin/pipewire
EOM13

    sudo tee /etc/s6-rc/source/pipewire-pulse/type >/dev/null << 'EOM14'
longrun
EOM14
    sudo tee /etc/s6-rc/source/pipewire-pulse/run >/dev/null << EOM15
#!/bin/sh
exec 2>&1
exec s6-setuidgid ${USER} /usr/bin/pipewire-pulse
EOM15

    sudo tee /etc/s6-rc/source/wireplumber/type >/dev/null << 'EOM16'
longrun
EOM16
    sudo tee /etc/s6-rc/source/wireplumber/run >/dev/null << EOM17
#!/bin/sh
exec 2>&1
exec s6-setuidgid ${USER} /usr/bin/wireplumber
EOM17

    sudo chmod +x /etc/s6-rc/source/pcloud-bisync/run /etc/s6-rc/source/syncthing/run /etc/s6-rc/source/pipewire/run /etc/s6-rc/source/pipewire-pulse/run /etc/s6-rc/source/wireplumber/run

    sudo mkdir -p /etc/s6-rc/source/desktop-bundle/contents.d
    sudo touch /etc/s6-rc/source/desktop-bundle/contents.d/pcloud-bisync
    sudo touch /etc/s6-rc/source/desktop-bundle/contents.d/syncthing
    sudo touch /etc/s6-rc/source/desktop-bundle/contents.d/pipewire
    sudo touch /etc/s6-rc/source/desktop-bundle/contents.d/pipewire-pulse
    sudo touch /etc/s6-rc/source/desktop-bundle/contents.d/wireplumber

    echo "Compile and enable s6-rc bundle:" >&2
    echo "  sudo s6-rc-compile /etc/s6-rc/compiled /etc/s6-rc/source" >&2
    echo "  sudo s6-rc-update /etc/s6-rc/compiled" >&2
    echo "  sudo s6-rc -u change desktop-bundle" >&2
    ;;

  *)
    echo "Unknown init: $INIT" >&2
    exit 1
    ;;
esac
