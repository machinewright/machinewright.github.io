#!/usr/bin/env bash
# Tell IndexNow search engines (Bing, Yandex, Seznam, Naver...) about every URL in sitemap.xml.
# No account: ownership is shown by the key file at the site root. 200/202 = accepted. Run after publishing a page.
set -euo pipefail
cd "$(dirname "$0")/.."
K=e0956c18df88b6ef190adde58806ce69
URLS=$(grep -o 'https://[^<]*' sitemap.xml | python3 -c "import sys,json;print(json.dumps([l.strip() for l in sys.stdin]))")
curl -s -o /dev/null -w "IndexNow: %{http_code}\n" -X POST https://api.indexnow.org/indexnow \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d "{\"host\":\"machinewright.github.io\",\"key\":\"$K\",\"keyLocation\":\"https://machinewright.github.io/$K.txt\",\"urlList\":$URLS}"
