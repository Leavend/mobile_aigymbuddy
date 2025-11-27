# AI Gym Buddy - Architecture Documentation

## 📐 Architecture Overview

AI Gym Buddy is built using **Clean Architecture** principles with a clear separation of concerns across multiple layers. The application follows Flutter best practices and uses modern state management patterns.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────┐
│                  Presentation Layer                 │
│  (Views, Widgets, Controllers - State Management)  │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│                   Domain Layer                      │
│        (Use Cases, Business Logic, Models)          │
└────────────────┬────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│                    Data Layer                       │
│   (Repositories, Database, External Data Sources)   │
└─────────────────────────────────────────────────────┘
```

## 🗂️ Project Structure

```
lib/
├── auth/                      # Authentication feature
│   ├── controllers/          # AuthController (state management)
│   ├── models/               # AuthUser, SignUpData
│   ├── repositories/         # AuthRepositoryInterface
│   └── usecases/            # AuthUseCase (business logic)
│
├── common/                   # Shared utilities and services
│   ├── constants/           # App-wide constants
│   ├── di/                  # Dependency Injection (ServiceLocator)
│   ├── error_handling/      # Centralized error handling
│   ├── exceptions/          # Custom exception classes
│   ├── localization/        # i18n support
│   ├── models/              # Shared data models
│   └── services/            # Logging, Auth, Database services
│
├── common_widget/            # Reusable UI components
│   ├── round_button.dart
│   ├── round_textfield.dart
│   └── ...
│
├── database/                 # Data persistence layer
│   ├── connection/          # Database connection handling
│   ├── daos/                # Data Access Objects
│   ├── repositories/        # Repository implementations
│   ├── tables/              # Drift table definitions
│   ├── app_db.dart          # Main database class
│   └── database_service.dart # Database operations wrapper
│
├── view/                     # UI layer
│   ├── base/                # Base view classes
│   ├── home/                # Home feature views
│   ├── login/               # Authentication views
│   ├── profile/             # Profile feature views
│   ├── workout_tracker/     # Workout tracking views
│   ├── meal_planner/        # Meal planning views
│   ├── sleep_tracker/       # Sleep tracking views
│   └── ...
│
└── main.dart                 # Application entry point
```

## 🏛️ Layer Responsibilities

### 1. Presentation Layer (`view/`)

**Responsibility:** Display UI and handle user interactions

**Components:**
- **Views:** Top-level screens (StatelessWidget or StatefulWidget)
- **Controllers:** State management using Provider + ChangeNotifier
- **Widgets:** Reusable UI components

**Rules:**
- Views should be as dumb as possible
- Business logic belongs in controllers/use cases
- Use dependency injection for all services
- Never access database directly from views

**Example:**
```dart
class HomeView extends BaseView<HomeController> {
  @override
  Widget buildContent(BuildContext context, HomeController controller) {
    return Scaffold(
      body: controller.isLoading 
        ? CircularProgressIndicator()
        : HomeContent(data: controller.data),
    );
  }
}
```

### 2. Domain Layer (`auth/usecases/`, business logic)

**Responsibility:** Business logic and use cases

**Components:**
- **Use Cases:** Encapsulate business operations (e.g., `LoginUseCase`, `RegisterUseCase`)
- **Domain Models:** Pure Dart objects representing business entities
- **Repository Interfaces:** Define contracts for data access

**Rules:**
- Should not depend on Flutter framework
- Should not know about database implementation details
- Should define interfaces, not implementations
- Use dependency inversion (depend on abstractions)

**Example:**
```dart
abstract class AuthUseCase {
  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser> register(SignUpData data);
  Future<void> logout();
  Future<bool> isLoggedIn();
}

class AuthUseCaseImpl implements AuthUseCase {
  final AuthRepositoryInterface repository;
  
  AuthUseCaseImpl({required this.repository});
  
  @override
  Future<AuthUser> login({required String email, required String password}) {
    // Business logic here
    return repository.login(email, password);
  }
}
```

### 3. Data Layer (`database/`)

**Responsibility:** Data persistence and external data sources

**Components:**
- **Repositories:** Implement repository interfaces from domain layer
- **Database:** Drift-based SQLite database
- **DAOs:** Data Access Objects for specific tables
- **Database Service:** Transaction management and operations wrapper

**Rules:**
- Never expose database-specific types to upper layers
- Convert database models to domain models
- Handle all data persistence logic
- Implement caching strategies when needed

**Example:**
```dart
class AuthRepository implements AuthRepositoryInterface {
  final AppDatabase db;
  
  AuthRepository(this.db);
  
  @override
  Future<AuthUser> login(String email, String password) async {
    final dbUser = await db.getUserByEmail(email);
    // Convert database user to domain user
    return AuthUser.fromDb(dbUser);
  }
}
```

## 🔄 Data Flow

### Typical User Action Flow:

```
User Interaction (View)
         ↓
Controller Method Called
         ↓
Use Case Executed (Business Logic)
         ↓
Repository Method Called
         ↓
Database Operation
         ↓
Result Returns Up the Chain
         ↓
Controller Updates State (notifyListeners)
         ↓
UI Rebuilds (Consumer<Controller>)
```

### Example: Login Flow

```dart
// 1. User taps login button
onPressed: () => controller.login(email, password)

