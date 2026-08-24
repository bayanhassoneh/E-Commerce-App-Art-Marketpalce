

<div align="center">

  <img src="assets/images/launcher_icon.png" width="65" alt="App Icon" />

  # Art Marketplace 

  <p>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"></a>
    <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"></a>
    <a href="https://supabase.com"><img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase"></a>
  </p>

</div>

A mobile application built with **Flutter** and **Supabase** that allows artists to showcase and sell their mixed-media works, sculptures, and paintings.

## Overview
the Marketplace is designed to bridge the gap between local artists and art enthusiasts. It provides a clean, user-friendly interface for browsing unique artworks while ensuring secure data management and real-time updates.

## ✨ Features
* **Artist Profiles:** Dedicated spaces for artists to manage their portfolio.
* **Mixed-Media Showcase:** Support for various art forms (visual tributes, posters, sculptures).
* **Secure Authentication:** Managed via Supabase Auth.
* **Robust Backend:** Utilizing SQL triggers, Row Level Security (RLS), and optimized database schemas.
## Planned / Upcoming
* **Stripe payment integration**
## 🛠️ Tech Stack
* **Frontend:** Flutter (Dart)
* **Backend:** Supabase (PostgreSQL-manual SQL scripts)
* **State Management:** (provider)
* **Database Logic:** Custom SQL Triggers & RLS Policies.
* **App Launcher Icon:** Managed via `flutter_launcher_icons`

## 📸 Screenshots
<p align="left">
  <img src="screenshots/signInScreen.png" width="20%" />
  <img src="screenshots/profile.png" width="20%" />
  <img src="screenshots/createpost.png" width="20%" />
    <img src="screenshots/forgetPasswordScreen.png" width="20%" />
      <img src="screenshots/home.png" width="20%" />
   <img src="screenshots/post.png" width="20%" />
</p>

## ERD
![ERD](docs/ERD.png)

For the full-resolution diagram:

[📄 ERD PDF](docs/ERD.pdf)

##  Technical Highlights
As an aspiring Software Engineer, I focused on:
* Implementing **Clean Code** principles and reusable UI components.
* Designing a secure database schema with **PostgreSQL** scripts via the SQL Editor. 
* Implemented strict **Row Level Security (RLS)** policies to ensure data privacy at the database level.
* * Developed custom **SQL Functions and Triggers** to automate complex data workflows and maintain integrity.
* Managing complex backend logic directly in the database to ensure data integrity.


## 📂 Folder Structure

```text
art_marketplace/
├── lib/
│   ├── core/
│   ├── models/
│   ├── providers/
│   ├── screens/
│   ├── services/
│   ├── widgets/
│   └── main.dart
├── assets/
├── database/
│   ├── triggers/
│   ├── indexes,sql
│   ├── security.sql
│   └── tables.sql
│
├── screenshots/
├── docs/
│   ├── ERD.pdf
│   └── ERD.png
├── test/
├── pubspec.yaml
└── README.md

```
  --
