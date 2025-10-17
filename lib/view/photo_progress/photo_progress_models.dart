// lib/view/photo_progress/photo_progress_models.dart

import 'package:aigymbuddy/common/localization/app_language.dart';

/// Signature used throughout the photo progress feature to localize
/// [LocalizedText] values with the active [BuildContext].
typedef Localizer = String Function(LocalizedText text);

/// Represents a collection of progress photos captured on a specific date.
class PhotoProgressGroup {
  const PhotoProgressGroup({required this.date, required this.photos});

  final DateTime date;
  final List<String> photos;
}

/// Describes a pair of photos that should be compared side-by-side.
class PhotoComparison {
  const PhotoComparison({
    required this.title,
    required this.firstImagePath,
    required this.secondImagePath,
  });

  final LocalizedText title;
  final String firstImagePath;
  final String secondImagePath;
}

/// Holds the statistics shown inside the progress result screen.
class ProgressStatistic {
  const ProgressStatistic({
    required this.title,
    required this.firstPercent,
    required this.secondPercent,
  });

  final LocalizedText title;
  final int firstPercent;
  final int secondPercent;

  double get firstRatio {
    final total = firstPercent + secondPercent;
    if (total == 0) {
      return 0;
    }
    return firstPercent / total;
  }
}

/// Provides utility methods that depend on the active [AppLanguage].
abstract final class PhotoProgressLocalizationHelper {
  static String? monthShortLabel(AppLanguage language, int monthIndex) {
    const english = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
    };
    const indonesian = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'Mei',
      6: 'Jun',
      7: 'Jul',
    };

    final labels = language == AppLanguage.indonesian ? indonesian : english;
    return labels[monthIndex];
  }

  static String minutesAgo(AppLanguage language, int minutes) {
    final suffix =
        language == AppLanguage.indonesian ? 'menit lalu' : 'mins ago';
    return '$minutes $suffix';
  }
}
