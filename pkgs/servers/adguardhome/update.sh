#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl gnugrep nix-prefetch jq

# This file is based on /pkgs/servers/gotify/update.sh

set -euo pipefail

dirname="$(dirname "$0")"
bins="$dirname/bins.nix"

latest_release=$(curl --silent https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release")

echo "got version $version"

schema_version=$(curl --silent "https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/${version}/internal/configmigrate/configmigrate.go" \
    | grep -Po '(?<=const LastSchemaVersion uint = )[[:digit:]]+$')

echo "got schema_version $schema_version"

declare -A systems
systems[linux_386]=i686-linux
systems[linux_amd64]=x86_64-linux
systems[linux_arm64]=aarch64-linux
systems[linux_armv6]=armv6l-linux
systems[linux_armv7]=armv7l-linux
systems[darwin_amd64]=x86_64-darwin
systems[darwin_arm64]=aarch64-darwin

echo '{ fetchurl, fetchzip }:' > "$bins"
echo '{' >> "$bins"

for asset in $(curl --silent https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest | jq -c '.assets[]') ; do
    url="$(jq -r '.browser_download_url' <<< "$asset")"
    adg_system="$(grep -Eo '(darwin|linux)_(386|amd64|arm64|armv6|armv7)' <<< "$url" || true)"
    if [ -n "$adg_system" ]; then
        fetch="$(grep '\.zip$' <<< "$url" > /dev/null && echo fetchzip || echo fetchurl)"
        nix_system=${systems[$adg_system]}
        nix_src="$(nix-prefetch --option extra-experimental-features flakes -s --output nix $fetch --url $url)"
        echo "$nix_system = $fetch $nix_src;" >> $bins
    fi
done

echo '}' >> "$bins"

sed -i -r -e "s/version\s*?=\s*?.*?;/version = \"${version#v}\";/" "$dirname/default.nix"
sed -i -r -e "s/schema_version\s*?=\s*?.*?;/schema_version = ${schema_version};/" "$dirname/default.nix"
