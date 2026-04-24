# Step 4: Migrate `AdRequest` Usage

> **First, read [`../general_rules.md`](../general_rules.md).**

> **Note**: The mechanical class renames (`AdRequestConfiguration` → `AdRequest`, etc.) were already performed in Step 3. This step handles the **logical changes** that require AI review.

## What Changed

In SDK 8, `AdRequest` replaces all previous request classes. The `adUnitID` is now a required initializer parameter.

**CRITICAL**: `AdRequest` in SDK 8 is **immutable**. All properties (`parameters`, `targeting`, `biddingData`, etc.) are `let` constants and MUST be passed via the initializer. Post-construction assignment like `request.parameters = ...` will NOT compile.

Key differences:
- `MutableAdRequest()` (no parameters) → `AdRequest(adUnitID:)` — the `adUnitID` must now be provided at construction time
- `MutableAdRequestConfiguration(adUnitID:)` had mutable properties (e.g., `parameters`) that were set after construction — in SDK 8, **all properties must be passed to the initializer**
- Targeting fields (`age`, `gender`, `location`, `contextQuery`, `contextTags`) have been moved from `AdRequest` to `AdTargeting` (see Step 3 for targeting changes)

## What to Review

After the mechanical renames in Step 3, review each file for:

1. **`AdRequest()` with no arguments** — these were `MutableAdRequest()` calls. They now need an `adUnitID:` parameter. Find where the `adUnitID` was set separately and move it into the initializer.

2. **Mutable property assignments** — if the old code set properties on a mutable request after construction (e.g., `request.parameters = [...]`), these MUST be moved to the initializer. Pattern to find and fix:
   ```swift
   // SDK 8 — will NOT compile
   let request = AdRequest(adUnitID: "R-M-XXXXX-YY")
   request.parameters = ["key": "value"]  // ERROR: 'parameters' is a 'let' constant
   
   // SDK 8 — correct
   let request = AdRequest(adUnitID: "R-M-XXXXX-YY", parameters: ["key": "value"])
   ```

3. **`AdRequest` used with `loadAd`** — the `loadAd` method signature has changed (see Step 5). Ensure the request is passed correctly.

## Common Patterns

### Pattern 1: `parameters` assignment

```swift
// SDK 7
let request = MutableAdRequest()
request.adUnitID = "R-M-XXXXX-YY"
request.parameters = ["key": "value"]
bannerAdView.loadAd(with: request)

// SDK 8
let request = AdRequest(adUnitID: "R-M-XXXXX-YY", parameters: ["key": "value"])
bannerAdView.loadAd(with: request)
```

### Pattern 2: `biddingData` assignment

```swift
// SDK 7
let request = MutableAdRequestConfiguration(adUnitID: "R-M-XXXXX-YY")
request.biddingData = biddingData

// SDK 8
let request = AdRequest(adUnitID: "R-M-XXXXX-YY", biddingData: biddingData)
```

### Pattern 3: Multiple properties

```swift
// SDK 7
let request = MutableAdRequestConfiguration(adUnitID: "R-M-XXXXX-YY")
request.parameters = ["key": "value"]
request.biddingData = biddingData
let targeting = AdTargeting()
targeting.age = 25
request.targeting = targeting

// SDK 8 
let targeting = AdTargeting(
    age: 25,
    gender: .male,
    location: location
)

let request = AdRequest(
    adUnitID: "R-M-XXXXX-YY",
    targeting: targeting,
    parameters: ["key": "value"],
    biddingData: biddingData
)
```

## Verification

```bash
swift0() { find . -name "*.swift" -not -path "*/Pods/*" -not -path "*/.build/*" -not -path "*/DerivedData/*" -print0; }

echo "1. Old request classes (should be empty — handled in Step 3):"
swift0 | xargs -0 grep -sn "AdRequestConfiguration\|NativeAdRequestConfiguration\|MutableAdRequest\|MutableAdRequestConfiguration\|MutableNativeAdRequestConfiguration" || echo "  ✓ OK"

echo "2. AdRequest() with no arguments (needs adUnitID):"
swift0 | xargs -0 grep -sn "AdRequest()" || echo "  ✓ OK — no parameterless constructors"

echo "3. Property assignments on AdRequest (should be empty):"
swift0 | xargs -0 grep -sn "request\.parameters\s*=" || echo "  ✓ OK"
swift0 | xargs -0 grep -sn "request\.biddingData\s*=" || echo "  ✓ OK"
swift0 | xargs -0 grep -sn "request\.targeting\s*=" || echo "  ✓ OK"
```

- [ ] No old request class names remain (confirmed in Step 3)
- [ ] No `AdRequest()` calls without `adUnitID:` parameter
- [ ] No property assignments on `AdRequest` instances (all properties passed via initializer)
- [ ] All `parameters`, `biddingData`, `targeting` are passed to `AdRequest` initializer
