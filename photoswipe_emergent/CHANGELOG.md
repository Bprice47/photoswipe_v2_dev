# PhotoSwipe Changelog

## Version History & Progress Notes

---

### v1.4 - Auto-Load & DumpBox Cap (March 6, 2026)
**Status: TESTING**

**New Features:**
- [x] Auto-load next batch when ~5 photos remaining
- [x] Progress indicator shows "Photo X of Y (Z total)"
- [x] Loading indicator when fetching more photos
- [x] DumpBox capped at 30 photos
- [x] "DumpBox Full" dialog with prompt to review
- [x] Ad placeholder for non-subscribers
- [x] Subscriber flag placeholder for future use

**Settings (for testing):**
- `maxPhotosToLoad = 20` (change to 1000 for production)
- `autoLoadThreshold = 5` (change to 100 for production)
- `maxDumpBoxPhotos = 30`

**Files Modified:**
- `lib/config/constants.dart` - Added autoLoadThreshold, maxDumpBoxPhotos
- `lib/providers/photo_provider.dart` - Auto-load logic
- `lib/providers/dumpbox_provider.dart` - Cap at 30, isFull check
- `lib/screens/swipe_screen.dart` - Progress indicator, dumpbox full dialog

---

### v1.3 - Resume Session Fix (Feb 5, 2026)
**Status: STABLE**

- Fixed resume session functionality
- Photos properly marked as reviewed
- Session persistence working

---

### v1.2 - Legal & Menu Update
**Status: STABLE**

- Added terms of service
- Menu improvements
- Bug fixes

---

### v1.1 - 1000 Photo Limit Fix
**Status: STABLE - CRITICAL FIX**

- Added `maxPhotosToLoad = 1000` to prevent memory crash
- App no longer crashes with large photo libraries (8000+ photos)

---

### v1.0 - MVP Complete
**Status: STABLE**

- Tinder-style swipe interface
- Keep (right) / Delete (left) functionality
- DumpBox for reviewing before permanent deletion
- Category filters (Most Recent, Oldest, Videos, Date Range, Resume)
- Permission handling
- Local storage for session persistence

---

## Upcoming Features (TODO)

- [ ] Most Recent / All Photos toggle with segmented control
- [ ] Help (?) icon explaining filter differences
- [ ] Update tutorial with filter explanations
- [ ] Actual ad integration (AdMob)
- [ ] Subscription system
- [ ] App Store submission

---

## Production Settings Reminder

Before releasing, update `lib/config/constants.dart`:
```dart
static const int maxPhotosToLoad = 1000;    // Currently 20 for testing
static const int autoLoadThreshold = 100;   // Currently 5 for testing
```
