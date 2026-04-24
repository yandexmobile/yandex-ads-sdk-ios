#!/bin/bash
# ============================================================
# Yandex Ads SDK — SKAdNetwork IDs Updater
#
# Fetches the latest SKAdNetwork IDs from Yandex
# and merges them into Info.plist
# ============================================================

set -o pipefail

URLS=(
    "https://yastatic.net/pcode-static/skadnetwork/skadids.json"
    "https://yastatic.net/pcode-static/skadnetwork/skadids.xml"
)

PLIST_BUDDY="/usr/libexec/PlistBuddy"
TAG="[YandexAds]"

# ---- Colors ----

if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

log_info()    { printf "${NC}${TAG} %s${NC}\n" "$1"; }
log_start()   { printf "${YELLOW}${TAG} %s${NC}\n" "$1"; }
log_success() { printf "${GREEN}${TAG} %s${NC}\n" "$1"; }

log_warn() {
    if [ -t 1 ]; then
        # Terminal: colored, readable format
        printf "${RED}${TAG} Warning: %s${NC}\n" "$1"
    else
        # Xcode Build Phase: recognized as warning in Issue Navigator
        printf "warning: ${TAG} %s\n" "$1"
    fi
}

# ---- Start ----

log_start "Starting SKAdNetwork IDs update..."

# ---- Resolve Info.plist path ----

resolve_plist() {
    # 1. Explicit argument
    if [ -n "${1:-}" ]; then
        echo "$1"
        return 0
    fi

    # 2. Xcode environment
    if [ -n "${INFOPLIST_FILE:-}" ]; then
        if [[ "${INFOPLIST_FILE}" = /* ]]; then
            echo "${INFOPLIST_FILE}"
        else
            echo "${SRCROOT:-.}/${INFOPLIST_FILE}"
        fi
        return 0
    fi

    # 3. Auto-search in current directory
    local found
    found=$(find . \
        -name "Info.plist" \
        -not -path "*/Pods/*" \
        -not -path "*/Carthage/*" \
        -not -path "*/DerivedData/*" \
        -not -path "*/build/*" \
        -not -path "*/.build/*" \
        -not -path "*/Packages/*" \
        -not -path "*Tests*" \
        -not -path "*Extensions*" \
        2>/dev/null)

    local count
    count=$([ -n "$found" ] && echo "$found" | wc -l | tr -d ' ' || echo "0")

    if [ "$count" -eq 1 ]; then
        echo "$found"
        return 0
    elif [ "$count" -gt 1 ]; then
        log_warn "Found multiple Info.plist files:" >&2
        echo "$found" >&2
        log_warn "Pass the correct path as argument." >&2
        return 1
    fi

    log_warn "Info.plist not found. Pass as argument or run from project root." >&2
    return 1
}

PLIST_PATH=$(resolve_plist "${1:-}") || exit 0

if [ ! -f "$PLIST_PATH" ]; then
    log_warn "File not found: $PLIST_PATH"
    exit 0
fi

log_info "Plist: $PLIST_PATH"

# ---- Fetch with fallback ----

RESPONSE=""

for url in "${URLS[@]}"; do
    log_info "Trying: $url"
    RESPONSE=$(curl -sf --max-time 5 "$url" 2>/dev/null) && [ -n "$RESPONSE" ] && {
        log_info "Fetched: $url"
        break
    }
    RESPONSE=""
done

if [ -z "$RESPONSE" ]; then
    log_warn "All sources unavailable. Skipping."
    exit 0
fi

# ---- Extract IDs (both JSON and XML) ----

REMOTE_IDS=$(echo "$RESPONSE" \
    | grep -ioE '[a-z0-9]+\.skadnetwork' \
    | tr '[:upper:]' '[:lower:]' \
    | sort -u)

if [ -z "$REMOTE_IDS" ]; then
    log_warn "No IDs parsed. Skipping."
    exit 0
fi

REMOTE_COUNT=$(echo "$REMOTE_IDS" | wc -l | tr -d ' ')
log_info "Remote IDs: $REMOTE_COUNT"

# ---- Read existing IDs from plist ----

EXISTING_IDS=$("$PLIST_BUDDY" -c "Print :SKAdNetworkItems" "$PLIST_PATH" 2>/dev/null \
    | grep -ioE '[a-z0-9]+\.skadnetwork' \
    | tr '[:upper:]' '[:lower:]' \
    | sort -u)

EXISTING_COUNT=$([ -n "$EXISTING_IDS" ] && echo "$EXISTING_IDS" | wc -l | tr -d ' ' || echo "0")
log_info "Existing IDs: $EXISTING_COUNT"

# ---- Additive diff: only new IDs ----

if [ -n "$EXISTING_IDS" ]; then
    IDS_TO_ADD=$(comm -23 <(echo "$REMOTE_IDS") <(echo "$EXISTING_IDS"))
else
    IDS_TO_ADD="$REMOTE_IDS"
fi

ADD_COUNT=$([ -n "$IDS_TO_ADD" ] && echo "$IDS_TO_ADD" | wc -l | tr -d ' ' || echo "0")

if [ "$ADD_COUNT" -eq 0 ]; then
    log_success "Up to date."
    exit 0
fi

log_start "Adding $ADD_COUNT new ID(s)..."

# ---- Ensure SKAdNetworkItems array exists ----

"$PLIST_BUDDY" -c "Print :SKAdNetworkItems" "$PLIST_PATH" &>/dev/null \
    || "$PLIST_BUDDY" -c "Add :SKAdNetworkItems array" "$PLIST_PATH"

# ---- Append new entries ----

INDEX=$("$PLIST_BUDDY" -c "Print :SKAdNetworkItems" "$PLIST_PATH" 2>/dev/null \
    | grep -c "Dict")

while IFS= read -r skad_id; do
    [ -z "$skad_id" ] && continue
    "$PLIST_BUDDY" \
        -c "Add :SKAdNetworkItems: dict" \
        -c "Add :SKAdNetworkItems:${INDEX}:SKAdNetworkIdentifier string ${skad_id}" \
        "$PLIST_PATH" 2>/dev/null || {
        log_warn "Failed to add: $skad_id"
        continue
    }
    INDEX=$((INDEX + 1))
done <<< "$IDS_TO_ADD"

TOTAL=$((EXISTING_COUNT + ADD_COUNT))
log_success "Done. Total: $TOTAL (+$ADD_COUNT new)"
