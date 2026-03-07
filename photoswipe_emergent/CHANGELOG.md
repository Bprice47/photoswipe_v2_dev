# PhotoSwipe Changelog

## Version History & Progress Notes

---

### v1.5 - Oldest Filter Fix + Date Picker UI + Permission Fix (March 6, 2026)
**Status: STABLE**

**Fixed:**
- [x] "Oldest" now shows ALL photos including previously reviewed ones
- [x] You can now see your actual oldest photo in the library
- [x] Date Range picker now uses iOS wheel-style interface
- [x] Date Range shows photos oldest → newest (start date forward)
- [x] Start date picker defaults to oldest photo in library
- [x] End date picker defaults to selected start date
- [x] Added "Clear Dates" button
- [x] Shows "Oldest photo: [date]" hint
- [x] **Permission popup now shows** - app goes to permission screen after welcome

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
