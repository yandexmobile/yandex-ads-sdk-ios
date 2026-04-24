# General Rules

> **Every step file MUST reference this document at the top.**
> Read and internalize these rules before executing any step.

## 1. Do NOT Invent API Names

Never guess or fabricate class names, method signatures, or property names that are not explicitly listed in the step files. If a pattern is not covered — ask the user.

## 2. Do NOT Modify `import YandexMobileAds`

The module name remains `YandexMobileAds`. Only the **Yandex** entry point `MobileAds` (unqualified or from `YandexMobileAds`) is renamed to `YandexAds`. Never change import statements.

**Third-party SDKs**: Other modules may expose their own `MobileAds` type (e.g. `GoogleMobileAds.MobileAds`). The mechanical script **must not** rewrite those — only **unqualified** `MobileAds.` (not preceded by `.`). If another framework uses a delegate name that substring-matches a removed Yandex loader delegate, extend `run_final_verification.sh` with an extra `grep -v` for that framework’s module prefix.

## 3. Preserve Existing Logic

Use code examples in step files as **reference patterns only**. Adapt them to the actual logic, context, and environment of the code being changed. Do not blindly copy-paste examples.

## 4. Name Conflicts

If a rename introduces a name conflict with a project-local type, resolve it by using the fully qualified module name: `YandexMobileAds.TypeName`.

## 5. Objective-C translation

If processed files are Objective-C (`.m`, `.h`) or mixed files, warn the user that this guide is Swift-only and apply these translation rules:

Objective-C classes use the `YMA` prefix. Always check the actual prefix for each class:
- Swift `YandexAds` → ObjC `YMAYandexAds`
- Swift `AdRequest` → ObjC `YMAAdRequest`
- Swift `BannerAdView` → ObjC `YMABannerAdView`

**CRITICAL**: Objective-C selectors often differ from Swift method names. The Swift-to-ObjC name mapping is not always predictable. **Always verify the actual selector** in the SDK's Objective-C header files (`<YandexMobileAds/*.h>`) or generated Swift interface before applying changes. Do not assume a 1:1 name translation.

`async/await` is not available in Objective-C. Always use the completion handler (block) variant.

Swift enum cases use dot syntax; ObjC uses class methods or constants:
- Swift `Gender.male` → ObjC `[YMAGender male]`


Swift closures translate to Objective-C blocks:
- Swift `{ [weak self] result in ... }` → ObjC `^(YMAResult *result) { ... }`

## 6. Context Management

1. Read only the **current step file**. Do not load all steps at once.
2. Only read project files identified in Step 1 as needing migration.
3. If you have processed more than 3 project files since last reading the step file — re-read it to prevent drift.
4. You can unload already completed step docs if facing context window shortage.

## 7. Execution Discipline

1. **Do NOT skip any step.**
2. **Do NOT change the order of steps.**
3. **Do NOT stop mid-migration** — proceed to the end.
4. **Do NOT generate `.md` log files** unless explicitly asked.
5. **Never partially apply a step** — if a step has multiple changes, apply ALL of them to each file.
6. If uncertain about a specific change — ask the user before proceeding.

## 9. Choosing Between Completion Handler And Async/Await

**Default: use completion handler**. It is the safest choice that works in all contexts.

Use async/await ONLY when:
1. The file is Swift (not Objective-C)
2. The method containing the `loadAd` call is already marked `async`, OR the call site is already inside a `Task { }`

If unsure, use completion handler. Do NOT introduce `Task { }` wrappers just to use async/await.

**CRITICAL**: Be consistent within a single file. Do not mix completion and async styles for different loaders in the same file.

## 10. Step Verification

Every step ends with a **Verification** section. You MUST run all verification checks before moving to the next step. If any check fails — fix the issue before proceeding.

## 11. Iterative Compilation
**After completing all migration steps**, you MUST perform **iterative project compilation** until all compilation errors are eliminated. 
See [`final_verification.md`](final_verification.md) for the complete compilation process.
**DO NOT** mark the migration as complete until the project builds successfully without errors.
