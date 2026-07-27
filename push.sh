#!/usr/bin/env bash
# ============================================================
# push-to-github.sh
# 用途：在 CodeBuddy 沙箱环境内，使用 GitHub 连接器下发的 OAuth Token
#       一键创建仓库并推送本地的 reading-archive-between-the-spines。
# 依赖：CodeBuddy 网关 get_token.sh（仅沙箱内可用）。
#       用户本地执行请用 README「发布到 GitHub · 路径 B」。
# ============================================================
set -e

REPO="reading-archive-between-the-spines"
DESC="书架书籍识别清单 + Between the Spines 风格图书展示网站（含用户上传图片/视频、完整对话记录）"

# 1) 获取 GitHub 连接器 Token（刷新自 CodeBuddy 网关）
source /root/.codebuddy/skills/github-connector/scripts/get_token.sh github

# 2) 解析当前 GitHub 登录名
LOGIN=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/user \
  | python3 -c "import sys,json;d=json.load(sys.stdin);print(d.get('login',''))")
if [ -z "$LOGIN" ]; then
  echo "✗ 无法获取 GitHub 用户名，Token 可能无效（401）。请在 CodeBuddy 设置重新授权 GitHub。" >&2
  exit 1
fi
echo "✓ GitHub 账号: $LOGIN"

# 3) 创建仓库（若已存在返回 422，可忽略）
echo "→ 创建仓库 $LOGIN/$REPO ..."
curl -s -o /dev/null -w "  create repo -> HTTP %{http_code}\n" \
  -X POST -H "Authorization: Bearer $GITHUB_TOKEN" -H "Content-Type: application/json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO\",\"description\":\"$DESC\",\"private\":false,\"auto_init\":false,\"has_issues\":true}"

# 4) 配置 remote 并推送
git remote remove origin 2>/dev/null || true
git remote add origin "https://oauth2:${GITHUB_TOKEN}@github.com/${LOGIN}/${REPO}.git"
git branch -M main
echo "→ 推送 main 分支 ..."
git push -u origin main
echo ""
echo "✅ 完成：https://github.com/${LOGIN}/${REPO}"
