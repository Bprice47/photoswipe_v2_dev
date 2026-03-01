# PhotoSwipe - Product Requirements Document

## Overview
PhotoSwipe is a Flutter mobile app that allows users to clean their photo gallery using a Tinder-like swipe interface. Swipe right to keep, swipe left to add to "DumpBox" for review before permanent deletion.

## Target Platforms
- iOS (primary)
- Android (secondary)

## Core Features

### 1. Photo Swiping Interface
- Tinder-style card swipe UI
- Swipe RIGHT = Keep photo (marked as reviewed)
- Swipe LEFT = Add to DumpBox (marked as reviewed)
- Undo functionality to go back

### 2. Category/Filter Options
| Category | Behavior | Sort Order |
|----------|----------|------------|
| Most Recent | Skip reviewed photos | Newest first |
| All Photos | Show ALL photos (including reviewed) | Newest first |
| Oldest | Skip reviewed photos | Oldest first |
| Videos | Skip reviewed videos | Newest first |
| Custom Date Range | Show ALL in range | Oldest first (start date forward) |
| Resume Last Session | Skip reviewed photos | Newest first |

### 3. DumpBox
- Holds photos marked for deletion (swiped left)
- **Capped at 30 photos**
- When full: Shows prompt to review and delete
- Non-subscribers see ad placeholder
- Subscribers: Just the prompt (no ad)

### 4. Memory Management
- Maximum 1000 photos loaded at once
- **Auto-load**: When ~100 photos remaining, automatically loads next 1000
- Seamless infinite scroll experience

### 5. Review Tracking
- ALL swipes (left AND right) mark photo as "reviewed"
- `reviewedPhotoIds` stored in SharedPreferences
- Enables "Most Recent" to skip already-seen photos

---

## What's Been Implemented (as of Dec 2025)

### Session 1 - Crash Fix
- [x] Limited photo loading to 1000 to prevent memory crash
- [x] Added `maxPhotosToLoad = 1000` constant

### Session 2 - Feature Enhancements
- [x] **Mark ALL swipes as reviewed** (both left and right)
- [x] **Custom Date Range sorting** - now sorts oldest first (start date forward)
- [x] **Auto-load functionality** - loads next 1000 when ~100 remaining
- [x] **New filter type: "All Photos"** - shows everything regardless of review status
- [x] **Segmented toggle UI** - "Most Recent" | "All Photos" with help (?) icon
- [x] **Help dialog** explaining difference between Most Recent and All Photos
- [x] **DumpBox cap at 30** with prompt dialog
- [x] **Subscriber flag placeholder** (`isSubscriber`)
- [x] **Ad placeholder** for non-subscribers when DumpBox full
- [x] **Updated progress indicator** - shows "Photo X of Y" with auto-load status
- [x] Most Recent, Oldest, Videos now skip reviewed photos
- [x] All Photos and Date Range show ALL photos

---

## Upcoming Tasks (P0/P1)

### P0 - Critical
- [ ] Update tutorial/onboarding to explain:
  - "Most Recent" = only unreviewed photos
  - "All Photos" = start fresh (except deleted ones)

### P1 - Important
- [ ] Implement actual ad integration (AdMob or similar)
- [ ] Implement subscription system
- [ ] Polish UI for better user experience

### P2 - Future
- [ ] Add onboarding tutorial for new users
- [ ] Prepare for App Store submission
- [ ] Consider "Pro" version features

---

## Technical Architecture

```
/lib/
├── main.dart                    # App entry point
├── app.dart                     # App widget with providers
├── config/
│   ├── constants.dart           # App constants (MODIFIED)
│   ├── routes.dart              # Navigation routes
│   └── theme.dart               # App theming
├── models/
│   ├── photo_model.dart         # Photo data model
│   └── session_model.dart       # Session tracking
├── providers/
│   ├── photo_provider.dart      # Photo state management (MODIFIED)
│   ├── dumpbox_provider.dart    # DumpBox state (MODIFIED)
│   └── session_provider.dart    # Session management
├── screens/
│   ├── category_screen.dart     # Main menu (MODIFIED - segmented toggle)
│   ├── swipe_screen.dart        # Swiping UI (MODIFIED - dumpbox cap)
│   ├── dumpbox_screen.dart      # Review before delete
│   ├── date_range_screen.dart   # Custom date picker
│   └── ...
├── services/
│   ├── photo_service.dart       # Photo loading service
│   ├── permission_service.dart  # Permission handling
│   └── storage_service.dart     # Local storage
└── widgets/
    └── ...                      # Reusable UI components
```

## Key Constants
```dart
maxPhotosToLoad = 1000       // Photos per batch
maxDumpBoxPhotos = 30        // DumpBox capacity before prompt
photosPerPage = 500          // For pagination
thumbnailSize = 800          // Thumbnail quality
```

## Dependencies
- `photo_manager` - Access device photos
- `permission_handler` - Request permissions
- `flutter_card_swiper` - Swipe card UI
- `provider` - State management
- `shared_preferences` - Local storage
- `hive` / `hive_flutter` - Additional local storage

---

## Known Issues
1. Deprecated iOS API warnings in plugins (non-blocking)
2. Need to test auto-load behavior with 8000+ photos
