# Testing Guide: Database Persistence Fix

## 🎯 Tujuan Testing

Memverifikasi bahwa data tersimpan dengan baik di database dan **TIDAK HILANG** ketika aplikasi ditutup, baik di Web maupun iOS.

---

## 🌐 Testing di Web (Chrome)

### Langkah 1: Jalankan Aplikasi

```bash
cd /Users/leavend/Documents/AI-GYM-Buddy/aigymbuddy
flutter run -d chrome
```

### Langkah 2: Buat Test Data

1. **Login/Register** dengan akun baru
2. **Tambahkan data berikut:**
   - Buat workout plan
   - Tambahkan meal
   - Input sleep record
   - Tambahkan body metrics (berat, tinggi, dll)

### Langkah 3: Verifikasi IndexedDB

Buka Chrome DevTools (F12) → **Application** tab:

1. Di sidebar kiri, cari **IndexedDB**
2. Expand → Cari `gym_buddy_db`
3. **Verifikasi:**
   - ✅ Database `gym_buddy_db` ada
   - ✅ Tables berisi data (users, workouts, meals, etc.)

### Langkah 4: Test Persistence

**PENTING:** Lakukan test ini untuk memverifikasi persistence!

1. **Tutup browser tab** (jangan hanya refresh)
2. **Buka aplikasi lagi:**
   ```bash
   flutter run -d chrome
   ```
3. **Verifikasi:**
   - ✅ User masih login
   - ✅ Semua data workout/meal/sleep masih ada
   - ✅ Tidak ada data loss

### Langkah 5: Check Console Logs

Di Chrome Console, lihat log berikut:

```
✅ Expected logs:
[INFO] Web database using implementation: sharedIndexedDb
[INFO] Web database initialized successfully with persistence

❌ BAD logs (jika muncul ini, ada masalah):
[ERROR] WARNING: Database is in-memory only!
```

**Implementasi yang BAIK:**
- `sharedIndexedDb` - ✅ TERBAIK (safe untuk multiple tabs)
- `unsafeIndexedDb` - ✅ OK (persistent, tapi tidak safe untuk multiple tabs)
- `opfsShared` atau `opfsLocks` - ✅ TERBAIK (jika browser support)

**Implementasi yang BURUK:**
- `inMemory` - ❌ DATA AKAN HILANG!

---

## 📱 Testing di iOS

### Langkah 1: Jalankan di iOS Simulator

```bash
flutter run -d iPhone
```

**Atau untuk specific simulator:**
```bash
# List available simulators
xcrun simctl list devices

# Run on specific device
flutter run -d "iPhone 15 Pro"
```

### Langkah 2: Buat Test Data

1. Login/Register dengan akun
2. Tambahkan data:
   - Workout plan
   - Meal records
   - Sleep tracking
   - Body metrics

### Langkah 3: Check Database File

Lihat console log untuk database path:

```
[INFO] Database path: /Users/.../Documents/gym_buddy_db.sqlite
[INFO] Database file exists before init: true
[INFO] Database file created successfully (size: 32768 bytes)
```

**Verifikasi:**
- ✅ Path mengarah ke `Documents` directory (persistent)
- ✅ File size > 0 bytes
- ✅ File exists = true

### Langkah 4: Test Persistence

**CRITICAL TEST:**

1. **Force quit aplikasi:**
   - Double-tap home button (atau swipe up dari bawah)
   - Swipe up pada app preview untuk force quit
2. **Buka aplikasi lagi**
3. **Verifikasi:**
   - ✅ User masih login
   - ✅ Semua data masih ada
   - ✅ Database file size tetap sama atau bertambah

### Langkah 5: Check for Bad Logs

**❌ TIDAK BOLEH muncul log ini:**
```
[WARNING] Falling back to in-memory database
```

Jika log tersebut muncul, berarti ada error dan database menggunakan in-memory!

---

## 🤖 Testing di Android (Regression Test)

Pastikan fix tidak break Android:

```bash
flutter run -d android
```

**Test yang sama:**
1. Buat data
2. Force quit app
3. Buka lagi
4. ✅ Verifikasi data masih ada

---

## 🔍 Debug Tips

### Web: Inspect IndexedDB Content

Untuk melihat isi database:

1. Chrome DevTools → Application → IndexedDB → `gym_buddy_db`
2. Click pada table (contoh: `users`)
3. Lihat data yang tersimpan

### iOS: Find Database File

Jika ingin melihat file SQLite langsung:

```bash
# Get simulator path from console log, example:
# /Users/leavend/Library/Developer/CoreSimulator/Devices/.../Documents/gym_buddy_db.sqlite

# Open with SQLite browser
sqlite3 <path_to_db>

# Check tables
.tables

# Check data
SELECT * FROM users;
```

### Check Implementation Being Used

Tambahkan ini di console saat app running (web):

```javascript
// Open IndexedDB to see if data exists
indexedDB.databases().then(dbs => console.log('IndexedDB databases:', dbs));
```

---

## ✅ Success Criteria

### Web Platform

- [x] IndexedDB database `gym_buddy_db` terlihat di DevTools
- [x] Data tersimpan di IndexedDB tables
- [x] Console log menunjukkan `sharedIndexedDb` atau `unsafeIndexedDb`
- [x] Data persist setelah browser tab ditutup
- [x] Data persist setelah browser refresh

### iOS Platform

- [x] Database file dibuat di Documents directory
- [x] File size > 0 bytes dan bertambah saat ada data baru
- [x] Tidak ada fallback ke in-memory
- [x] Data persist setelah force quit app
- [x] Data persist setelah device restart

### Android Platform

- [x] Data persist seperti biasa (tidak ada regression)

---

## 🐛 Troubleshooting

### Web: "inMemory" implementation dipilih

**Masalah:** Browser tidak support IndexedDB atau SharedWorker

**Solusi:**
1. Update browser ke versi terbaru
2. Gunakan browser modern (Chrome, Firefox, Edge)
3. Check jika browser dalam "Incognito mode" - some browsers disable IndexedDB in incognito

### iOS: "Falling back to in-memory database"

**Masalah:** Gagal membuat database file

**Solusi:**
1. Check permissions
2. Check disk space
3. Lihat stack trace di console untuk error detail

### Data Hilang Setelah Restart

**Cek:**
1. Web: Verifikasi IndexedDB tidak di-clear oleh browser settings
2. iOS: Verifikasi database path di Documents (bukan tmp atau cache)
3. Check console logs untuk implementation yang digunakan

---

## 📊 Expected Results Summary

| Platform | Storage Location | Implementation | Data Persists? |
|----------|------------------|----------------|----------------|
| Web | IndexedDB | sharedIndexedDb | ✅ YES |
| Web | IndexedDB | unsafeIndexedDb | ✅ YES |
| Web | In-Memory | inMemory | ❌ NO (browser issue) |
| iOS | Documents/*.sqlite | Native File | ✅ YES |
| Android | /data/data/.../databases | Native File | ✅ YES |

**Target:** Semua platform harus **✅ YES**

---

**Created:** 2025-11-21  
**Last Updated:** 2025-11-21
