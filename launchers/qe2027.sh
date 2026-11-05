#!/usr/bin/env bash
# QE2027 for Mac and Linux: double-click (Mac, as "QE2027.command") or run "bash qe2027.sh".
# Shows a menu, or takes the choice directly:  start | stop | update | reset | shell
# Each computer keeps its own copy of the system: Stop pauses it, Start resumes it, so apps a
# student installs stay. Update and Reset replace the copy; dft_work and saved keys are always kept.
set -uo pipefail

IMAGE="ghcr.io/sairajdream/qe2027:latest"
NAME="qe2027"
PORT=6080
WORK="$HOME/dft_work"                       # files saved here are on this computer, never lost
HERE="$(cd "$(dirname "$0")" && pwd)"
URL="http://localhost:$PORT"

case "$(uname -m)" in
    arm64|aarch64) ARCH=arm64 ;;
    x86_64|amd64)  ARCH=amd64 ;;
    *) echo "Unsupported computer type: $(uname -m)"; exit 1 ;;
esac
# Optional offline install: qe2027-<arch>.tar.gz next to this file is used instead of downloading
TARBALL="$HERE/qe2027-$ARCH.tar.gz"

# Docker Desktop puts its `docker` command in /usr/local/bin or ~/.docker/bin depending on an install
# choice, and a double-clicked script may not have either on PATH; the app always carries its own copy
export PATH="$PATH:/usr/local/bin:$HOME/.docker/bin:/Applications/Docker.app/Contents/Resources/bin"
# Mac: always use Docker Desktop, even if another Docker engine (Colima, OrbStack) is the default
if [ "$(uname)" = "Darwin" ] && [ -z "${DOCKER_HOST:-}" ] && docker context inspect desktop-linux >/dev/null 2>&1; then
    export DOCKER_CONTEXT=desktop-linux
fi

die() { echo; echo "$*"; exit 1; }

ensure_docker() {
    command -v docker >/dev/null 2>&1 \
        || die "Docker is not installed. See Step 1: https://github.com/sairajdream/qe2027"
    docker info >/dev/null 2>&1 && return
    echo "Starting Docker (this can take a minute)..."
    if [ "$(uname)" = "Darwin" ]; then
        open -a Docker 2>/dev/null || true
    else
        systemctl --user start docker-desktop 2>/dev/null || sudo systemctl start docker 2>/dev/null || true
    fi
    for _ in $(seq 60); do docker info >/dev/null 2>&1 && return; sleep 2; done
    [ "$(uname)" = "Linux" ] && echo "Linux: run 'sudo usermod -aG docker \$USER', then log out and back in."
    die "Docker didn't start. Open Docker, wait until it's ready, then try again."
}

get_image() {
    if [ -f "$TARBALL" ]; then
        echo "Installing QE2027 from $TARBALL (1-3 minutes)..."
        docker load -i "$TARBALL" || die "Couldn't load $TARBALL."
    else
        echo "Downloading QE2027 (about 1.6 GB, one time only)..."
        docker pull "$IMAGE" || die "Download failed. Check your internet connection and try again."
    fi
}

create() {
    mkdir -p "$WORK"
    # Linux: QE2027 writes as user 1000; if you're a different user, let both of you read and write
    if [ "$(uname)" = "Linux" ] && [ "$(id -u)" != 1000 ] && command -v setfacl >/dev/null 2>&1; then
        setfacl -m "u:1000:rwx,u:$(id -u):rwx" -d -m "u:1000:rwx,u:$(id -u):rwx" "$WORK" 2>/dev/null || true
    fi
    docker run -d --init --name "$NAME" --hostname qe2027 --shm-size=512m \
        -p "127.0.0.1:$PORT:6080" \
        -v "$WORK:/home/student/work" \
        -v qe2027-persist:/home/student/.persist \
        "$IMAGE" >/dev/null || die "QE2027 couldn't start. Is something else using port $PORT?"
}

open_desktop() {
    for _ in $(seq 30); do curl -sf "$URL/vnc.html" >/dev/null 2>&1 && break; sleep 1; done
    echo
    echo "QE2027 is running: $URL"
    echo "Your files: $WORK"
    if [ "$(uname)" = "Darwin" ]; then open "$URL"; else xdg-open "$URL" >/dev/null 2>&1 || true; fi
}

confirm() {
    read -r -p "$1 Continue? [y/N] " a
    [[ "$a" =~ ^[Yy] ]] || die "Cancelled. Nothing was changed."
}

do_start() {
    docker image inspect "$IMAGE" >/dev/null 2>&1 || get_image
    if docker container inspect "$NAME" >/dev/null 2>&1; then
        docker start "$NAME" >/dev/null || die "QE2027 couldn't start. Try Reset."
    else
        create
    fi
    open_desktop
}

do_stop() {
    if docker stop -t 5 "$NAME" >/dev/null 2>&1; then
        echo "Stopped. Everything is kept for next time. Your files are in $WORK"
    else
        echo "QE2027 is not running."
    fi
}

do_update() {
    [ -f "$TARBALL" ] && die "This is an offline copy. Ask the instructor for the new version."
    local old new
    old=$(docker image inspect -f '{{.Id}}' "$IMAGE" 2>/dev/null)
    echo "Checking for a new version..."
    docker pull "$IMAGE" || die "Download failed. Check your internet connection and try again."
    new=$(docker image inspect -f '{{.Id}}' "$IMAGE")
    if [ "$(docker container inspect -f '{{.Image}}' "$NAME" 2>/dev/null)" = "$new" ]; then
        echo "You already have the latest version."
        return
    fi
    if docker container inspect "$NAME" >/dev/null 2>&1; then
        confirm "Updating gives you a fresh new system. Your dft_work files, GitHub login and keys are kept. Apps you installed yourself must be installed again."
        docker rm -f "$NAME" >/dev/null
    fi
    [ -n "$old" ] && [ "$old" != "$new" ] && docker rmi "$old" >/dev/null 2>&1
    create
    open_desktop
}

do_reset() {
    confirm "Reset gives you a fresh system, like the first day. Your dft_work files, GitHub login and keys are kept. Apps you installed and changes outside dft_work are removed."
    docker rm -f "$NAME" >/dev/null 2>&1
    docker image inspect "$IMAGE" >/dev/null 2>&1 || get_image
    create
    open_desktop
}

choice="${1:-}"
if [ -z "$choice" ]; then
    echo "QE2027"
    echo "  1) Start"
    echo "  2) Stop"
    echo "  3) Update to the latest version"
    echo "  4) Reset (fresh system, your dft_work files are kept)"
    read -r -p "Type a number and press Enter [1]: " n
    case "${n:-1}" in
        1) choice=start ;; 2) choice=stop ;; 3) choice=update ;; 4) choice=reset ;;
        *) die "Please type 1, 2, 3 or 4." ;;
    esac
fi

ensure_docker
case "$choice" in
    start)  do_start ;;
    stop)   do_stop ;;
    update) do_update ;;
    reset)  do_reset ;;
    shell)  do_start >/dev/null; exec docker exec -it "$NAME" bash -l ;;
    *) die "Usage: bash qe2027.sh [start|stop|update|reset|shell]" ;;
esac
[ "$(uname)" = "Darwin" ] && [ -z "${1:-}" ] && echo && echo "You can close this window."
exit 0
