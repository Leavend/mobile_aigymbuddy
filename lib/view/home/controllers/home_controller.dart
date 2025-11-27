import 'package:aigymbuddy/common/localization/app_language.dart';
import 'package:aigymbuddy/view/home/widgets/hydration_rest_section.dart';
import 'package:aigymbuddy/view/home/widgets/latest_workout_section.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  HomeController() {
    // Initialize ValueNotifier with initial calorie progress
    _calorieProgressNotifier = ValueNotifier<double>(_calorieProgress);
  }

  // TODO: Fetch this data from repository

  final List<WorkoutConfig> lastWorkoutList = const [
    WorkoutConfig(
      name: LocalizedText(
        english: 'Full Body Workout',
        indonesian: 'Latihan Seluruh Tubuh',
      ),
      image: 'assets/img/Workout1.png',
      calories: '180',
      minutes: '20',
      progress: 0.3,
    ),
    WorkoutConfig(
      name: LocalizedText(
        english: 'Lower Body Workout',
        indonesian: 'Latihan Tubuh Bagian Bawah',
      ),
      image: 'assets/img/Workout2.png',
      calories: '200',
      minutes: '30',
      progress: 0.4,
    ),
    WorkoutConfig(
      name: LocalizedText(english: 'Ab Workout', indonesian: 'Latihan Perut'),
      image: 'assets/img/Workout3.png',
      calories: '300',
      minutes: '40',
      progress: 0.7,
    ),
  ];

  final List<WaterIntakeEntry> waterSchedule = const [
    WaterIntakeEntry('6am - 8am', '600ml'),
    WaterIntakeEntry('9am - 11am', '500ml'),
    WaterIntakeEntry('11am - 2pm', '1000ml'),
    WaterIntakeEntry('2pm - 4pm', '700ml'),
    WaterIntakeEntry('4pm - now', '900ml'),
  ];

  final List<FlSpot> heartRateSpots = const [
    FlSpot(0, 20),
    FlSpot(1, 25),
    FlSpot(2, 40),
    FlSpot(3, 50),
    FlSpot(4, 35),
    FlSpot(5, 40),
    FlSpot(6, 30),
    FlSpot(7, 20),
    FlSpot(8, 25),
    FlSpot(9, 40),
    FlSpot(10, 50),
    FlSpot(11, 35),
    FlSpot(12, 50),
    FlSpot(13, 60),
    FlSpot(14, 40),
    FlSpot(15, 50),
    FlSpot(16, 20),
    FlSpot(17, 25),
    FlSpot(18, 40),
    FlSpot(19, 50),
    FlSpot(20, 35),
    FlSpot(21, 80),
    FlSpot(22, 30),
    FlSpot(23, 20),
    FlSpot(24, 25),
    FlSpot(25, 40),
    FlSpot(26, 50),
    FlSpot(27, 35),
    FlSpot(28, 50),
    FlSpot(29, 60),
    FlSpot(30, 40),
  ];

  double _calorieProgress = 50;
  late ValueNotifier<double> _calorieProgressNotifier;

  double get calorieProgress => _calorieProgress;
  ValueNotifier<double> get calorieProgressNotifier => _calorieProgressNotifier;

  void updateCalorieProgress(double value) {
    _calorieProgress = value;
    _calorieProgressNotifier.value = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _calorieProgressNotifier.dispose();
    super.dispose();
  }
}
