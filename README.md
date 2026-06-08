> A feature-rich mobile travel blog built with Flutter, where users can share their travel experiences, follow other explorers, and discover the world through photos and stories.

---

## Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Screenshots](#-screenshots)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Running the App](#-running-the-app)
- [Fixing Pod Errors](#-fixing-pod-errors)
- [Common Errors & Solutions](#-common-errors--solutions)

---

## Features

### Posts
- Create travel posts with a **mandatory photo** and **mandatory caption**
- All other fields (title, location, tags, etc.) are **optional**
- Post **timestamp is set automatically** at the moment of creation
- Edit or delete your own posts — other users cannot modify them
- Only the **post creator** can edit or delete their own posts

###  Location
- Detect location automatically using the **device's current GPS position**
- Alternatively, search for a location manually using the **Google Places API** with **autocomplete suggestions**

###  Comments
- Comment on any post
- Each comment can only be **deleted by its author** — not by others, not by the post owner

### User Profiles
- Customize your profile with a **profile picture** and **biography**
- View public profile information when visiting another user's profile:
    - Number of posts
    - Number of followers
    - Number of following
- **Edit profile**, bio, and posts is restricted to the **profile owner only**

### Authentication
- Full **registration and login** flow
- When deleting content, **recently logged-in users** are required to **re-enter their password** as a security confirmation step

###  Social
- **Follow** other users
- **Bookmark / save** posts from other users
- **Search for users** by name

### UI & UX
- **Light and Dark theme** support — system-aware, toggleable
- Fully **responsive** layout using `MediaQuery` — all dimensions and spacing scale dynamically with the actual device screen size, supporting all iPhone form factors
- Consistent UI state management via **BLoC** — screens always reflect the latest data without manual refresh

---

##  Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (iOS) |
| State Management | BLoC Pattern |
| Authentication | Firebase Auth |
| Database | Firebase Firestore |
| Storage | Firebase Storage |
| Location | Geolocator + Google Places API |
| Autocomplete | Google Places Autocomplete |

---

##  Architecture

### BLoC Pattern

The app is built around the **BLoC (Business Logic Component)** pattern using the `flutter_bloc` package. BLoC enforces a strict unidirectional data flow and a clear separation of concerns across three layers:

```
UI Layer  ──►  BLoC Layer  ──►  Repository Layer  ──►  Firebase
  │                │                                       │
  │   (Events)     │           (Data / Models)             │
  ◄────────────────┘◄──────────────────────────────────────┘
         (States)
```

- **UI (Screens & Widgets)** — dispatches `Events` to the BLoC and rebuilds in response to emitted `States`. The UI has zero direct access to data sources.
- **BLoC** — receives events, executes business logic, calls the repository, and emits new states. One BLoC per feature domain (auth, posts, profile, feed, search, etc.).
- **Repository** — the single source of truth for data. Abstracts all Firebase calls (Firestore reads/writes, Storage uploads, Auth operations) behind clean async methods.
- **Models** — plain Dart classes representing domain objects (`Post`, `UserModel`, `Comment`, etc.) with `fromMap` / `toMap` serialization for Firestore.

This architecture makes features independently testable and keeps the widget tree free of business logic.

---

###  Project Structure

Source code lives in the `lib/` directory, organised into feature folders under [`lib/features/`](lib/features/).

Each feature is self-contained and implemented following the BLoC pattern.
---

[//]: # (### 📐 Responsiveness — MediaQuery)

[//]: # (All screens adapt dynamically to different device sizes using Flutter's `MediaQuery`.)

This ensures the layout looks correct across all iPhone sizes — from compact SE models to the larger Pro Max — without maintaining separate layouts per device.

---

### 🗂 Firebase Storage Structure

Storage is organized into dedicated folders per user to keep data clean and easy to manage:

```
storage/
├── posts/
│   
│   
└── profile_pictures/
  
```

---

## 🔧 Prerequisites

Before you begin, make sure you have the following installed:

- macOS with **Xcode** installed
- **Flutter SDK** — [flutter.dev](https://flutter.dev/docs/get-started/install/macos)
- **CocoaPods**
- A **Firebase** project with Firestore, Auth, and Storage enabled
- A **Google Places API** key

Check your Flutter setup:

```bash
flutter doctor
```

All checks should be green ✅. Follow any printed instructions for items that aren't.

---

## 🚀 Installation

### 1. Clone the repository

```bash
git clone git@github.com:amit24af/uat-project.git
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Place your `GoogleService-Info.plist` file in the `ios/Runner/` directory.

> Make sure Firebase Auth, Firestore, and Storage are enabled in your Firebase Console.

### 4. Configure Google Places API

Add your Google Places API key in the appropriate configuration file (e.g., `lib/config/api_keys.dart` or via environment variables).

---

##  Running the App

### Select an iOS Simulator

**Option A — Launch the simulator first, then run:**

```bash
# List all available simulators
xcrun simctl list devices

# Open the Simulator app
open -a Simulator
```

Inside Simulator: **File → Open Simulator → iOS → iPhone 15**

Then run:

```bash
flutter run
```

**Option B — Specify the device directly:**

```bash
# List Flutter-visible devices
flutter devices

# Run on a specific device
flutter run -d <device_id>
```

**Option C — Interactive selection:**

Simply run `flutter run` without arguments — Flutter will prompt you to choose a device.

---

## 🛠 Fixing Pod Errors

If you encounter CocoaPods-related errors:

```bash
cd ios
rm -rf Pods Podfile.lock
pod install
# If that fails, try:
pod install --repo-update
cd ..
flutter run
```

> ⚠️ Always return to the project root (`cd ..`) before running `flutter run`!

**If `pod install` fails with a Ruby version error:**

```bash
brew install rbenv ruby-build
rbenv install 3.2.0
rbenv global 3.2.0
gem install cocoapods
cd ios && pod install && cd ..
```

---

##  Common Errors & Solutions

**`flutter: command not found`**
Add Flutter to your PATH in `~/.zshrc`:
```bash
export PATH="$HOME/development/flutter/bin:$PATH"
source ~/.zshrc
```

**`No devices found`**
```bash
open -a Simulator
```

**`CocoaPods not installed` / `pod: command not found`**
```bash
sudo gem install cocoapods
```

**`The sandbox is not in sync with the Podfile.lock`**
```bash
cd ios && pod install && cd ..
flutter run
```

**`Unable to boot device in the simulator`**
```bash
xcrun simctl erase all
open -a Simulator
flutter run
```

**`Flutter SDK not found` / `Dart SDK not found`**
```bash
flutter doctor --verbose
```
Follow the printed instructions and verify your PATH is correct.

**`Xcode build error (signing, provisioning...)`**
A developer account is **not required** for simulator builds. In Xcode:
1. Open `ios/Runner.xcworkspace`
2. Click **Runner** in the navigator
3. Under **Signing & Capabilities** → enable **Automatically manage signing** → select your **Personal Team**

---

##  Security Notes

- Users who have been **recently authenticated** will be asked to **confirm their password** before performing sensitive actions such as deleting posts or their account.
- Profile editing, post editing, post deletion, and comment deletion are **restricted to the content creator only**.
- Visiting another user's profile shows only **public information** — follower counts, following counts, and post count.

---

## 📱 Supported Platforms

| Platform | Supported |
|---|---|
| iOS (Simulator) | ✅ |
| iOS (Device) | ✅ |
| Android | 🚧 Not configured |
| macOS | 🚧 Not configured |

---
