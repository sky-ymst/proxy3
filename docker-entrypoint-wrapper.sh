#!/bin/sh
set -e

# Renderは実行時に PORT 環境変数でリッスンすべきポートを渡してくる。
# SearXNG公式イメージは BIND_ADDRESS (host:port形式) を見て uwsgi の待受先を決めるので、
# PORT を BIND_ADDRESS に変換してから公式のentrypointへ処理を渡す。
LISTEN_PORT="${PORT:-8080}"
export BIND_ADDRESS="0.0.0.0:${LISTEN_PORT}"

# 公式イメージのentrypoint(設定ファイルの初期化・secret_key生成などを行う)を呼び出す
exec /usr/local/searxng/dockerfiles/docker-entrypoint.sh "$@"
