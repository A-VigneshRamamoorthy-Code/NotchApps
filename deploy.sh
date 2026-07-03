#!/usr/bin/env bash
# Deploy the Notch Apps site to GitHub Pages.
#
# Usage:
#   ./deploy.sh                      # uses $GITHUB_TOKEN (or gh auth), owner/repo defaults below
#   GITHUB_TOKEN=ghp_xxx ./deploy.sh
#   ./deploy.sh <token> [owner] [repo]
#
# It will: create the repo (if missing) → push main → enable GitHub Pages → print the live URL.
# The token needs "repo" scope (classic) or Contents+Administration+Pages write (fine-grained).

set -euo pipefail

OWNER="${2:-A-VigneshRamamoorthy-Code}"
REPO="${3:-NotchApps}"
TOKEN="${1:-${GITHUB_TOKEN:-}}"

# Fall back to gh's token if available and none supplied.
if [ -z "$TOKEN" ] && command -v gh >/dev/null 2>&1; then
  TOKEN="$(gh auth token 2>/dev/null || true)"
fi

if [ -z "$TOKEN" ]; then
  echo "ERROR: no token. Pass one:  ./deploy.sh <github_token>"
  echo "Create one at https://github.com/settings/tokens (scope: repo)."
  exit 1
fi

api() { curl -sS -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" "$@"; }

echo "→ Checking repo $OWNER/$REPO ..."
code="$(api -o /dev/null -w '%{http_code}' "https://api.github.com/repos/$OWNER/$REPO")"
if [ "$code" = "404" ]; then
  echo "→ Creating public repo $OWNER/$REPO ..."
  api -X POST "https://api.github.com/user/repos" \
    -d "{\"name\":\"$REPO\",\"description\":\"Notch Apps — NotchPaw & NotchLock landing page\",\"homepage\":\"https://${OWNER,,}.github.io/$REPO/\",\"private\":false,\"has_issues\":true,\"has_wiki\":false}" \
    -o /dev/null -w '   created (HTTP %{http_code})\n'
else
  echo "   repo already exists (HTTP $code)."
fi

echo "→ Pushing main ..."
git remote remove origin 2>/dev/null || true
git remote add origin "https://x-access-token:${TOKEN}@github.com/$OWNER/$REPO.git"
git push -u origin main
git remote set-url origin "https://github.com/$OWNER/$REPO.git"   # scrub token from remote

echo "→ Enabling GitHub Pages (branch: main, path: /) ..."
pcode="$(api -o /dev/null -w '%{http_code}' -X POST "https://api.github.com/repos/$OWNER/$REPO/pages" \
  -d '{"source":{"branch":"main","path":"/"}}')"
if [ "$pcode" = "409" ]; then
  echo "   Pages already enabled; updating source ..."
  api -o /dev/null -w '   updated (HTTP %{http_code})\n' -X PUT "https://api.github.com/repos/$OWNER/$REPO/pages" \
    -d '{"source":{"branch":"main","path":"/"}}'
else
  echo "   enabled (HTTP $pcode)."
fi

URL="https://$(echo "$OWNER" | tr '[:upper:]' '[:lower:]').github.io/$REPO/"
echo ""
echo "✅ Done. Your site will be live in ~1 minute at:"
echo "   $URL"
echo ""
echo "   (First build can take 1–2 min. Check Settings → Pages if it 404s at first.)"
