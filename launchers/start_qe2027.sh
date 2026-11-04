#!/usr/bin/env bash
# QE2027 launcher for Mac and Linux.
# Starts the Linux desktop in the background and opens it in the web browser.
#   bash start_qe2027.sh            browser desktop (normal use)
#   bash start_qe2027.sh shell      plain terminal in the same environment
#   bash start_qe2027.sh stop       stop the environment
set -euo pipefail

IMAGE="qe2027:1.0"
NAME="qe2027"
PORT=6080
WORK="$HOME/dft_work"                       # files saved here survive after closing
HERE="$(cd "$(dirname "$0")" && pwd)"
URL="http://localhost:$PORT"

case "$(uname -m)" in
    arm64|aarch64) ARCH=arm64 ;;
    x86_64|amd64)  ARCH=amd64 ;;
    *) echo "Unsupported computer type: $(uname -m)"; exit 1 ;;
esac
TARBALL="$HERE/qe2027-$ARCH.tar.gz"

# Docker Desktop puts its `docker` command in /usr/local/bin or ~/.docker/bin depending on an install
# choice, and a double-clicked script may not have either on PATH; the app always carries its own copy
export PATH="$PATH:/usr/local/bin:$HOME/.docker/bin:/Applications/Docker.app/Contents/Resources/bin"

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not installed. See the instructions: https://github.com/sairajdream/qe2027"
    exit 1
fi
if ! docker info >/dev/null 2>&1; then
    echo "Docker isn't running yet; starting it (this can take a minute)..."
    if [ "$(uname)" = "Darwin" ]; then
        open -a Docker 2>/dev/null || true
    else
        systemctl --user start docker-desktop 2>/dev/null || sudo systemctl start docker 2>/dev/null || true
    fi
    for _ in $(seq 60); do docker info >/dev/null 2>&1 && break; sleep 2; done
    if ! docker info >/dev/null 2>&1; then
        echo "Docker didn't start. Open Docker Desktop, wait until it says 'Engine running', then try again."
        [ "$(uname)" = "Linux" ] && echo "(Linux: if you installed Docker Engine, make sure you ran: sudo usermod -aG docker \$USER, then logged out and in.)"
        exit 1
    fi
fi

if [ "${1:-}" = "stop" ]; then
    docker rm -f "$NAME" >/dev/null 2>&1 && echo "Stopped. Your files are still in $WORK" || echo "Not running."
    exit 0
fi

# Load the image once (from the file shared with you)
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
    if [ ! -f "$TARBALL" ]; then
        other=$(ls "$HERE"/qe2027-*.tar.gz 2>/dev/null | head -1)
        if [ -n "$other" ]; then
            echo "This is the wrong download for your computer. You need the $([ $ARCH = arm64 ] && echo 'Apple Silicon' || echo 'Intel_AMD') zip."
        else
            echo "Can't find $TARBALL (keep it in the same folder as this script)."
        fi
        exit 1
    fi
    echo "Loading QE2027 (one time only, takes 1-3 minutes)..."
    docker load -i "$TARBALL"
fi

mkdir -p "$WORK"

# Start the container unless it's already running this version (an older version gets replaced)
if [ "$(docker inspect -f '{{.State.Running}} {{.Config.Image}}' "$NAME" 2>/dev/null)" != "true $IMAGE" ]; then
    docker rm -f "$NAME" >/dev/null 2>&1 || true
    docker run -d --init --name "$NAME" --hostname qe2027 --shm-size=512m \
        -p "127.0.0.1:$PORT:6080" \
        -v "$WORK:/home/student/work" \
        -v qe2027-persist:/home/student/.persist \
        "$IMAGE" >/dev/null
    for _ in $(seq 30); do curl -sf "$URL/vnc.html" >/dev/null 2>&1 && break; sleep 1; done
fi

if [ "${1:-}" = "shell" ]; then
    exec docker exec -it "$NAME" bash -l
fi

echo "QE2027 is running: $URL"
echo "Your files: $WORK"
if [ "$(uname)" = "Darwin" ]; then open "$URL"; else xdg-open "$URL" >/dev/null 2>&1 || true; fi
