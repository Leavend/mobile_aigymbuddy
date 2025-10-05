# Onboarding & Profile Data Capture Review

## Scope
This document evaluates whether the current Flutter implementation allows end-to-end testing of the MVP's first feature: collecting onboarding and profile information (age, height, weight, gender, target goal, and fitness level) and persisting it.

## User Flow Overview
1. **OnBoardingView** (`lib/view/on_boarding/on_boarding_view.dart`) presents marketing slides and, on completion, routes users to the sign-up screen via `context.go(AppRoute.signUp)`.
2. **SignUpView** (`lib/view/login/signup_view.dart`) offers text fields for first name, last name, email, and password but does not submit or store the data before pushing to the complete profile screen.
3. **CompleteProfileView** (`lib/view/login/complete_profile_view.dart`) captures gender (dropdown), date of birth (mapped to age), weight, and height, yet the collected values are never validated, saved, or propagated to a backing store.
4. **WhatYourGoalView** (`lib/view/login/what_your_goal_view.dart`) displays a carousel of goals but lacks selection state management or persistence; pressing "Confirm" simply navigates to the welcome screen.
5. **WelcomeView** (`lib/view/login/welcome_view.dart`) marks onboarding complete by toggling a `SharedPreferences` flag (`AuthService.setHasCredentials(true)`) without saving any profile attributes.

## Data Persistence & Validation Findings
- There is **no integration with Drift** (or any database layer) anywhere in the project. The codebase never imports Drift packages nor defines data access objects, so profile data cannot be stored locally yet.
- None of the onboarding/profile screens call into a repository or service to persist the captured values. The only state written to storage is a boolean flag signaling that onboarding has finished.
- Form fields lack validation or controllers in several cases (e.g., the sign-up form's text fields are `const` and uncontrolled), preventing realistic data handling.
- Fitness **level selection is entirely absent**—no view provides a UI to choose experience level, and no data structure references it.

## Conclusion
The current implementation does **not** allow you to test the full "Onboarding & Profil Pengguna" feature. While the UI screens exist, they operate as static flows with no data persistence or level selection. To make this feature testable, you will need to:
- Implement storage (e.g., Drift) for user profile attributes.
- Wire the onboarding forms to controllers, validation, and a repository/service layer that persists age, height, weight, gender, target goal, and fitness level.
- Add UI and logic to capture the user's fitness level alongside the existing goal carousel.
- Ensure saved data is surfaced later (e.g., in `ProfileView`) to verify persistence end-to-end.
