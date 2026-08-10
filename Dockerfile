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
# Windows等で編集された場合のCRLF改行コードをLFに強制変換し、
# 実行権限を付与する(exit 127 = "コマンドが見つからない"の典型的な原因対策)。
RUN sed -i 's/\r$//' /usr/local/searxng/docker-entrypoint-wrapper.sh && \
    chmod +x /usr/local/searxng/docker-entrypoint-wrapper.sh && \
    chown searxng:searxng /etc/searxng/settings.yml /etc/searxng/limiter.toml

USER searxng

EXPOSE 8080

# シェル経由で明示的に実行することで、実行ビット消失やshebang不整合にも耐性を持たせる
ENTRYPOINT ["/bin/sh", "/usr/local/searxng/docker-entrypoint-wrapper.sh"]
