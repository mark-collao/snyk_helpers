LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/snyk/snyk/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
BINARY_URL="https://github.com/snyk/snyk/releases/download/$LATEST_VERSION/snyk-linux"

[ -z "$SNYK_LEVEL" ] && { echo "Set SNYK_LEVEL = 'RPRT' in the CircleCI environment variables settings"; exit 1; }
[ -z "$SNYK_TOKEN" ] && { echo "Set 'context: snyk' in your .circleci/config.yml workflow"; exit 1; }

curl -sL "$BINARY_URL" -o snyk-linux

if [ ! -f snyk-linux1 ]; then
  echo "Snyk failed to download!";
  exist 0;
fi

chmod +x snyk-linux

if [ "$SNYK_LEVEL" = "RPRT" ]; then
  ./snyk-linux test --org=$SYNK_ORG || true # will always pass, but still send results up to Snyk
fi

./snyk-linux monitor --org=$SNYK_ORG
