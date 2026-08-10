FROM searxng/searxng:latest

# --- Render向けカスタマイズ(最小構成) ---
# ベースイメージのENTRYPOINT/CMDは一切上書きしない。
# (これらを独自スクリプトで置き換えると、内部のファイル配置がバージョンごとに
#  変わるため exit 127 のようなエラーの原因になりやすい)
#
# ベースイメージは起動時に BIND_ADDRESS 環境変数(host:port形式、デフォルト
# "0.0.0.0:8080")を見て自動的にその場所でリッスンする仕組みを持っている。
# ポート番号の制御は render.yaml 側の環境変数(PORT / BIND_ADDRESS)で行う。

ENV INSTANCE_NAME="MySearch"
ENV AUTOCOMPLETE="duckduckgo"
ENV BASE_URL=""

# 自分たちの設定ファイルを /etc/searxng に配置する。
# ベースイメージの起動処理が、既にこのファイルがあればそれを使う。
COPY settings.yml /etc/searxng/settings.yml
COPY limiter.toml /etc/searxng/limiter.toml

EXPOSE 8080