// 2. Controller delegates to use case
class AuthController {
  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      final user = await useCase.login(email: email, password: password);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      setLoading(false);
    }
  }
}

// 3. Use case executes business logic
class AuthUseCaseImpl {
  Future<AuthUser> login({required String email, required String password}) {
    // Validate inputs
    // Call repository
    return repository.login(email, password);
  }
}

// 4. Repository accesses data
class AuthRepository {
  Future<AuthUser> login(String email, String password) async {
    final dbUser = await db.getUserByEmail(email);
    if (isPasswordValid(dbUser, password)) {
      return AuthUser.fromDb(dbUser);
    }
    throw AuthException('Invalid credentials');
  }
}
```

## 🔌 Dependency Injection

We use the **Service Locator pattern** for dependency injection.

### ServiceLocator (`common/di/service_locator.dart`)

```dart
class ServiceLocator {
  static final _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  
  AppDatabase? _database;
  DatabaseService? _databaseService;
  AuthRepositoryInterface? _authRepository;
  
  Future<void> initialize() async {
    _database = AppDatabase();
    _databaseService = DatabaseService(_database!);
    _authRepository = AuthRepository(_database!);
    // ... initialize other dependencies
  }
  
  AppDatabase get database => _database!;
  DatabaseService get databaseService => _databaseService!;
  AuthRepositoryInterface get authRepository => _authRepository!;
}
```

### Usage in main.dart:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service locator
  await ServiceLocator().initialize();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: ServiceLocator().database),
        Provider<AuthRepositoryInterface>.value(
          value: ServiceLocator().authRepository,
        ),
        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(
            useCase: ServiceLocator().authUseCase,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}
```

## 🎯 State Management

We use **Provider + ChangeNotifier** for state management.

### Pattern:

1. **Controllers** extend `ChangeNotifier`
2. **Views** consume controllers via `Consumer<T>` or `Provider.of<T>`
3. **Controllers** call `notifyListeners()` when state changes

### Example:

```dart
// Controller
class HomeController extends ChangeNotifier {
  bool _isLoading = false;
  List<Workout> _workouts = [];
  
  bool get isLoading => _isLoading;
  List<Workout> get workouts => _workouts;
  
  Future<void> loadWorkouts() async {
    _isLoading = true;
    notifyListeners();
    
    _workouts = await repository.getWorkouts();
    
    _isLoading = false;
    notifyListeners();
  }
}

// View
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return CircularProgressIndicator();
        }
        return WorkoutList(workouts: controller.workouts);
      },
    );
  }
}
```

## 🗺️ Navigation

We use **GoRouter** for type-safe, declarative routing.

### Router Configuration (`common/app_router.dart`):

```dart
class AppRouter {
  static GoRouter createRouter({required String initialLocation}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginView(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeView(),
        ),
        // Nested routes with parameters
        GoRoute(
          path: '/workout/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return WorkoutDetailView(workoutId: id);
          },
        ),
      ],
    );
  }
}
```

### Navigation with Type-Safe Arguments:

```dart
// Define argument class
class WorkoutDetailArgs {
  final Workout workout;
  WorkoutDetailArgs(this.workout);
}

// Navigate with extra data
context.push(
  AppRoute.workoutDetail,
  extra: WorkoutDetailArgs(workout),
);

// Access in destination
final args = state.extra as WorkoutDetailArgs;
return WorkoutDetailView(workout: args.workout);
```

## 💾 Database Architecture

We use **Drift** (formerly Moor) as our database layer.

### Key Components:

1. **Tables** (`database/tables/`) - Define database schema
2. **DAOs** (`database/daos/`) - Data access logic
3. **Repositories** (`database/repositories/`) - Business-oriented data access
4. **Database Service** - Transaction management

### Database Features:

- ✅ Type-safe queries
- ✅ Generated code for boilerplate
- ✅ Migration support
- ✅ Transaction management
- ✅ WAL mode for performance
- ✅ Foreign key constraints

## 🔒 Security Practices

1. **Password Hashing:** PBKDF2 with salt
2. **SQL Injection Prevention:** Parameterized queries (Drift handles this)
3. **Local Storage:** Encrypted shared preferences for sensitive data
4. **Input Validation:** Server-side and client-side validation

## 🧪 Testing Strategy

### Test Types:

1. **Unit Tests** - Business logic, use cases, repositories
2. **Widget Tests** - Individual widgets and views
3. **Integration Tests** - Full user flows

### Test Structure:

```
test/
├── unit/
│   ├── controllers/
│   ├── usecases/
│   └── repositories/
├── widget/
│   └── views/
├── integration/
└── helpers/
    └── test_helpers.dart
```

## 📊 Performance Considerations

1. **Const Widgets:** Use `const` constructors wherever possible
2. **RepaintBoundary:** Wrap expensive widgets
3. **ListView Builders:** Use for long lists
4. **Cached Network Images:** For remote images
5. **Database Indexing:** Index frequently queried columns
6. **Lazy Loading:** Load data on demand

## 🔄 Future Improvements

1. **State Management:** Consider migrating to Riverpod for better testability
2. **Offline Support:** Implement sync mechanism for offline data
3. **Error Tracking:** Integrate Sentry or similar for production errors
4. **Analytics:** Add Firebase Analytics for user behavior insights
5. **CI/CD:** Set up automated testing and deployment pipeline

---

**Last Updated:** 2025-11-21  
**Version:** 1.0.0
