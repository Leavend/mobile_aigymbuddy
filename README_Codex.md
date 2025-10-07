# 🏋️‍♂️ AI Gym Buddy

> **AI Gym Buddy** adalah aplikasi mobile berbasis **AI** yang berfungsi sebagai **personal trainer digital**, membantu pengguna mencapai target kebugaran dengan rekomendasi workout, meal plan, serta tracking progres yang cerdas.

---

## 🎯 Tujuan Proyek

Membangun aplikasi mobile **cross-platform** yang menggabungkan fungsionalitas **personal fitness tracking** dengan **AI assistant**, sehingga pengguna dapat:

* Menentukan target kebugaran pribadi.
* Mendapat rekomendasi workout sesuai level dan alat yang dimiliki.
* Melacak progres latihan dan berat badan.
* Menerima motivasi dan saran dari AI Chat Buddy (Gemini API).

---

## 📱 Fitur Utama (MVP)

### 1. Onboarding & Profil Pengguna ✅

* Input data: **usia, tinggi, berat, gender, target, level fitness**.
* Simpan data ke database (PostgreSQL).
* Tampilan onboarding yang interaktif dan ringan.

### 2. Workout Generator

* Algoritma awal berbasis **rule-based logic** (contoh: kombinasi latihan berdasarkan level dan alat).
* Kategori latihan:

  * **Home Workout** → tanpa alat.
  * **Gym Workout** → dengan alat.

### 3. Progress Tracking

* Input manual data seperti:

  * Berat badan.
  * Jumlah reps/sets.
  * Catatan latihan harian.
* Menampilkan **grafik perkembangan** menggunakan chart dinamis.

### 4. AI Chat Buddy (opsional MVP)

* Chat ringan untuk motivasi dan saran cepat.
* Integrasi dengan **Gemini API** untuk interaksi natural language.

---

## 🌟 Fitur Lanjutan (Roadmap)

| Tahap      | Fitur                     | Deskripsi                                             |
| :--------- | :------------------------ | :---------------------------------------------------- |
| 🚀 Tahap 1 | **Meal Plan Assistant**   | Saran nutrisi dan perhitungan kalori otomatis.        |
| 🚀 Tahap 2 | **Video Demo Gerakan**    | Library tutorial video tiap gerakan workout.          |
| 🚀 Tahap 3 | **Integrasi Smartwatch**  | Sinkronisasi data langkah, detak jantung, dan kalori. |
| 🚀 Tahap 4 | **Komunitas & Challenge** | Leaderboard dan workout bersama komunitas.            |
| 🚀 Tahap 5 | **Body Scan AI (AR)**     | Estimasi perubahan tubuh dengan kamera AR.            |

---

## 🧩 Tech Stack

| Komponen               | Teknologi               |
| :--------------------- | :---------------------- |
| **Frontend (Mobile)**  | Flutter (Dart)          |
| **Backend API**        | Rust (Actix Web / Axum) |
| **Database**           | PostgreSQL              |
| **AI Integration**     | Gemini API              |
| **Hosting & Auth**     | Firebase                |
| **Version Control**    | GitHub                  |
| **Project Management** | Notion / Linear         |

---

## 📆 Timeline Implementasi

| Minggu | Kegiatan                                            | Target                       |
| :----: | :-------------------------------------------------- | :--------------------------- |
|   1–2  | Analisis kebutuhan, desain wireframe, setup project | Figma & struktur awal proyek |
|   3–4  | Onboarding & autentikasi pengguna                   | Halaman profil & login       |
|   5–6  | Workout generator + tracking progress               | Logic rule-based & chart     |
|   7–8  | AI Chat Buddy & meal plan sederhana                 | Integrasi Gemini API         |
|    9   | Testing & debugging                                 | Unit & UI testing            |
|   10   | Release MVP + dokumentasi                           | APK final & laporan proyek   |

---

## ✅ Deliverables

* 📱 **Aplikasi Mobile** (APK/IPA)
* 🧠 **Backend API** + dokumentasi endpoint
* 🎨 **Desain UI/UX** (Figma atau Canva)
* 📖 **Dokumentasi Teknis**
* 🧾 **Laporan Proyek Akhir**

---

## ⚙️ Setup Development Environment

### 1. Clone Repository

```bash
git clone https://github.com/username/aigymbuddy.git
cd aigymbuddy
```

### 2. Backend (Rust)

```bash
cd server
cargo run
```

Konfigurasi environment:

```bash
DATABASE_URL=postgres://user:password@localhost:5432/aigymbuddy
PORT=8080
```

### 3. Mobile App (Flutter)

```bash
cd mobile
flutter pub get
flutter run
```

Pastikan emulator Android atau iOS sudah aktif.

---

## 🧠 Integrasi AI (Gemini API)

Gunakan **Gemini API** untuk fitur AI Chat Buddy:

```dart
final response = await http.post(
  Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateText'),
  headers: {'Authorization': 'Bearer $GEMINI_API_KEY'},
  body: jsonEncode({'prompt': 'Berikan motivasi fitness singkat'}),
);
```

Contoh output:

> “Setiap tetes keringatmu hari ini adalah langkah menuju versi terbaik dari dirimu sendiri 💪”

---

## 📊 Struktur Proyek (Direktori)

```
AI-Gym-Buddy/
│
├── mobile/                 # Flutter App
│   ├── lib/
│   │   ├── view/
│   │   ├── model/
│   │   ├── services/
│   │   ├── widgets/
│   │   └── main.dart
│   └── pubspec.yaml
│
├── server/                 # Rust Backend
│   ├── src/
│   │   ├── main.rs
│   │   ├── routes/
│   │   ├── models/
│   │   ├── controllers/
│   │   └── services/
│   └── Cargo.toml
│
├── database/
│   ├── schema.sql
│   └── seed.sql
│
├── docs/
│   ├── README_Codex.md
│   ├── API_Documentation.md
│   └── Architecture_Diagram.png
│
└── .env.example
```

---

## 🧩 Lisensi

MIT License © 2025 — **Tiohadypranoto (Leavend)**
Proyek ini bersifat open source dan dapat dikembangkan untuk kepentingan edukasi dan riset AI di bidang kebugaran.

---

## 💬 Kontak & Kontribusi

* **Email:** [tiohadybayu@gmail.com](mailto:tiohadybayu@gmail.com)
* **GitHub:** [@Leavend](https://github.com/Leavend)
* **Community:** Bontang Techno Hub (BTH)

> Kontribusi terbuka untuk pengembang, desainer, dan AI enthusiast yang ingin mengembangkan fitur baru untuk AI Gym Buddy.
