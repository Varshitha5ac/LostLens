# LostLens — Smart Lost & Found Platform

<p align="center">
  <strong>A Flutter-based Lost & Found application for campus communities.</strong>
</p>

LostLens is a user-friendly mobile and web application designed to simplify the process of reporting, discovering, and recovering lost belongings within a campus or community.

The application provides dedicated interfaces for reporting lost and found items, exploring reported belongings, filtering listings, previewing item images, and managing user profile information. It aims to make the lost-and-found process more organized, accessible, and convenient through a clean and responsive user interface.

---

## Overview

Losing personal belongings such as wallets, bags, keys, books, and electronic devices is a common problem in educational institutions and shared spaces. Traditional lost-and-found processes often depend on manual communication, notice boards, or informal messaging.

LostLens provides a centralized digital interface where users can report missing belongings, register items they have found, and browse available listings.

The project was developed as part of the **UI Design Laboratory**, with a focus on Flutter application development, UI/UX design, responsive layouts, navigation, forms, validation, and interactive components.

## Key Features

### 1. Home Screen
- Clean and intuitive landing screen.
- Quick access to Lost Item and Found Item reporting.
- Search interface for discovering belongings.
- Category-based browsing.
- Recently reported item previews.

### 2. Report Lost & Found Items
- Separate reporting options for lost and found belongings.
- Input fields for item name, category, colour, description, location, and date.
- Image selection using the device gallery.
- Image preview before submission.
- Form validation to prevent incomplete submissions.
- Success feedback after submitting a report.

### 3. Explore Items
- Dedicated screen to browse reported items.
- Search items by name or location.
- Filter listings by Lost and Found status.
- Category-based filtering.
- Sorting options.
- Grid and list viewing modes.
- Item details displayed through an interactive interface.

### 4. Profile Management
- User profile screen.
- Edit profile details such as display name and email address.
- Profile update feedback.
- Contribution statistics section.
- Notification and email preference toggles.
- Account and support-related menu options.

### 5. Navigation
- Bottom navigation bar for Home, Explore, Activity, and Profile.
- Floating action button for quick reporting.
- Navigation between application screens.
- Interactive dialogs and bottom sheets.

### 6. User Interface Design
- Consistent colour palette and typography.
- Reusable UI components.
- Responsive layouts for different screen sizes.
- Cards, badges, icons, and interactive controls.
- Clean and minimal visual presentation.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform UI development |
| Dart | Application programming language |
| Material Design | UI components and visual design |
| Provider | State management package |
| image_picker | Selecting images from the device |
| shared_preferences | Local key-value storage package |
| HTTP | HTTP request support |
| intl | Date formatting and localization utilities |
| Visual Studio Code | Development environment |
| Android Studio | Android development and emulator support |

---

## Application Architecture

The application follows a modular Flutter project structure to organize screens, reusable components, data models, and application styling.

```text
lostlens/
│
├── assets/
│   ├── images/
│   └── fonts/
│
├── lib/
│   ├── core/
│   │   ├── theme/
│   │   │   └── app_colors.dart
│   │   └── widgets/
│   │
│   ├── models/
│   │   └── lost_item.dart
│   │
│   ├── providers/
│   │
│   ├── screens/
│   │   ├── app_shell.dart
│   │   ├── home_screen.dart
│   │   ├── explore_screen.dart
│   │   ├── report_screen.dart
│   │   └── profile_screen.dart
│   │
│   └── data/
│
├── test/
├── pubspec.yaml
└── README.md
```

---

## Getting Started

Follow these steps to run LostLens locally.

### Prerequisites

Make sure the following tools are installed:

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Google Chrome (for web execution)
- Android Emulator or a connected Android device (for Android execution)
- Git

### 1. Clone the Repository

```bash
git clone https://github.com/Varshitha5ac/LostLens.git
```

### 2. Navigate to the Project Directory

```bash
cd lostlens
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Check Flutter Configuration

```bash
flutter doctor
```

### 5. Run the Application

For web:

```bash
flutter run -d chrome
```

For Android:

```bash
flutter devices
```

```bash
flutter run -d <device-id>
```

### 6. Build APK

To generate a debug APK:

```bash
flutter build apk --debug
```

The generated APK will be available at:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

---

## Design Approach

LostLens follows an **Editorial + Field Notes** visual design direction. The interface uses a warm background, evergreen primary colour, coral action accents, and structured item cards to create a recognizable visual identity.

### Colour Palette

| Colour | Hex Code | Usage |
|---|---|---|
| Evergreen | `#153D3B` | Primary interface elements |
| Paper | `#F5F1E8` | Application background |
| Coral | `#E56B54` | Primary actions and Lost labels |
| Sage | `#A8B7A0` | Secondary accents |
| Marigold | `#E9B44C` | Highlights |
| Charcoal | `#263432` | Primary text |

---

## Learning Outcomes

This project demonstrates practical implementation of the following Flutter and Dart concepts:

- Dart programming and data models.
- Flutter widgets and widget composition.
- Stateless and Stateful widgets.
- Row, Column, Stack, and layout structures.
- Responsive UI development.
- Navigation and screen management.
- Forms and input validation.
- Image selection and preview.
- State management concepts.
- Reusable components and theme management.
- Interactive dialogs, bottom sheets, and feedback messages.
- Flutter debugging and application testing.

---

## Current Project Scope

LostLens is currently developed as a UI-focused laboratory project with interactive application screens and demonstration data.

The current version focuses on the frontend experience and does not include a production backend, cloud database, real authentication system, or live user-to-user synchronization.

Backend integration, persistent user accounts, real-time notifications, advanced item matching, and administrative moderation can be considered for future development.

---

## Future Enhancements

- Backend and database integration.
- Secure user registration and authentication.
- Persistent lost-and-found listings.
- Real-time notifications and status updates.
- Automated matching of lost and found items.
- Claim verification and ownership confirmation.
- Admin and moderator dashboard.
- Location-based item discovery.
- Deployment to Google Play Store and Apple App Store.

---

## Project Information

| Field | Details |
|---|---|
| Project Name | LostLens — Smart Lost & Found Platform |
| Project Type | UI Design Laboratory Project |
| Domain | Flutter Application Development |
| Programming Language | Dart |
| Framework | Flutter |
| Institution | BVRIT HYDERABAD College of Engineering for Women |
| Department | Computer Science & Engineering |
| Developer | N. Varshitha |
