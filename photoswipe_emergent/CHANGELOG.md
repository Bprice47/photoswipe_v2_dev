# PhotoSwipe Changelog

## Version History & Progress Notes

---

### v1.6 - Performance Optimization & Cleanup (December 2025)
**Status: IN TESTING**

**Fixed:**
- [x] **Major performance fix**: App now loads much faster when returning after taking new photos
- [x] Implemented incremental photo loading - only fetches NEW photos since last load
- [x] Added persistent cache metadata using SharedPreferences
- [x] Preserved in-memory asset cache across filter switches
- [x] **Fixed video loading** - cache now properly invalidates when switching between photos and videos
- [x] **Removed "Resume Last Session"** - redundant feature (Most Recent already skips reviewed photos)

**How it works:**
- First launch: Full fetch of all photos (one-time)
- Subsequent launches: Checks photo count, only fetches new photos (< 100 new = incremental load)
- Filter switches: Reuses cached assets, just re-filters and re-sorts
- Videos: Separate cache for video count, properly switches between photo/video mode

**Technical changes:**
- `photo_provider.dart`: Added `_cachedFilterType` to track photo vs video cache
- `constants.dart`: Removed `FilterType.resume` enum value
- `category_screen.dart`: Removed Resume Last Session menu item

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
