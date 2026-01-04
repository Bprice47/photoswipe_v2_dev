# PhotoSwipe - Product Requirements Document (PRD)

**Version:** 1.0  
**Created:** August 2025  
**App Name:** PhotoSwipe  
**Tagline:** A Tinder-style gallery cleaner  
**Platforms:** iOS & Android (Flutter / React Native)

---

## 📋 Table of Contents

1. [Executive Summary](#executive-summary)
2. [Core Concept](#core-concept)
3. [User Flow](#user-flow)
4. [Screen Specifications](#screen-specifications)
5. [Design System](#design-system)
6. [Technical Architecture](#technical-architecture)
7. [iOS 14+ Compliance](#ios-14-compliance)
8. [Data Models](#data-models)
9. [Dependencies](#dependencies)
10. [Screenshot References](#screenshot-references)

---

## 🎯 Executive Summary

PhotoSwipe is a mobile application that helps users clean their photo gallery using a familiar Tinder-style swipe interface. Users can quickly review photos and decide to **Keep** (swipe right) or **Delete** (swipe left) them. The app emphasizes privacy - all processing happens on-device, and no photos are uploaded or stored externally.

### Key Features
- Swipe right to **Keep**, swipe left to **Delete**
- Filter photos by date range, recency, or type (videos)
- DumpBox: Review deleted photos before permanent deletion
- Resume last session capability
- Full iOS 14+ photo library permission compliance

---

## 🎮 Core Concept

### Core Action
| Gesture | Action | Visual Indicator |
|---------|--------|------------------|
| Swipe Left | Mark for Deletion → Goes to DumpBox | RED background/trash icon |
| Swipe Right | Keep photo in library | GREEN background/heart icon |
| Tap Delete Button | Same as swipe left | RED button with arrow |
| Tap Keep Button | Same as swipe right | GREEN button with arrow |

### Philosophy
- **Privacy First**: No cloud uploads, all processing on-device
- **Speed**: Quick decisions with minimal friction
- **Safety Net**: DumpBox allows review before permanent deletion
- **Flexibility**: Multiple ways to filter and organize review sessions

---

## 🔄 User Flow

```
┌─────────────────┐
│  App Launch     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│ Welcome Screen  │────▶│ First Time User │
│ (Privacy Terms) │     │ Show Disclaimer │
└────────┬────────┘     └─────────────────┘
         │ Checkbox + Continue
         ▼
┌─────────────────┐     ┌─────────────────┐
│ Permission      │────▶│ iOS System      │
│ Screen          │     │ Permission      │
└────────┬────────┘     │ Dialog          │
         │              └─────────────────┘
         ▼
┌─────────────────┐
│ Category Screen │
│ (Main Menu)     │
└────────┬────────┘
         │
    ┌────┴────┬──────────┬──────────┬─────────────┐
    ▼         ▼          ▼          ▼             ▼
┌───────┐ ┌───────┐ ┌─────────┐ ┌───────────┐ ┌─────────┐
│Most   │ │Oldest │ │Videos   │ │Custom Date│ │Resume   │
│Recent │ │       │ │Only     │ │Range      │ │Session  │
└───┬───┘ └───┬───┘ └────┬────┘ └─────┬─────┘ └────┬────┘
    │         │          │            │            │
    │         │          │            ▼            │
    │         │          │     ┌───────────┐       │
    │         │          │     │Date Range │       │
    │         │          │     │Screen     │       │
    │         │          │     └─────┬─────┘       │
    └─────────┴──────────┴───────────┴─────────────┘
                         │
                         ▼
              ┌─────────────────┐
              │  Swipe Screen   │◀──────────────┐
              │  (Main Review)  │               │
              └────────┬────────┘               │
                       │                        │
           ┌───────────┴───────────┐            │
           ▼                       ▼            │
    ┌─────────────┐         ┌─────────────┐     │
    │ Swipe Left  │         │ Swipe Right │     │
    │ (Delete)    │         │ (Keep)      │     │
    └──────┬──────┘         └──────┬──────┘     │
           │                       │            │
           ▼                       │            │
    ┌─────────────┐                │            │
    │ Add to      │                │            │
    │ DumpBox     │                │            │
    └──────┬──────┘                │            │
           │                       │            │
           └───────────┬───────────┘            │
                       ▼                        │
              ┌─────────────────┐               │
              │ Next Photo      │───────────────┘
              │ (if remaining)  │
              └────────┬────────┘
                       │ (if no photos left)
                       ▼
              ┌─────────────────┐
              │ Empty State     │
              │ "Good Job!"     │
              └─────────────────┘

              ┌─────────────────┐
              │ DumpBox Screen  │ (Accessible from header)
              │ (Review Deleted)│
              └────────┬────────┘
                       │
           ┌───────────┴───────────┐
           ▼                       ▼
    ┌─────────────┐         ┌─────────────┐
    │ Delete      │         │ Keep        │
    │ Selected    │         │ Selected    │
    └──────┬──────┘         └─────────────┘
           │
           ▼
    ┌─────────────┐
    │ Confirmation│
    │ Modal       │
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │ Permanent   │
    │ Deletion    │
    └─────────────┘
```

---

## 📱 Screen Specifications

### Screen 1: Welcome Screen (Privacy & Disclaimer)

**Purpose:** First-time user onboarding with privacy disclosure and consent

**Layout:**
```
┌────────────────────────────────────────┐
│            [Status Bar]                │
├────────────────────────────────────────┤
│                                        │
│         ┌──────────────────┐           │
│         │   📷 LOGO        │           │
│         │   (Blue icon)    │           │
│         └──────────────────┘           │
│                                        │
│            Welcome to                  │
│           PhotoSwipe                   │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │     Privacy & Disclaimer         │  │
│  │                                  │  │
│  │  • We do NOT save, store, or    │  │
│  │    use your photos for any      │  │
│  │    reason                       │  │
│  │                                  │  │
│  │  • We only access your photos   │  │
│  │    so you can review and        │  │
│  │    delete them                  │  │
│  │                                  │  │
│  │  • All photo processing happens │  │
│  │    on YOUR device               │  │
│  │                                  │  │
│  │  • We are NOT liable for any    │  │
│  │    photos you choose to delete  │  │
│  │                                  │  │
│  │  • Deletions are permanent and  │  │
│  │    cannot be recovered          │  │
│  │                                  │  │
│  │  • On iOS, deleted photos       │  │
│  │    remain in Recently Deleted   │  │
│  │    for 30 days                  │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │ ☐  I understand and agree to    │  │
│  │    these terms                   │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │          Continue                │  │
│  │    (Disabled until checked)      │  │
│  └──────────────────────────────────┘  │
│                                        │
└────────────────────────────────────────┘
```

**Specifications:**
| Element | Specification |
|---------|---------------|
| Logo | Blue rounded square with mountain/photo icon |
| Title Font | Bold, White, ~28sp |
| Card Background | Dark Gray (#1C1C1E or #282828) |
| Card Border Radius | 16px |
| Bullet Points | White/Light Gray text, ~14sp |
| Checkbox | Square outline, white border |
| Continue Button (Disabled) | Dark gray background, muted text |
| Continue Button (Enabled) | Blue background (#2196F3), white text |

**Behavior:**
- Continue button disabled by default
- Checkbox toggles Continue button state
- On Continue → Navigate to Permission Screen

---

### Screen 2: Permission Screen (Photo Access Required)

**Purpose:** Request photo library access from user

**Layout:**
```
┌────────────────────────────────────────┐
│            [Status Bar]                │
├────────────────────────────────────────┤
│                                        │
│                                        │
│                                        │
│         ┌──────────────────┐           │
│         │   📷 LOGO        │           │
│         │   (Blue icon)    │           │
│         └──────────────────┘           │
│                                        │
│           Photo Access                 │
│             Required                   │
│                                        │
│      PhotoSwipe needs access to        │
│      your photo library to help        │
│      you review and delete photos.     │
│                                        │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │         Grant Access             │  │
│  │      (Blue button, pink text)    │  │
│  └──────────────────────────────────┘  │
│                                        │
│                                        │
│                                        │
└────────────────────────────────────────┘
```

**Specifications:**
| Element | Specification |
|---------|---------------|
| Logo | Same as Welcome Screen |
| Title "Photo Access" | Bold, White, ~24sp |
| Subtitle "Required" | Bold, White, ~24sp |
| Description | Light gray text, ~16sp, centered |
| Button | Blue background (#2196F3), light pink/lavender text |
| Button Border Radius | 25px (pill shape) |

**Behavior:**
- Tap "Grant Access" → Trigger iOS/Android permission dialog
- Handle three states:
  - **Granted (Full)** → Navigate to Category Screen
  - **Granted (Limited - iOS 14+)** → Navigate to Category Screen (with limited indicator)
  - **Denied** → Show "Go to Settings" option

---

### Screen 3: Category Screen (Main Menu)

**Purpose:** Let user choose how they want to review photos

**Layout:**
```
┌────────────────────────────────────────┐
│            [Status Bar]                │
├────────────────────────────────────────┤
│          Select Category               │
├────────────────────────────────────────┤
│                                        │
│     What would you like to review?     │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │ 🕐  Most Recent              >   │  │
│  │     Start with newest photos     │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │ 🔄  Oldest                   >   │  │
│  │     Start with oldest photos     │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │ 🎬  Videos                   >   │  │
│  │     Review video files only      │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │ 📅  Custom Date Range        >   │  │
│  │     Pick start and end dates     │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │ ▶️  Resume Last Session      >   │  │
│  │     Start where your last        │  │
│  │     dump session ended           │  │
│  └──────────────────────────────────┘  │
│                                        │
└────────────────────────────────────────┘
```

**Specifications:**
| Element | Specification |
|---------|---------------|
| Header "Select Category" | Centered, italic style, ~18sp |
| Question | Bold, White, ~22sp |
| Card Background | Dark Gray (#2C2C2E) |
| Card Border Radius | 12px |
| Icon | Blue (#2196F3), circular background or standalone |
| Title | Bold, White, ~18sp |
| Subtitle | Light Gray, ~14sp |
| Chevron | Gray ">" arrow on right |

**Categories:**
1. **Most Recent** - Fetches photos sorted by newest first
2. **Oldest** - Fetches photos sorted by oldest first
3. **Videos** - Filters to video files only (AssetType.video)
4. **Custom Date Range** - Opens Date Range Screen
5. **Resume Last Session** - Loads saved session state

---

### Screen 4: Date Range Screen

**Purpose:** Allow user to filter photos by date range

**Layout:**
```
┌────────────────────────────────────────┐
│            [Status Bar]                │
├────────────────────────────────────────┤
│  ←       Select Date Range             │
├────────────────────────────────────────┤
│                                        │
│           Filter by Date               │
│                                        │
│  You can choose:                       │
│  • Start date only (from that date     │
│    onward)                             │
│  • End date only (up to that date)     │
│  • Both start and end (between the     │
│    two)                                │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │          Start Date              │  │
│  │          2025-11-18              │  │
│  │          (or "Not set")          │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │           End Date               │  │
│  │           Not set                │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │         Start Review             │  │
│  │         (Blue button)            │  │
│  └──────────────────────────────────┘  │
│                                        │
└────────────────────────────────────────┘
```

**Specifications:**
| Element | Specification |
|---------|---------------|
| Back Arrow | White, left side of header |
| Header Title | Centered, italic style, ~18sp |
| Main Title | Bold, White, ~24sp |
| Instructions | Light gray, ~14sp |
| Date Buttons | Pill-shaped, dark gray with white border |
| Date Label | Bold, White, ~18sp |
| Date Value | Gray when "Not set", White when selected |
| Start Review Button | Blue background, white text, pill-shaped |

**Behavior:**
- Tap date button → Open native date picker
- Date format: YYYY-MM-DD
- Start Review validates at least one date is set

---

### Screen 5: Swipe Screen (Main Review)

**Purpose:** The core swiping interface for photo review

**Layout:**
```
┌────────────────────────────────────────┐
│            [Status Bar]                │
├────────────────────────────────────────┤
│  ≡    PhotoSwipe    [DumpBox (0)]      │
├────────────────────────────────────────┤
│                                        │
│     ↻               ⤢              ✕   │
│  ┌──────────────────────────────────┐  │
│  │                                  │  │
│  │                                  │  │
│  │                                  │  │
│  │         [PHOTO CARD]             │  │
│  │                                  │  │
│  │        (Swipeable area)          │  │
│  │                                  │  │
│  │                                  │  │
│  │                                  │  │
│  │                                  │  │
│  └──────────────────────────────────┘  │
│                                        │
│          10231 remaining               │
│                                        │
│  ┌──────────────┐  ┌──────────────┐    │
│  │ ← Delete     │  │     Keep →   │    │
│  │   (RED)      │  │    (GREEN)   │    │
│  └──────────────┘  └──────────────┘    │
│                                        │
└────────────────────────────────────────┘
```

**Header Elements:**
| Element | Position | Specification |
|---------|----------|---------------|
| Hamburger Menu | Left | Three horizontal lines, white |
| Title "PhotoSwipe" | Center | Bold, White, ~20sp |
| DumpBox Badge | Right | Pink/coral pill, "(0)" count |

**Photo Card Elements:**
| Element | Position | Specification |
|---------|----------|---------------|
| Rotate Left | Top-left of card | Circular arrow icon |
| Expand/Fullscreen | Top-left (next to rotate) | Four arrows outward |
| Close/Skip | Top-right | X icon |
| Photo | Center | Fills card area |

**Bottom Elements:**
| Element | Specification |
|---------|---------------|
| Remaining Count | White text, centered, "X remaining" |
| Delete Button | Red/coral background (#E57373), white arrow + "Delete" |
| Keep Button | Green background (#81C784), white arrow + "Keep" |
| Button Border Radius | 25px (pill shape) |

**Swipe Behavior:**
| Gesture | Threshold | Visual Feedback | Action |
|---------|-----------|-----------------|--------|
| Swipe Left | >100px | Red overlay/icon appears | Add to DumpBox |
| Swipe Right | >100px | Green overlay/icon appears | Keep (no action) |
| Swipe Up | Optional | - | Skip? |
| Tap Delete | - | Button press animation | Add to DumpBox |
| Tap Keep | - | Button press animation | Keep (no action) |

**Card Stack:**
- Show 2-3 cards stacked (current on top)
- Cards underneath slightly scaled down and offset
- Smooth animation when card is swiped away

---

### Screen 6: DumpBox Screen

**Purpose:** Review photos marked for deletion before permanent removal

**Layout:**
```
┌────────────────────────────────────────┐
│            [Status Bar]                │
├────────────────────────────────────────┤
│  <      DumpBox (7)      Restore All   │
├────────────────────────────────────────┤
│                                        │
│  ┌─────┐  ┌─────┐  ┌─────┐            │
│  │ ✓   │  │ ✓   │  │ ✓   │            │
│  │     │  │     │  │     │            │
│  │photo│  │photo│  │photo│            │
│  └─────┘  └─────┘  └─────┘            │
│                                        │
│  ┌─────┐  ┌─────┐  ┌─────┐            │
│  │ ✓   │  │ ✓   │  │ ✓   │            │
│  │     │  │     │  │     │            │
│  │photo│  │photo│  │photo│            │
│  └─────┘  └─────┘  └─────┘            │
│                                        │
│  ┌─────┐                               │
│  │ ✓   │                               │
│  │photo│                               │
│  └─────┘                               │
│                                        │
├────────────────────────────────────────┤
│  ┌──────────────────────────────────┐  │
│  │ ⊞    Clear Selection             │  │
│  └──────────────────────────────────┘  │
│                                        │
│  ┌─────────────┐  ┌─────────────┐      │
│  │ 🗑 Delete   │  │ ✓ Keep      │      │
│  │ Selected(7)│  │ Selected    │      │
│  │   (RED)    │  │   (GREEN)   │      │
│  └─────────────┘  └─────────────┘      │
└────────────────────────────────────────┘
```

**Specifications:**
| Element | Specification |
|---------|---------------|
| Back Arrow | White "<" on left |
| Title | "DumpBox (X)" where X = count |
| Restore All | Purple/magenta text, right side |
| Photo Grid | 3 columns |
| Selected Indicator | Green checkmark circle, top-right of photo |
| Photo Border | Green border when selected (#4CAF50) |
| Clear Selection Button | Outlined pill, white border |
| Delete Selected | Red background, white text + trash icon |
| Keep Selected | Green background, white text + check icon |

**Behavior:**
- Tap photo → Toggle selection
- All photos selected by default when entering
- "Clear Selection" → Deselects all
- "Restore All" → Returns all to main library
- "Delete Selected" → Opens confirmation modal
- "Keep Selected" → Returns selected to library, removes from DumpBox

---

### Screen 7: Delete Confirmation Modal

**Purpose:** Final confirmation before permanent deletion

**Layout:**
```
┌────────────────────────────────────────┐
│                                        │
│      (DumpBox screen dimmed)           │
│                                        │
│  ┌──────────────────────────────────┐  │
│  │                                  │  │
│  │      Delete 7 photos?            │  │
│  │                                  │  │
│  │  This will permanently delete    │  │
│  │  these photos from your device.  │  │
│  │                                  │  │
│  │  On some devices they may first  │  │
│  │  move to "Recently Deleted"      │  │
│  │  for 30 days.                    │  │
│  │                                  │  │
│  │      Cancel         Delete       │  │
│  │      (gray)         (RED)        │  │
│  │                                  │  │
│  └──────────────────────────────────┘  │
│                                        │
└────────────────────────────────────────┘
```

**Specifications:**
| Element | Specification |
|---------|---------------|
| Overlay | Semi-transparent black |
| Modal Background | Dark gray (#2C2C2E) |
| Modal Border Radius | 16px |
| Title | Bold, White, ~20sp |
| Description | Light gray, ~14sp |
| Cancel Button | Gray text |
| Delete Button | Red text (#FF5252) |

**Behavior:**
- Cancel → Close modal
- Delete → Call PhotoManager.deleteWithIds() → iOS will show system confirmation → Close modal and update DumpBox

---

## 🎨 Design System

### Color Palette

```
Primary Colors:
├── Background (Main)    : #000000 (Pure Black)
├── Background (Cards)   : #1C1C1E / #2C2C2E (Dark Gray)
├── Background (Modal)   : #282828 (Slightly lighter dark gray)
├── Accent (Primary)     : #2196F3 (Bright Blue)
└── Accent (Secondary)   : #E91E63 (Pink/Magenta for DumpBox badge)

Action Colors:
├── Delete/Danger        : #E57373 / #FF5252 (Red/Coral)
├── Keep/Success         : #81C784 / #4CAF50 (Green)
└── Selected Border      : #4CAF50 (Green)

Text Colors:
├── Primary Text         : #FFFFFF (White)
├── Secondary Text       : #B0B0B0 / #CCCCCC (Light Gray)
├── Disabled Text        : #666666 (Dark Gray)
└── Button Text (Action) : #E8B4CB (Light Pink on blue buttons)

UI Elements:
├── Borders              : #3C3C3E (Subtle gray)
├── Dividers             : #2C2C2E
├── Checkmark Circle BG  : #4CAF50 (Green)
└── Checkmark Icon       : #FFFFFF (White)
```

### Typography

```
Font Family: 
├── iOS: San Francisco (System)
├── Android: Roboto (System)
└── Alternative: Google Fonts - Inter or Poppins

Font Weights:
├── Bold    : 700 (Titles, buttons)
├── SemiBold: 600 (Subtitles)
├── Regular : 400 (Body text)
└── Light   : 300 (Secondary info)

Font Sizes:
├── H1 (App Title)       : 28sp
├── H2 (Screen Title)    : 24sp
├── H3 (Card Title)      : 18sp
├── Body                 : 16sp
├── Caption              : 14sp
└── Small                : 12sp

Special Styles:
├── Header titles: Italic serif-style (e.g., "Select Category")
└── "PhotoSwipe": Bold sans-serif
```

### Spacing & Layout

```
Spacing Scale:
├── xs  : 4px
├── sm  : 8px
├── md  : 16px
├── lg  : 24px
├── xl  : 32px
└── xxl : 48px

Border Radius:
├── Small (icons)        : 8px
├── Medium (cards)       : 12px
├── Large (buttons)      : 16px
└── Pill (action buttons): 25px / 50% height

Screen Padding:
├── Horizontal           : 16px - 24px
└── Vertical             : 16px
```

### Icons

```
Icon Set: Custom or Material Icons / SF Symbols

Required Icons:
├── Logo: Photo/Mountain in rounded square (custom)
├── Hamburger Menu: Three horizontal lines
├── Clock: For "Most Recent"
├── Clock with arrow: For "Oldest"  
├── Video camera: For "Videos"
├── Calendar: For "Custom Date Range"
├── Play circle: For "Resume Session"
├── Rotate left/right: Circular arrows
├── Expand: Four outward arrows
├── Close: X mark
├── Chevron right: >
├── Back arrow: <
├── Checkmark: ✓
├── Trash: 🗑
├── Grid: For "Clear Selection"
└── Download: For "Keep" in DumpBox
```

---

## 🏗 Technical Architecture

### Flutter Project Structure

```
photo_swipe/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── config/
│   │   ├── theme.dart
│   │   ├── constants.dart
│   │   └── routes.dart
│   │
│   ├── models/
│   │   ├── photo_model.dart
│   │   ├── session_model.dart
│   │   └── filter_options.dart
│   │
│   ├── services/
│   │   ├── permission_service.dart
│   │   ├── photo_service.dart
│   │   └── storage_service.dart
│   │
│   ├── providers/
│   │   ├── photo_provider.dart
│   │   ├── dumpbox_provider.dart
│   │   └── session_provider.dart
│   │
│   ├── screens/
│   │   ├── welcome_screen.dart
│   │   ├── permission_screen.dart
│   │   ├── category_screen.dart
│   │   ├── date_range_screen.dart
│   │   ├── swipe_screen.dart
│   │   ├── dumpbox_screen.dart
│   │   └── empty_state_screen.dart
│   │
│   └── widgets/
│       ├── app_logo.dart
│       ├── privacy_card.dart
│       ├── category_tile.dart
│       ├── date_picker_button.dart
│       ├── swipe_card.dart
│       ├── photo_stack.dart
│       ├── action_buttons.dart
│       ├── dumpbox_badge.dart
│       ├── photo_grid_item.dart
│       ├── confirmation_dialog.dart
│       └── custom_checkbox.dart
│
├── ios/
│   └── Runner/
│       └── Info.plist (with permission descriptions)
│
└── android/
    └── app/
        └── src/main/
            └── AndroidManifest.xml (with permissions)
```

### React Native Project Structure

```
PhotoSwipe/
├── package.json
├── App.tsx
├── index.js
│
├── src/
│   ├── config/
│   │   ├── theme.ts
│   │   ├── constants.ts
│   │   └── navigation.ts
│   │
│   ├── models/
│   │   ├── Photo.ts
│   │   ├── Session.ts
│   │   └── FilterOptions.ts
│   │
│   ├── services/
│   │   ├── PermissionService.ts
│   │   ├── PhotoService.ts
│   │   └── StorageService.ts
│   │
│   ├── store/
│   │   ├── photoSlice.ts
│   │   ├── dumpboxSlice.ts
│   │   └── sessionSlice.ts
│   │
│   ├── screens/
│   │   ├── WelcomeScreen.tsx
│   │   ├── PermissionScreen.tsx
│   │   ├── CategoryScreen.tsx
│   │   ├── DateRangeScreen.tsx
│   │   ├── SwipeScreen.tsx
│   │   ├── DumpboxScreen.tsx
│   │   └── EmptyStateScreen.tsx
│   │
│   └── components/
│       ├── AppLogo.tsx
│       ├── PrivacyCard.tsx
│       ├── CategoryTile.tsx
│       ├── DatePickerButton.tsx
│       ├── SwipeCard.tsx
│       ├── PhotoStack.tsx
│       ├── ActionButtons.tsx
│       ├── DumpboxBadge.tsx
│       ├── PhotoGridItem.tsx
│       ├── ConfirmationDialog.tsx
│       └── CustomCheckbox.tsx
│
├── ios/
│   └── Info.plist
│
└── android/
    └── app/src/main/AndroidManifest.xml
```

---

## 🍎 iOS 14+ Compliance

### Permission Levels

iOS 14 introduced granular photo library access:

| Permission Level | Description | Handling |
|------------------|-------------|----------|
| `.authorized` | Full access to all photos | Normal operation |
| `.limited` | User selected specific photos | Show indicator, offer to request more |
| `.denied` | No access | Show "Go to Settings" prompt |
| `.notDetermined` | First time, not asked yet | Request permission |
| `.restricted` | Parental controls block access | Show explanation |

### Required Info.plist Entries (iOS)

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>PhotoSwipe needs access to your photo library to help you review and delete photos.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>PhotoSwipe needs permission to save photos you want to keep.</string>

<key>PHPhotoLibraryPreventAutomaticLimitedAccessAlert</key>
<true/>
```

### Permission Service Logic

```dart
// Pseudo-code for permission handling

Future<PermissionState> checkAndRequestPermission() async {
  // Check current status
  final status = await PhotoManager.requestPermissionExtend();
  
  switch (status) {
    case PermissionState.authorized:
      return PermissionState.authorized;
      
    case PermissionState.limited:
      // iOS 14+: User granted limited access
      // Optionally prompt: "You've granted limited access. 
      // Would you like to select more photos or grant full access?"
      return PermissionState.limited;
      
    case PermissionState.denied:
      // Show dialog with option to open Settings
      return PermissionState.denied;
      
    case PermissionState.notDetermined:
      // Request permission (will show system dialog)
      return await PhotoManager.requestPermissionExtend();
      
    case PermissionState.restricted:
      // Cannot request, show explanation
      return PermissionState.restricted;
  }
}

// For iOS 14+ Limited Access: Allow user to modify selection
void presentLimitedLibraryPicker() async {
  if (Platform.isIOS) {
    await PhotoManager.presentLimitedPhotosLibrary();
  }
}
```

### Android Permissions

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" 
    android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" 
    android:maxSdkVersion="29" />

<!-- Android 13+ (API 33+) -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
```

---

## 📊 Data Models

### PhotoModel

```dart
class PhotoModel {
  final String id;           // Unique identifier (from AssetEntity)
  final String localPath;    // Local file path
  final DateTime createDate; // Photo creation date
  final DateTime modifyDate; // Last modified date
  final int width;
  final int height;
  final AssetType type;      // image or video
  final int duration;        // For videos, duration in seconds
  final Uint8List? thumbnail;// Cached thumbnail bytes
  
  // UI state
  bool isSelected;
  bool isInDumpBox;
}
```

### SessionModel

```dart
class SessionModel {
  final String id;
  final DateTime createdAt;
  final DateTime lastAccessedAt;
  final FilterOptions filterOptions;
  final List<String> reviewedPhotoIds;  // IDs of photos already swiped
  final List<String> dumpBoxIds;        // IDs in DumpBox
  final int totalPhotos;
  final int remainingPhotos;
}
```

### FilterOptions

```dart
class FilterOptions {
  final FilterType type;      // mostRecent, oldest, videos, dateRange, resume
  final DateTime? startDate;
  final DateTime? endDate;
  final AssetType? assetType; // image, video, or null for all
  final SortOrder sortOrder;  // ascending or descending
}

enum FilterType {
  mostRecent,
  oldest,
  videos,
  dateRange,
  resume
}
```

---

## 📦 Dependencies

### Flutter Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # iOS Icons
  cupertino_icons: ^1.0.6
  
  # Photo Library Access
  photo_manager: ^3.0.0
  
  # Permissions
  permission_handler: ^11.0.0
  
  # UI Components
  google_fonts: ^6.1.0
  flutter_card_swiper: ^7.0.0
  
  # State Management
  provider: ^6.1.0
  # OR
  flutter_riverpod: ^2.4.0
  
  # Local Storage
  shared_preferences: ^2.2.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Utilities
  intl: ^0.18.0           # Date formatting
  uuid: ^4.2.0            # Unique IDs
  path_provider: ^2.1.0   # File paths

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.0
```

### React Native Dependencies (package.json)

```json
{
  "dependencies": {
    "react": "18.2.0",
    "react-native": "0.73.0",
    
    "@react-native-camera-roll/camera-roll": "^7.0.0",
    "react-native-permissions": "^4.1.0",
    
    "@react-navigation/native": "^6.1.0",
    "@react-navigation/native-stack": "^6.9.0",
    
    "react-native-gesture-handler": "^2.14.0",
    "react-native-reanimated": "^3.6.0",
    "react-native-deck-swiper": "^2.0.0",
    
    "@reduxjs/toolkit": "^2.0.0",
    "react-redux": "^9.0.0",
    
    "@react-native-async-storage/async-storage": "^1.21.0",
    
    "date-fns": "^3.0.0",
    "uuid": "^9.0.0"
  }
}
```

---

## 🖼 Screenshot References

All original design screenshots are preserved here for reference:

### Screen References

| Screen | Description | URL |
|--------|-------------|-----|
| Welcome Screen | Privacy & Disclaimer | `https://customer-assets.emergentagent.com/job_window-recall/artifacts/kxogt5q1_IMG_0856.PNG` |
| Permission Screen | Photo Access Required | `https://customer-assets.emergentagent.com/job_window-recall/artifacts/ekjuclsg_IMG_0857.PNG` |
| Category Screen | Main Menu | `https://customer-assets.emergentagent.com/job_window-recall/artifacts/0nwt5xck_IMG_0852.PNG` |
| Date Range Screen (v1) | With date selected | `https://customer-assets.emergentagent.com/job_window-recall/artifacts/ok2vkorv_IMG_0847.PNG` |
| Date Range Screen (v2) | With back button | `https://customer-assets.emergentagent.com/job_window-recall/artifacts/x9ln0oy0_IMG_0858.PNG` |
| Swipe Screen | Main review interface | `https://customer-assets.emergentagent.com/job_window-recall/artifacts/1fhcp61k_IMG_0860.PNG` |
| DumpBox Screen (3 items) | Photo grid selection | `https://customer-assets.emergentagent.com/job_window-recall/artifacts/4159m4v1_Screenshot%202025-11-15%20at%2004.42.42.png` |
| DumpBox Screen (7 items) | With delete confirmation | `https://customer-assets.emergentagent.com/job_window-recall/artifacts/i7ozfk33_Screenshot%202025-11-17%20at%2023.03.45.png` |

---

## 📝 Implementation Checklist

### Phase 1: Foundation
- [ ] Set up project structure
- [ ] Configure theme (colors, typography)
- [ ] Create constants file
- [ ] Set up routing/navigation

### Phase 2: Welcome Flow
- [ ] Build Welcome Screen UI
- [ ] Implement checkbox toggle
- [ ] Create Privacy Card widget
- [ ] Handle Continue navigation

### Phase 3: Permissions
- [ ] Build Permission Screen UI
- [ ] Implement PermissionService
- [ ] Handle all permission states (iOS 14+)
- [ ] Add "Go to Settings" flow

### Phase 4: Category Selection
- [ ] Build Category Screen UI
- [ ] Create CategoryTile widget
- [ ] Implement navigation to each category

### Phase 5: Date Range
- [ ] Build Date Range Screen UI
- [ ] Implement date pickers
- [ ] Create FilterOptions model
- [ ] Handle validation

### Phase 6: Photo Loading
- [ ] Implement PhotoService
- [ ] Fetch photos from gallery
- [ ] Apply filters (date, type, order)
- [ ] Handle pagination/lazy loading

### Phase 7: Swipe Interface
- [ ] Build Swipe Screen UI
- [ ] Implement card stack
- [ ] Add swipe gestures
- [ ] Create action buttons
- [ ] Handle swipe callbacks

### Phase 8: DumpBox
- [ ] Build DumpBox Screen UI
- [ ] Implement photo grid
- [ ] Add selection logic
- [ ] Create action buttons

### Phase 9: Deletion Flow
- [ ] Build Confirmation Modal
- [ ] Integrate with PhotoManager.deleteWithIds()
- [ ] Handle iOS system confirmation
- [ ] Update DumpBox state

### Phase 10: Session Management
- [ ] Implement StorageService
- [ ] Save session state
- [ ] Resume last session
- [ ] Handle edge cases

---

## 🚀 Future Enhancements (V2)

- [ ] Undo last swipe action
- [ ] Batch selection in swipe view
- [ ] Photo details overlay (date, size, location)
- [ ] Statistics dashboard (photos reviewed, deleted, kept)
- [ ] iCloud/Google Photos integration
- [ ] Share to other apps before delete
- [ ] Similar photo detection (AI)
- [ ] Widget for quick access
- [ ] Dark/Light theme toggle

---

**Document Version History:**
| Version | Date | Changes |
|---------|------|---------|
| 1.0 | August 2025 | Initial PRD creation |

---

*This PRD serves as the complete blueprint for building PhotoSwipe in either Flutter or React Native. All specifications, designs, and requirements are captured here for reference in any development session.*
