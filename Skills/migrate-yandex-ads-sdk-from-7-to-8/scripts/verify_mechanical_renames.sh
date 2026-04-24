#!/usr/bin/env bash
# Verify Step 3 mechanical renames. Exit 1 if any forbidden pattern remains.
set -uo pipefail
ROOT="${1:-.}"
cd "$ROOT"

FAILED=0

swift0() { find . -name "*.swift" -not -path "*/Pods/*" -not -path "*/.build/*" -not -path "*/DerivedData/*" -print0; }

check() {
  local desc="$1"
  shift
  local out
  out=$(eval "$@" 2>/dev/null || true)
  out=$(echo "$out" | sed '/^$/d')
  if [[ -n "$out" ]]; then
    echo "FAIL: $desc"
    echo "$out"
    FAILED=1
  else
    echo "OK: $desc"
  fi
}

check "MobileAds. (Yandex unqualified only)" \
  'swift0 | xargs -0 grep -sn "MobileAds\." | grep -Ev "[A-Za-z0-9_]+\.MobileAds\." | grep -v "GoogleMobileAds" | grep -v "YandexMobileAds"'

check "YMANativeAdView / YMANativeMediaView" \
  'swift0 | xargs -0 grep -sn "YMANativeAdView\|YMANativeMediaView"'

check "audioSessionManager()" \
  'swift0 | xargs -0 grep -sn "audioSessionManager()"'

check "MobileAds.sdkVersion" \
  'swift0 | xargs -0 grep -sn "MobileAds\.sdkVersion"'

check "AdTargetInfo" \
  'swift0 | xargs -0 grep -sn "\bAdTargetInfo\b"'

check ".targetInfo" \
  'swift0 | xargs -0 grep -sn "\.targetInfo\b"'

check "kYMAGender constants" \
  'swift0 | xargs -0 grep -sn "kYMAGenderFemale\|kYMAGenderMale"'

check "Old BannerAdSize factories" \
  'swift0 | xargs -0 grep -sn "fixedSize(withWidth\|inlineSize(withWidth\|stickySize(withContainerWidth"'

check "BidderTokenRequestConfiguration" \
  'swift0 | xargs -0 grep -sn "\bBidderTokenRequestConfiguration\b"'

check "loadBidderToken(requestConfiguration:" \
  'swift0 | xargs -0 grep -sn "loadBidderToken(requestConfiguration:"'

check "BidderTokenLoader(mediationNetworkName:" \
  'swift0 | xargs -0 grep -sn "BidderTokenLoader(mediationNetworkName:"'

check ".adUnitId (old casing on SDK types)" \
  'swift0 | xargs -0 grep -sn "\.adUnitId\b" | grep -v "adUnitID" | grep -v "self\.adUnitId" | grep -v "let adUnitId" | grep -v "adUnitId:"'

check "AdInfo.data" \
  'swift0 | xargs -0 grep -sn "AdInfo\.data\b"'

check "didFailToShowWithError" \
  'swift0 | xargs -0 grep -sn "didFailToShowWithError"'

check "didTrackImpressionWith" \
  'swift0 | xargs -0 grep -sn "didTrackImpressionWith[^a-zA-Z]"'

check "Rating old API" \
  'swift0 | xargs -0 grep -sn "Rating\.setRating\|Rating\.rating()"'

check "Old AdRequest type names" \
  'swift0 | xargs -0 grep -sn "AdRequestConfiguration\|NativeAdRequestConfiguration\|MutableAdRequest\|MutableAdRequestConfiguration\|MutableNativeAdRequestConfiguration" | grep -v "Instream"'

check "YandexAds.initializeSDK() without completionHandler" \
  'swift0 | xargs -0 grep -snE "YandexAds\.initializeSDK\(\s*\)"'

check "Deleted error code enums" \
  'swift0 | xargs -0 grep -sn "\bAdErrorCode\b\|\bNativeErrorCode\b"'

check "Deleted Version properties" \
  'swift0 | xargs -0 grep -sn "\.prereleaseIdentifiers\|\.buildMetadataIdentifiers"'

check "AdInfo.adSize (deleted)" \
  'swift0 | xargs -0 grep -sn "\.adInfo\.adSize\b"'

# Positive check: imports must still exist
_imp=$(swift0 | xargs -0 grep -sn "import YandexMobileAds" 2>/dev/null || true)
if [[ -n "$_imp" ]]; then
  echo "OK: import YandexMobileAds preserved"
else
  echo "FAIL: no import YandexMobileAds found"
  FAILED=1
fi

if [[ "$FAILED" -ne 0 ]]; then
  echo ""
  echo "Step 3 verification failed. Fix matches above."
  exit 1
fi

echo ""
echo "Step 3 verification passed."
exit 0
