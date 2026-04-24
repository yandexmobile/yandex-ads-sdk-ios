#!/usr/bin/env bash
# Final verification — exit 1 if any forbidden pattern remains in Swift sources.
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

check "YandexAds.initializeSDK() without completionHandler" \
  'swift0 | xargs -0 grep -snE "YandexAds\.initializeSDK\(\s*\)"'

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

# Step 5 checks (Instream excluded — not migrated yet)
check "Loader delegates" \
  'swift0 | xargs -0 grep -sn "AppOpenAdLoaderDelegate\|InterstitialAdLoaderDelegate\|RewardedAdLoaderDelegate\|NativeAdLoaderDelegate\|NativeBulkAdLoaderDelegate\|SliderAdLoaderDelegate" | grep -v "Instream" | grep -v "GoogleMobileAds"'

# Step 6 checks
check "AdView (heuristic)" \
  'swift0 | xargs -0 grep -sn "\bAdView\b" | grep -v "BannerAdView" | grep -v "import" | grep -v "UIView" | grep -v "adView\b" | grep -v "//.*AdView"'

check "AdViewDelegate" \
  'swift0 | xargs -0 grep -sn "\bAdViewDelegate\b" | grep -v "BannerAdViewDelegate"'

check "Old banner delegate selectors" \
  'swift0 | xargs -0 grep -sn "adViewDidLoad\|adViewDidFailLoading\|adViewDidClick" | grep -v "bannerAdView"'

# Step 8 checks
check "NativeAdImageLoadingObserver / addImageLoadingObserver" \
  'swift0 | xargs -0 grep -sn "NativeAdImageLoadingObserver\|addImageLoadingObserver"'

check "bind(toSliderView" \
  'swift0 | xargs -0 grep -sn "bind(toSliderView"'

check "VideoController / VideoDelegate" \
  'swift0 | xargs -0 grep -sn "\bVideoController\b\|\bVideoDelegate\b"'

check "NativeTemplateAppearance / NativeBannerView" \
  'swift0 | xargs -0 grep -sn "NativeTemplateAppearance\|NativeBannerView"'

check "kYMA error domains" \
  'swift0 | xargs -0 grep -sn "kYMAAdsErrorDomain\|kYMANativeAdErrorDomain"'

check "Deleted error code enums" \
  'swift0 | xargs -0 grep -sn "\bAdErrorCode\b\|\bNativeErrorCode\b"'

check "Deleted Version properties" \
  'swift0 | xargs -0 grep -sn "\.prereleaseIdentifiers\|\.buildMetadataIdentifiers"'

check "NativeVideoPlaybackProgressControl.reset" \
  'swift0 | xargs -0 grep -sn "NativeVideoPlaybackProgressControl\.reset"'

check "mediationNetworkName" \
  'swift0 | xargs -0 grep -sn "mediationNetworkName"'

if [[ "$FAILED" -ne 0 ]]; then
  echo ""
  echo "Verification failed. Fix matches above."
  exit 1
fi

echo ""
echo "OK: no forbidden patterns found."
echo "Also confirm: Podfile/Package.swift version ≥ 8.x, @MainActor compliance, and a full build."
exit 0
