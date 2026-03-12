# PhotoSwipe Changelog

## Version History & Progress Notes

---

### v1.6 - Performance Optimization & Cleanup (December 2025)
**Status: IN TESTING**

**Fixed:**
- [x] **MAJOR PERFORMANCE FIX**: App now uses true pagination - only loads 200 photos at a time instead of all 10,000+
- [x] **Removed "Resume Last Session"** - redundant feature (Most Recent already skips reviewed photos)
- [x] Loading time should now be consistent regardless of library size

**How it works now:**
- Instead of fetching ALL 10,000+ photo references upfront, we now:
  1. Fetch photos in batches of 200
  2. Filter each batch (skip reviewed, apply date filters)
  3. Stop when we have enough photos (20 for testing, 1000 for production)
- This means: 10,000 photos or 100 photos = same fast load time!

**Technical changes:**
- `photo_provider.dart`: Complete rewrite of `loadPhotos()` with true pagination
- `constants.dart`: Removed `FilterType.resume` enum value
- `category_screen.dart`: Removed Resume Last Session menu item
- `session_model.dart`: Removed resume case from switch statement

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
