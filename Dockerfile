FROM searxng/searxng:latest

# --- Render向けカスタマイズ ---
# Renderは単一のWebサービスとして PORT 環境変数でポートを渡してくる。
# 公式イメージは BIND_ADDRESS(host:port) を見るため、ラッパーentrypointで変換する。

ENV INSTANCE_NAME="MySearch"
ENV AUTOCOMPLETE="duckduckgo"
ENV BASE_URL=""

# 自分たちの設定ファイルを、公式エントリポイントが「まだ無ければコピーする」
# ディレクトリ (/etc/searxng) に配置する。
COPY settings.yml /etc/searxng/settings.yml
COPY limiter.toml /etc/searxng/limiter.toml
COPY docker-entrypoint-wrapper.sh /usr/local/searxng/docker-entrypoint-wrapper.sh

USER root
RUN chmod +x /usr/local/searxng/docker-entrypoint-wrapper.sh && \
    chown searxng:searxng /etc/searxng/settings.yml /etc/searxng/limiter.toml

USER searxng

EXPOSE 8080

ENTRYPOINT ["/usr/local/searxng/docker-entrypoint-wrapper.sh"]
