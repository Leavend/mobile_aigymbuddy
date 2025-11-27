/// Application-wide constants.
///
/// This file contains constants used throughout the application.
/// Organize constants by category for better maintainability.
abstract final class AppConstants {
  // Prevent instantiation
  AppConstants._();

  /// Application metadata
  static const String appName = 'AI Gym Buddy';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  /// Timeouts and delays
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashScreenDuration = Duration(seconds: 2);

  /// Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;

  /// Storage keys (SharedPreferences)
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyLanguage = 'language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingCompleted = 'onboarding_completed';

  /// Regular expressions
  static final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  static final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
  static final phoneRegex = RegExp(r'^\+?[\d\s-]+$');

  /// Asset paths
  static const String assetImgPath = 'assets/img/';
  static const String assetFontPath = 'assets/font/';

  /// Image assets
  static const String logoPath = '${assetImgPath}logo.png';
  static const String placeholderPath = '${assetImgPath}placeholder.png';

  /// Workout constants
  static const int minWorkoutDurationMinutes = 5;
  static const int maxWorkoutDurationMinutes = 180;
  static const int defaultWorkoutDurationMinutes = 30;

  /// Health metrics
  static const int minHeartRate = 40;
  static const int maxHeartRate = 220;
  static const int minCalories = 0;
  static const int maxCalories = 10000;
  static const double minWaterIntakeLiters = 0.0;
  static const double maxWaterIntakeLiters = 10.0;
  static const int minSleepHours = 0;
  static const int maxSleepHours = 24;

  /// BMI ranges
  static const double underweightBMI = 18.5;
  static const double normalBMI = 24.9;
  static const double overweightBMI = 29.9;
  // Above 29.9 is obese

  /// UI constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double buttonHeight = 50.0;
  static const double iconSize = 24.0;

  /// Chart constants
  static const int heartRateChartPoints = 30;
  static const int workoutProgressDays = 7;
  static const double chartMinHeight = 160.0;
  static const double chartMaxHeight = 300.0;

  /// Error messages (fallback/default)
  static const String errorGeneric = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String errorNetwork =
      'Tidak dapat terhubung. Periksa koneksi internet Anda.';
  static const String errorTimeout = 'Permintaan timeout. Silakan coba lagi.';
  static const String errorUnauthorized =
      'Sesi Anda telah berakhir. Silakan login kembali.';
  static const String errorNotFound = 'Data tidak ditemukan.';
  static const String errorServer = 'Server error. Silakan coba lagi nanti.';

  /// Success messages
  static const String successGeneric = 'Berhasil!';
  static const String successSaved = 'Data berhasil disimpan.';
  static const String successDeleted = 'Data berhasil dihapus.';
  static const String successUpdated = 'Data berhasil diperbarui.';

  /// Feature flags (for gradual rollout)
  static const bool enableAdvancedWorkoutTracking = true;
  static const bool enableSocialSharing = false;
  static const bool enableNotifications = true;
  static const bool enableBiometricAuth = false;
}
