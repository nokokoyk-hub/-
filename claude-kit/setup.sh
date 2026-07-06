#!/bin/bash
# ちゃぴ設定キット インストーラ ☕🔥
#
# 使い方（どちらでも同じ結果）:
#   1) 環境のセットアップスクリプトやターミナルから1行で:
#        curl -fsSL https://raw.githubusercontent.com/nokokoyk-hub/-/main/claude-kit/setup.sh | bash
#   2) このリポジトリのチェックアウト内から:
#        bash claude-kit/setup.sh
#
# ~/.claude/ に CLAUDE.md / agents / skills を配置する。
# 失敗しても exit 0 で終わり、セッション起動を止めない。
set -u

KIT_REPO="https://github.com/nokokoyk-hub/-.git"
BRANCH="main"
DEST="${HOME}/.claude"

log() { echo "[chapi-kit] $*"; }

# キットの場所を特定する。リポ内から実行されていればそれを使い、
# curl 経由（ファイルの実体がない）なら shallow clone してくる。
SRC=""
TMP=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-/dev/null}")" 2>/dev/null && pwd || true)"
if [ -n "${SCRIPT_DIR}" ] && [ -d "${SCRIPT_DIR}/global" ]; then
  SRC="${SCRIPT_DIR}/global"
  log "リポ内のキットを使うで: ${SRC}"
else
  TMP="$(mktemp -d)"
  if git clone --quiet --depth 1 --branch "${BRANCH}" "${KIT_REPO}" "${TMP}/kit" 2>/dev/null; then
    SRC="${TMP}/kit/claude-kit/global"
    log "GitHub からキットを取得したで（${BRANCH}）"
  fi
fi

if [ -z "${SRC}" ] || [ ! -d "${SRC}" ]; then
  log "キットを取得できんかった（ネットワーク制限の可能性）。今回はスキップするで"
  exit 0
fi

mkdir -p "${DEST}/agents" "${DEST}/skills"

# 共通 CLAUDE.md（キット側が正本なので上書き）
cp "${SRC}/CLAUDE.md" "${DEST}/CLAUDE.md" && log "CLAUDE.md を配置"

# エージェント3人
cp "${SRC}"/agents/*.md "${DEST}/agents/" && log "agents を配置: $(ls "${SRC}/agents" | tr '\n' ' ')"

# スキル（kickoff / wrapup / implement）。他のスキルには触らない
for skill_dir in "${SRC}"/skills/*/; do
  name="$(basename "${skill_dir}")"
  mkdir -p "${DEST}/skills/${name}"
  cp "${skill_dir}SKILL.md" "${DEST}/skills/${name}/SKILL.md"
  log "skill を配置: /${name}"
done

[ -n "${TMP}" ] && rm -rf "${TMP}"

log "導入完了や！のん × ちゃぴ ☕🔥"
exit 0
