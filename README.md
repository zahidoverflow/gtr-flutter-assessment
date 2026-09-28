# 📱 GTR Customer Management Application

A modern, responsive, and robust Flutter customer management application built for the **GTR (gtrbd.com)** practical assessment.

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_MVVM-teal?style=for-the-badge)]()
[![State Management](https://img.shields.io/badge/State-Provider-blue?style=for-the-badge)]()
[![Tests](https://img.shields.io/badge/Tests-Passing_100%25-success?style=for-the-badge)]()

---

## 🚀 Key Features

* **State Management**: Built with **Provider** (`ChangeNotifierProvider`), following strict reactive state separation and clean dependency injection.
* **User Authentication & Authorization**:
  * Seamless sign-in handling via GTR / HisabPlus authorization endpoint.
  * Automatic token persistence using `shared_preferences`.
  * Secure header injection (`Authorization: <JWT-token>`) for all protected endpoints.
  * One-tap pre-filled test credentials for immediate evaluation.
* **Customer List & Infinite Pagination**:
  * Continuous infinite scrolling with scroll threshold detection.
  * Real-time search query filtering.
  * Sorting options (Outstanding Balance, Customer Name, Customer ID).
  * Pull-to-refresh integration.
* **Customer Details & Image Rendering**:
  * Profile view displaying customer avatar / network image from `https://www.Hisabplus.com/`.
  * Dynamic fallback initials avatar with consistent hash coloring when no image is present.
  * Complete financial summary (Total Due, Collections, Total Sales Value with ৳ formatting).
  * Detailed contact and sales transaction history.
* **Resilient Error Handling**:
  * Network timeouts, connectivity loss, and 4xx/5xx HTTP errors handled gracefully.
  * User-friendly error screens with instant **Try Again** retry triggers.
  * Zero deprecated warnings, 100% clean `flutter analyze`.

---

## 🏛️ Architecture Overview

The app follows **Clean Architecture & MVVM (Model-View-ViewModel)** principles:

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart       # Endpoints, default credentials, base URLs
│   │   └── app_colors.dart          # Unified brand & semantic color palette
│   ├── network/
│   │   └── api_client.dart          # HTTP client, header injection, error mapper
│   └── services/
│       └── storage_service.dart     # SharedPreferences session management
├── models/
│   ├── customer_model.dart          # Customer JSON mapping & image URL resolution
│   └── user_model.dart              # User & JWT session mapping
├── repositories/
│   ├── auth_repository.dart         # Authentication data source & token lifecycle
│   └── customer_repository.dart     # Customer API queries & pagination engine
├── providers/
│   ├── auth_provider.dart           # Auth state & session listener
│   └── customer_provider.dart       # Customer list, infinite scroll, sort & search
├── views/
│   ├── auth/
│   │   └── login_screen.dart        # Modern Material 3 sign-in UI
│   ├── customer/
│   │   ├── customer_list_screen.dart    # Infinite scroll list + search/sort
│   │   ├── customer_details_screen.dart # Detailed profile & transaction history
│   │   └── widgets/
│   │       └── customer_card.dart       # Modular customer card component
│   └── common/
│       ├── error_view.dart          # Reusable error & retry widget
│       └── loading_view.dart        # Consistent loading indicator
└── main.dart                        # MultiProvider app entry point
```

---

## 🌐 API Configuration

* **Base URL**: `https://www.hisabplus.com/Values/`
* **Image Base URL**: `https://www.Hisabplus.com/`

### Default Evaluation Credentials:
| Field | Value |
|---|---|
| **Username / Email** | `admin@gmail.com` |
| **Password** | `admin1234` |
| **Company ID (ComId)** | `1` |

---

## 💻 Getting Started & Running

### 1. Prerequisites
* Flutter SDK (3.24.0 or newer)
* Dart SDK (3.3.0 or newer)
* Android Studio / VS Code / Flutter CLI

### 2. Setup
Clone the repository and install packages:
```bash
git clone https://github.com/zahidoverflow/gtr-flutter-assessment.git
cd gtr-flutter-assessment
flutter pub get
```

### 3. Run Static Analysis & Tests
```bash
flutter analyze
flutter test
```

### 4. Run Application
```bash
# Run on connected device or emulator:
flutter run
```

---

## 📦 Project Submission Details

* **Candidate**: Zahidul Islam
* **Email**: zahidoverflow@gmail.com
* **Phone / WhatsApp**: +8801707370774
* **Position**: Flutter Intern — GTR (gtrbd.com)
