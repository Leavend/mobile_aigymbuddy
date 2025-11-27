// lib/view/home/home_view.dart

import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/constants/ui_constants.dart';
import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aigymbuddy/view/base/base_view.dart';
import 'package:aigymbuddy/view/home/controllers/home_controller.dart';
import 'package:provider/provider.dart';

import 'widgets/bmi_card.dart';
import 'widgets/heart_rate_card.dart';
import 'widgets/hydration_rest_section.dart';
import 'widgets/latest_workout_section.dart';
import 'widgets/today_target_card.dart';
import 'widgets/workout_progress_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: const _HomeContent(),
    );
  }
}

class _HomeContent extends BaseView<HomeController> {
  const _HomeContent();

  @override
  Widget buildContent(BuildContext context, HomeController controller) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: UIConstants.spacingMedium,
              vertical: UIConstants.spacingMedium,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: UIConstants.spacingMedium),
                  BmiCard(
                    title: _HomeStrings.bmiTitle,
                    subtitle: _HomeStrings.bmiSubtitle,
                    buttonText: _HomeStrings.viewMore,
                  ),
                  const SizedBox(height: UIConstants.spacingMedium),
                  TodayTargetCard(
                    title: _HomeStrings.todayTarget,
                    buttonText: _HomeStrings.check,
                  ),
                  const SizedBox(height: UIConstants.spacingMedium),
                  Text(
                    context.localize(_HomeStrings.activityStatus),
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: UIConstants.fontSizeMedium,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: UIConstants.spacingSmall),
                  HeartRateCard(
                    title: _HomeStrings.heartRate,
                    nowLabel: _HomeStrings.nowLabel,
                    spots: controller.heartRateSpots,
                  ),
                  const SizedBox(height: UIConstants.spacingMedium),
                  HydrationRestSection(
                    waterIntakeTitle: _HomeStrings.waterIntake,
                    realTimeUpdatesLabel: _HomeStrings.realTimeUpdates,
                    waterSchedule: controller.waterSchedule,
                    sleepTitle: _HomeStrings.sleep,
                    caloriesTitle: _HomeStrings.calories,
                    caloriesLeftLabel: _HomeStrings.caloriesLeft,
                    calorieProgressNotifier: ValueNotifier(
                      controller.calorieProgress,
                    ), // TODO: Optimize this
                  ),
                  const SizedBox(height: UIConstants.spacingLarge),
                  WorkoutProgressSection(
                    title: _HomeStrings.workoutProgress,
                    periodOptions: _periodOptions,
                    nowLabel: _HomeStrings.nowLabel,
                    weekdayAbbreviations: _HomeStrings.weekdayAbbreviations,
                  ),
                  const SizedBox(height: UIConstants.spacingMedium),
                  LatestWorkoutSection(
                    title: _HomeStrings.latestWorkout,
                    seeMoreLabel: _HomeStrings.seeMore,
                    workouts: controller.lastWorkoutList,
                  ),
                  const SizedBox(height: UIConstants.spacingXLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const List<PeriodOption> _periodOptions = [
    PeriodOption(
      key: 'weekly',
      label: LocalizedText(english: 'Weekly', indonesian: 'Mingguan'),
    ),
    PeriodOption(
      key: 'monthly',
      label: LocalizedText(english: 'Monthly', indonesian: 'Bulanan'),
    ),
  ];

  Widget _buildHeader(BuildContext context) {
    final localize = context.localize;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localize(_HomeStrings.welcomeBack),
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
            Text(
              localize(_HomeStrings.userName),
              style: TextStyle(
                color: TColor.black,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => context.push(AppRoute.notification),
          icon: Image.asset(
            'assets/img/notification_active.png',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}

class _HomeStrings {
  static const welcomeBack = LocalizedText(
    english: 'Welcome Back,',
    indonesian: 'Selamat Datang,',
  );
  static const userName = LocalizedText(
    english: 'Stefani Wong',
    indonesian: 'Stefani Wong',
  );
  static const bmiTitle = LocalizedText(
    english: 'BMI (Body Mass Index)',
    indonesian: 'IMT (Indeks Massa Tubuh)',
  );
  static const bmiSubtitle = LocalizedText(
    english: 'You have a normal weight',
    indonesian: 'Berat badan Anda normal',
  );
  static const viewMore = LocalizedText(
    english: 'View More',
    indonesian: 'Lihat Detail',
  );
  static const todayTarget = LocalizedText(
    english: 'Today Target',
    indonesian: 'Target Hari Ini',
  );
  static const check = LocalizedText(english: 'Check', indonesian: 'Cek');
  static const activityStatus = LocalizedText(
    english: 'Activity Status',
    indonesian: 'Status Aktivitas',
  );
  static const heartRate = LocalizedText(
    english: 'Heart Rate',
    indonesian: 'Detak Jantung',
  );
  static const nowLabel = LocalizedText(english: 'Now', indonesian: 'Skrg');
  static const waterIntake = LocalizedText(
    english: 'Water Intake',
    indonesian: 'Asupan Air',
  );
  static const realTimeUpdates = LocalizedText(
    english: 'Real time updates',
    indonesian: 'Update real-time',
  );
  static const sleep = LocalizedText(english: 'Sleep', indonesian: 'Tidur');
  static const calories = LocalizedText(
    english: 'Calories',
    indonesian: 'Kalori',
  );
  static const caloriesLeft = LocalizedText(
    english: 'Calories\nLeft',
    indonesian: 'Sisa\nKalori',
  );
  static const workoutProgress = LocalizedText(
    english: 'Workout Progress',
    indonesian: 'Progres Latihan',
  );
  static const latestWorkout = LocalizedText(
    english: 'Latest Workout',
    indonesian: 'Latihan Terakhir',
  );
  static const seeMore = LocalizedText(
    english: 'See More',
    indonesian: 'Lihat Semua',
  );
  static const weekdayAbbreviations = [
    LocalizedText(english: 'Sun', indonesian: 'Min'),
    LocalizedText(english: 'Mon', indonesian: 'Sen'),
    LocalizedText(english: 'Tue', indonesian: 'Sel'),
    LocalizedText(english: 'Wed', indonesian: 'Rab'),
    LocalizedText(english: 'Thu', indonesian: 'Kam'),
    LocalizedText(english: 'Fri', indonesian: 'Jum'),
    LocalizedText(english: 'Sat', indonesian: 'Sab'),
  ];
}
