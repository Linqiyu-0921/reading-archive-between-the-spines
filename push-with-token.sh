#!/usr/bin/env bash
# ============================================================
# push-with-token.sh
# 用法: GITHUB_TOKEN='你的PAT' bash push-with-token.sh
# 从环境变量读取 token（不 source 连接器网关、脚本内不含明文）。
# 推送完成后自动把 remote URL 中的 token 擦除，避免凭据残留在 .git/config。
# ============================================================
set -e

REPO="reading-archive-between-the-spines"
DESC="书架书籍识别清单 + Between the Spines 风格图书展示网站（含用户上传图片/视频、完整对话记录）"

if [ -z "$GITHUB_TOKEN" ]; then
  echo "✗ 请通过环境变量提供 GITHUB_TOKEN（例如 GITHUB_TOKEN='ghp_xxx' bash $0）" >&2
  exit 1
fi

# 验证 token 并取用户名
LOGIN=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/user \
  | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('login',''))")
if [ -z "$LOGIN" ]; then
  echo "✗ token 无效（401 Bad credentials）。请确认：完整复制无空格、未过期、且具有 repo 权限。" >&2
  exit 1
fi
echo "✓ 登录用户: $LOGIN"

# 创建公开仓库（已存在则忽略 422）
echo "→ 创建仓库 $LOGIN/$REPO ..."
curl -s -o /dev/null -w "  create repo -> HTTP %{http_code}\n" -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" -H "Content-Type: application/json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO\",\"description\":\"$DESC\",\"private\":false,\"auto_init\":false,\"has_issues\":true}"

# 配置带 token 的 remote 并推送
git remote remove origin 2>/dev/null || true
git remote add origin "https://oauth2:${GITHUB_TOKEN}@github.com/${LOGIN}/${REPO}.git"
git branch -M main
echo "→ 推送 main 分支 ..."
git push -u origin main

# 关键：推送后立即移除 remote 中的 token 凭据
git remote set-url origin "https://github.com/${LOGIN}/${REPO}.git"
echo ""
echo "✅ 完成: https://github.com/${LOGIN}/${REPO}"
