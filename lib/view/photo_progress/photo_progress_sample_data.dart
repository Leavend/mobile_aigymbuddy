// lib/view/photo_progress/photo_progress_sample_data.dart

import 'package:aigymbuddy/common/localization/app_language.dart';

import 'photo_progress_models.dart';

final samplePhotoGroups = <PhotoProgressGroup>[
  PhotoProgressGroup(
    date: DateTime(2023, 6, 2),
    photos: [
      'assets/img/pp_1.png',
      'assets/img/pp_2.png',
      'assets/img/pp_3.png',
      'assets/img/pp_4.png',
    ],
  ),
  PhotoProgressGroup(
    date: DateTime(2023, 5, 5),
    photos: [
      'assets/img/pp_5.png',
      'assets/img/pp_6.png',
      'assets/img/pp_7.png',
      'assets/img/pp_8.png',
    ],
  ),
];

final samplePhotoComparisons = <PhotoComparison>[
  PhotoComparison(
    title: LocalizedText(english: 'Front Facing', indonesian: 'Tampak Depan'),
    firstImagePath: 'assets/img/pp_1.png',
    secondImagePath: 'assets/img/pp_2.png',
  ),
  PhotoComparison(
    title: LocalizedText(english: 'Back Facing', indonesian: 'Tampak Belakang'),
    firstImagePath: 'assets/img/pp_3.png',
    secondImagePath: 'assets/img/pp_4.png',
  ),
  PhotoComparison(
    title: LocalizedText(english: 'Left Facing', indonesian: 'Tampak Kiri'),
    firstImagePath: 'assets/img/pp_5.png',
    secondImagePath: 'assets/img/pp_6.png',
  ),
  PhotoComparison(
    title: LocalizedText(english: 'Right Facing', indonesian: 'Tampak Kanan'),
    firstImagePath: 'assets/img/pp_7.png',
    secondImagePath: 'assets/img/pp_8.png',
  ),
];

final sampleProgressStatistics = <ProgressStatistic>[
  ProgressStatistic(
    title: LocalizedText(
      english: 'Lose Weight',
      indonesian: 'Turun Berat Badan',
    ),
    firstPercent: 33,
    secondPercent: 67,
  ),
  ProgressStatistic(
    title: LocalizedText(
      english: 'Height Increase',
      indonesian: 'Tinggi Bertambah',
    ),
    firstPercent: 88,
    secondPercent: 12,
  ),
  ProgressStatistic(
    title: LocalizedText(
      english: 'Muscle Mass Increase',
      indonesian: 'Peningkatan Massa Otot',
    ),
    firstPercent: 57,
    secondPercent: 43,
  ),
  ProgressStatistic(
    title: LocalizedText(english: 'Abs', indonesian: 'Otot Perut'),
    firstPercent: 89,
    secondPercent: 11,
  ),
];
