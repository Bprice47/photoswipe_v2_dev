# PhotoSwipe Changelog

## Version History & Progress Notes

---

### v1.6 - Performance Optimization & Cleanup (December 2025)
**Status: IN TESTING**

**Fixed:**
- [x] **Warm resume optimization using WidgetsBindingObserver**
- [x] App now listens for `AppLifecycleState.resumed` to detect when returning from background
- [x] **ID comparison instead of count** - compares first photo ID to detect changes reliably
- [x] Handles edge case: user deletes 5 photos + takes 5 new = count same but photos different
- [x] **Removed "Resume Last Session"** - redundant (Most Recent already skips reviewed)

**How it works now:**
- `PhotoProvider` extends `WidgetsBindingObserver` to detect app resume
- On warm resume: compares newest photo ID in cache vs OS
- If same: use cache (instant!)
- If different: fetch only new photos and prepend (fast!)
- If major change (deletions/200+): full reload

**Technical changes:**
- `photo_provider.dart`: Added `WidgetsBindingObserver` mixin
- Added `didChangeAppLifecycleState()` to detect resume
- Added `_checkForNewPhotos()` for background update check
- Cached `AssetPathEntity` reference for quick resume checks
- ID comparison for reliable change detection

---

### v1.5 - Oldest Filter Fix + Date Picker UI (March 6, 2026)
**Status: STABLE ✅ BACKUP VERSION**

**Fixed:**
- [x] "Oldest" now shows ALL photos including previously reviewed ones
- [x] Date Range picker now uses iOS wheel-style interface  
- [x] Start date picker defaults to oldest photo in library
- [x] End date picker defaults to selected start date
- [x] Date Range shows photos oldest → newest (start date forward)
- [x] Added "Clear Dates" button
- [x] Permission flow works correctly (iOS shows popup once, app handles it)
- [x] Smart permission check - skips permission screen if already granted

**What's Working:**
- Most Recent (skips reviewed photos)
- All Photos (shows everything)
- Oldest (shows everything, oldest first) ✅ FIXED
- Videos (skips reviewed)
- Date Range (shows everything in range)
- Resume (skips reviewed)
- 1000 photo limit (prevents crash)

**Test Settings:**
- `maxPhotosToLoad = 1000`

---

### v1.4 - 1000 Photo Limit Fix
**Status: STABLE - CRITICAL FIX**

- Added `maxPhotosToLoad = 1000` to prevent memory crash
- App no longer crashes with large photo libraries (8000+ photos)

---

### v1.3 - Resume Session Fix
**Status: STABLE**

- Fixed resume session functionality
- Photos properly marked as reviewed
- Session persistence working

---

## TODO (Future Sessions)

- [ ] Auto-load next batch when near end (was working, needs clean implementation)
- [ ] Progress counter "Photo X of Y" 
- [ ] DumpBox cap at 30 photos
- [ ] "DumpBox Full" dialog with review prompt
- [ ] Most Recent / All Photos toggle with segmented control
- [ ] Help (?) icon explaining filter differences
- [ ] Tutorial updates

---

## Production Settings

Current settings in `lib/config/constants.dart`:
```dart
static const int maxPhotosToLoad = 1000;
```
