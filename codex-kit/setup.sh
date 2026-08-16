#!/usr/bin/env bash
set -euo pipefail

readonly chapi_source_url="https://raw.githubusercontent.com/nokokoyk-hub/-/main/codex-kit/global/AGENTS.md"
readonly chapi_codex_home="${CODEX_HOME:-${HOME}/.codex}"
readonly chapi_target="${chapi_codex_home}/AGENTS.md"
readonly chapi_expected_header="# AGENTS.md — ちゃぴ共通設定（Codex用）"

mkdir -p "${chapi_codex_home}"

chapi_temp_file="$(mktemp "${TMPDIR:-/tmp}/chapi-codex-agents.XXXXXX")"
trap 'rm -f "${chapi_temp_file}"' EXIT

curl --fail --location --silent --show-error \
  --retry 3 --retry-delay 2 \
  "${chapi_source_url}" \
  --output "${chapi_temp_file}"

if [[ ! -s "${chapi_temp_file}" ]]; then
  echo "ERROR: ちゃぴ設定の取得結果が空です。" >&2
  exit 1
fi

if ! grep -Fq "${chapi_expected_header}" "${chapi_temp_file}"; then
  echo "ERROR: 取得したファイルが想定したちゃぴ設定ではありません。" >&2
  exit 1
fi

if [[ -f "${chapi_target}" ]] && ! cmp -s "${chapi_temp_file}" "${chapi_target}"; then
  cp -p "${chapi_target}" "${chapi_target}.backup-before-chapi-kit"
fi

mv "${chapi_temp_file}" "${chapi_target}"
trap - EXIT

echo "ちゃぴ設定を ${chapi_target} に導入しました。"
