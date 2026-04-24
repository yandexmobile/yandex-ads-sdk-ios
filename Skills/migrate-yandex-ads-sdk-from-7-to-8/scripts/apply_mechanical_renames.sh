#!/usr/bin/env bash
# Mechanical renames from steps/03_mechanical_renames.md.
# Review .info → .adInfo.extraData after run.
set -euo pipefail
PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

tmp="$(mktemp)"
find . -name "*.swift" -not -path "*/Pods/*" -not -path "*/.build/*" -not -path "*/DerivedData/*" >"$tmp"
trap 'rm -f "$tmp"' EXIT

run_perl() {
  xargs perl -pi -e "$1" <"$tmp"
}

# 3.1 MobileAds → YandexAds (Yandex SDK only: skip OtherModule.MobileAds.* e.g. GoogleMobileAds.MobileAds)
run_perl 's/\bMobileAds\.initialize\(\)/YandexAds.initializeSDK(completionHandler: nil)/g'
run_perl 's/\bMobileAds\.sdkVersion\b/YandexAds.sdkVersion.stringValue/g'
run_perl 's/\bMobileAds\.setLocationTrackingEnabled\(/YandexAds.setLocationTracking(/g'
run_perl 's/\bMobileAds\.setAgeRestrictedUser\(/YandexAds.setAgeRestricted(/g'
run_perl 's/\bMobileAds\.setUserConsent\(/YandexAds.setUserConsent(/g'
run_perl 's/\bMobileAds\.audioSessionManager\(\)/YandexAds.audioSessionManager/g'
run_perl 's/(?<!\.)\bMobileAds\./YandexAds./g unless /import YandexMobileAds/'
run_perl 's/YandexAds\.initializeSDK\(\s*\)/YandexAds.initializeSDK(completionHandler: nil)/g'
run_perl 's/\bYMANativeAdView\b/NativeAdView/g'
run_perl 's/\bYMANativeMediaView\b/NativeMediaView/g'

# 3.2 Targeting
run_perl 's/\bAdTargetInfo\b/AdTargeting/g'
run_perl 's/\.targetInfo\b/.targeting/g'
run_perl 's/\bkYMAGenderFemale\b/Gender.female/g'
run_perl 's/\bkYMAGenderMale\b/Gender.male/g'

# 3.3 BannerAdSize
run_perl 's/BannerAdSize\.fixedSize\(withWidth:/BannerAdSize.fixed(width:/g'
run_perl 's/BannerAdSize\.inlineSize\(withWidth:/BannerAdSize.inline(width:/g'
run_perl 's/BannerAdSize\.stickySize\(withContainerWidth:/BannerAdSize.sticky(containerWidth:/g'

# 3.4 BidderTokenRequest
run_perl 's/\bBidderTokenRequestConfiguration\b/BidderTokenRequest/g'
run_perl 's/loadBidderToken\(requestConfiguration:/loadBidderToken(request:/g'

# 3.5 BidderTokenLoader
run_perl 's/BidderTokenLoader\(mediationNetworkName:[^)]*\)/BidderTokenLoader()/g'

# 3.6 AdInfo / properties
run_perl 's/\.adUnitId\b/.adUnitID/g'
run_perl 's/\bAdInfo\.data\b/AdInfo.extraData/g'
run_perl 's/\bAdRequestError\.adUnitId\b/AdRequestError.adUnitID/g'
run_perl 's/\.adAttributes\b/.adInfo.creatives/g'
run_perl 's/\.info\b/.adInfo.extraData/g unless /adInfo|\.info\s*[{(]|UIView|print|log|debug|Info\./i'

# 3.7 Delegates
run_perl 's/didFailToShowWithError/didFailToShow/g'
run_perl 's/didTrackImpressionWith\b/didTrackImpression/g'

# 3.8 Rating
run_perl 's/Rating\.setRating\(([^)]*)\)/Rating.rating = $1/g'
run_perl 's/Rating\.rating\(\)/Rating.rating/g'

# 3.9 AdRequest class names (longest first)
run_perl 's/\bMutableNativeAdRequestConfiguration\b/AdRequest/g'
run_perl 's/\bMutableAdRequestConfiguration\b/AdRequest/g'
run_perl 's/\bNativeAdRequestConfiguration\b/AdRequest/g'
run_perl 's/\bAdRequestConfiguration\b/AdRequest/g'
run_perl 's/\bMutableAdRequest\b/AdRequest/g'

# 3.10 AdMob extra assets
while IFS= read -r f; do
  [[ -f "$f" ]] || continue
  perl -pi -e '
    s/kYMAAdMobNativeAdAgeExtraAsset/YandexAdMobNativeAdExtraAssets.age/g;
    s/kYMAAdMobNativeAdFaviconExtraAsset/YandexAdMobNativeAdExtraAssets.favicon/g;
    s/kYMAAdMobNativeAdReviewCountExtraAsset/YandexAdMobNativeAdExtraAssets.reviewCount/g;
    s/kYMAAdMobNativeAdWarningExtraAsset/YandexAdMobNativeAdExtraAssets.warning/g;
  ' "$f"
done <"$tmp"

# 3.11 Manual: show deleted constants and types
echo "=== Manual review (3.11): remove or replace deleted constants and types ==="
echo "--- Deleted error domain constants:"
xargs grep -sn "kYMAAdsErrorDomain\|kYMANativeAdErrorDomain\|isYandexMobileAdsError\|isYandexMobileNativeAdsError" <"$tmp" 2>/dev/null || true
echo "--- Deleted error code enums:"
xargs grep -sn "\bAdErrorCode\b\|\bNativeErrorCode\b" <"$tmp" 2>/dev/null || true
echo "--- Deleted Version properties:"
xargs grep -sn "\.prereleaseIdentifiers\|\.buildMetadataIdentifiers" <"$tmp" 2>/dev/null || true
echo "--- Deleted AdInfo.adSize:"
xargs grep -sn "\.adInfo\.adSize\b" <"$tmp" 2>/dev/null || true

echo "Mechanical pass done. Spot-check .info → .adInfo.extraData and run verify_mechanical_renames.sh."
