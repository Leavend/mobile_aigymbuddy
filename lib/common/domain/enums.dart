// lib/common/domain/enums.dart

/// Enumerations shared across the application and persistence layers.
///
/// Keeping the enums in a dedicated domain file avoids tight coupling between
/// the database schema and the rest of the code base while still allowing the
/// Drift tables to reuse the same definitions through imports.
enum UserRole { user, admin }

enum Gender { male, female, other }

enum Level { beginner, intermediate, advanced }

enum Goal { fatLoss, muscleGain, maintain }

enum LocationPref { home, gym }

enum Difficulty { beginner, intermediate, advanced }

enum SuggestionType {
  motivation,
  quickWorkout,
  nutritionTip,
  formCue,
  planChange,
}

enum MuscleGroup { chest, back, shoulders, arms, legs, core, fullBody }
