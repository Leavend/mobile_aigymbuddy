# AI Gym Buddy - Panduan Penggunaan & Database Management

## 📋 Overview

AI Gym Buddy adalah aplikasi Flutter yang dibuat untuk membantu pengguna dalam aktivitas健身 dan fitness. Aplikasi ini menggunakan **Drift Database** untuk penyimpanan data lokal yang **persistent** dan **reliable**.

## 🏗️ Architecture

### Clean Architecture Pattern
- **Auth Layer**: Authentication dan user management
- **Data Layer**: Database operations dengan Drift
- **Domain Layer**: Business logic dan use cases  
- **Presentation Layer**: UI components dan screens

### Database Implementation
- **Drift ORM**: Type-safe database operations
- **SQLite**: Persistent storage
- **Cross-platform**: Web (WASM) dan Native support
- **WAL Mode**: Write-Ahead Logging untuk better performance

## 🚀 Cara Menjalankan Aplikasi

### Prerequisites
```bash
# Pastikan Flutter sudah terinstall
flutter --version

# Install dependencies
flutter pub get

# Generate Drift files
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Menjalankan di Web
```bash
# Debug mode
flutter run -d chrome --debug

# Production build
flutter build web --release
```

### Menjalankan di Mobile
```bash
# Android
flutter run -d android

# iOS  
flutter run -d ios
```

## 🗄️ Database Management

### Lokasi File Database

**Android/iOS:**
```
/data/data/[package_name]/app_flutter/gym_buddy_db.sqlite
```

**Web (IndexedDB):**
```
Browser's IndexedDB storage
- Database name: gym_buddy_db
- Automatically managed by Drift WASM
```

### Struktur Database

#### Tabel Utama:
1. **users** - Data user authentication
2. **user_profiles** - Profile detail pengguna  
3. **body_metrics** - Data berat badan dan ukuran tubuh
4. **exercises** - Database exercise
5. **workout_plans** - Rencana latihan
6. **workout_sessions** - Sesi latihan
7. **ai_chat_messages** - Pesan chat AI

#### Entity Relationship:
```sql
users (1) -> (1) user_profiles
users (1) -> (N) body_metrics
users (1) -> (N) workout_plans
users (1) -> (N) workout_sessions
workout_sessions (1) -> (N) session_exercises
exercises (1) -> (N) exercise_muscles
```

### Cara Mengecek Data Database

#### 1. Menggunakan Flutter Inspector
```bash
# Jalankan aplikasi dalam debug mode
flutter run -d chrome --debug

# Buka DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Connect ke aplikasi dan inspect database
```

#### 2. Menggunakan SQL Browser (Native)
```bash
# Copy database file dari device
adb pull /data/data/[package]/app_flutter/gym_buddy_db.sqlite ./

# Buka dengan SQLite browser seperti DB Browser for SQLite
sqlitebrowser gym_buddy_db.sqlite
```

#### 3. Web Database Inspector
```bash
# Buka Chrome DevTools
# Application tab -> Storage -> IndexedDB
# Cari database: gym_buddy_db
```

#### 4. Programmatic Database Access
```dart
// Contoh mengecek data user
final db = ServiceLocator().database;
final usersDao = db.usersDao;

// Get all users
final allUsers = await usersDao.getAllUsers();
print('Total users: ${allUsers.length}');

// Get user count
final userCount = await usersDao.getUserCount();
print('User count: $userCount');

// Check database stats
final verifier = DatabaseVerifier(db);
final isPersistent = await verifier.testPersistence();
print('Database persistence: $isPersistent');
```

## 💾 Data Persistence Features

### Optimasi Data Persistence

1. **WAL Mode**: Write-Ahead Logging untuk faster writes
2. **Automatic Transactions**: Data automatically committed
3. **Crash Recovery**: Data preserved during app crashes
4. **Cross-platform**: Same behavior di web dan native

### Error Handling & Recovery

```dart
// Database verification di main()
try {
  final isValid = await ServiceLocator().databaseService.checkDatabaseIntegrity();
  if (!isValid) {
    print('Database corruption detected');
    // Implement recovery logic
  }
} catch (e) {
  print('Database connection failed: $e');
}
```

### Backup & Restore

```dart
// Backup database
final backupPath = await ServiceLocator().databaseService.backupDatabase();
print('Backup created: $backupPath');

// Restore from backup
final db = ServiceLocator().database;
await db.close();
// Copy backup file to database location
// Reopen database
```

## 🛠️ Development Commands

### Code Generation
```bash
# Generate Drift database files
flutter packages pub run build_runner build

# Watch untuk auto-regeneration
flutter packages pub run build_runner watch

# Clean dan regenerate
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing Database
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Test database persistence
flutter test test/database_persistence_test.dart
```

### Database Migrations
```dart
// Tambah migration di app_db.dart
@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async {
    await m.createAll();
  },
  onUpgrade: (Migrator m, int from, int to) async {
    if (from == 1) {
      // Migration dari version 1
      await m.createTable(newTable);
    }
    if (from == 2) {
      // Migration dari version 2  
      await m.addColumn(table, column);
    }
  },
);
```

## 🔧 Troubleshooting

### Database Issues

**Issue**: Database tidak tersimpan
```bash
# Solution: Check permissions dan file path
# Android: Ensure WRITE_EXTERNAL_STORAGE permission
# Web: Check browser storage quota
```

**Issue**: Data corruption
```dart
// Solution: Use DatabaseVerifier
final verifier = DatabaseVerifier(db);
final isCorrupted = !await verifier.checkForCorruption();
if (isCorrupted) {
  // Recreate database or restore from backup
}
```

**Issue**: Build errors
```bash
# Solution: Clean rebuild
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Performance Issues

**Slow queries**: 
```dart
// Add indexes di migration
await m.createIndex('idx_users_email', 'users(email)');
```

**Large database**:
```dart
// Use DatabaseService.batch() untuk bulk operations
await ServiceLocator().databaseService.batch([
  () => insertData1(),
  () => insertData2(),
  // ...
]);
```

## 📱 Feature Overview

### Current Features
- ✅ User Authentication & Registration
- ✅ Profile Management  
- ✅ Workout Planning & Tracking
- ✅ Body Metrics Tracking
- ✅ Sleep Tracker
- ✅ Meal Planner
- ✅ Photo Progress
- ✅ AI Chat Integration

### Upcoming Features
- 🔄 Enhanced AI workout recommendations
- 🔄 Social features & community
- 🔄 Nutrition analysis
- 🔄 Advanced progress tracking

## 🔐 Security Features

### Data Protection
- **PBKDF2**: Password hashing dengan salt
- **SQL Injection**: Prevention dengan parameterized queries
- **Data Encryption**: Sensitive data encryption (future)
- **Local Storage**: All data stored locally

### Privacy
- No cloud storage by default
- User data stays on device
- Optional cloud backup (future)

## 📞 Support

Untuk issue dan bug reports:
1. Check Flutter logs: `flutter logs`
2. Check database logs: Enable drift logging
3. Test dengan fresh database: Clear app data
4. Reproduce issue dengan minimal example

---

**Note**: Aplikasi ini menggunakan local storage untuk privacy maksimal. Pastikan untuk backup data penting secara manual jika diperlukan.