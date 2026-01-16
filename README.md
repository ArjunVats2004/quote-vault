# 📱 QuoteVault – Daily Inspirational Quotes

QuoteVault is a Flutter application that delivers a **daily motivational quote** straight to your device via push notifications.  
It integrates **Supabase** as the backend for storing and retrieving quotes, and leverages **flutter_local_notifications** with **timezone support** to schedule notifications reliably across platforms.

---

## ✨ Features
- 🔐 **Authentication** – Login, signup, and password reset powered by Supabase Auth.
- 📖 **Daily Quote Notifications** – Automatically fetches a random quote from Supabase and schedules it at a chosen time.
- 🎨 **Customizable UI** – Theme, accent color, and font scaling managed via `SettingsModel`.
- 🛠 **Modern Architecture** – Separation of concerns with `data`, `domain`, and `features` layers.
- 🌍 **Cross‑Platform** – Works on both Android and iOS with proper permission handling.

---

## 🧩 Tech Stack
- **Flutter** (UI framework)
- **GoRouter** (navigation)
- **Provider** (state management)
- **Supabase** (backend: auth + database)
- **flutter_local_notifications** (local notifications)
- **timezone** (accurate scheduling)
- **permission_handler** (runtime permissions on Android 13+)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- Supabase project with a `quotes` table (containing at least a `text` column)
- Android/iOS device or emulator

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/quotevault.git
   cd quotevault
2.## Install Dependencies
   flutter pub get
3. ##Update Supabase credentials in main.dart:
   await Supabase.initialize(
  url: 'https://YOUR-PROJECT.supabase.co',
  anonKey: 'YOUR-ANON-KEY',
);
4.## Run the app:
flutter run 

