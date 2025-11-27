# Contributing to AI Gym Buddy

Thank you for your interest in contributing to AI Gym Buddy! This document provides guidelines and best practices for contributing to the project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Code Style Guidelines](#code-style-guidelines)
- [Commit Message Convention](#commit-message-convention)
- [Pull Request Process](#pull-request-process)
- [Testing Requirements](#testing-requirements)

## 🤝 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (version 3.9.0 or higher)
- Dart SDK (included with Flutter)
- IDE (VS Code or Android Studio recommended)
- Git

### Setup Development Environment

1. **Fork and clone the repository:**
   ```bash
   git clone https://github.com/yourusername/aigymbuddy.git
   cd aigymbuddy
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run code generation (if needed):**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

5. **Run tests:**
   ```bash
   flutter test
   ```

## 🔄 Development Workflow

### Branch Naming Convention

Use descriptive branch names with prefixes:

- `feature/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation updates
- `test/` - Test additions or modifications

**Examples:**
```
feature/add-workout-history
fix/login-validation-error
refactor/home-view-state-management
docs/update-api-documentation
test/add-auth-controller-tests
```

### Development Process

1. **Create a new branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes:**
   - Write clean, well-documented code
   - Follow the code style guidelines
   - Add tests for new functionality
   - Update documentation as needed

3. **Test your changes:**
   ```bash
   flutter analyze
   flutter test
   ```

4. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: add new workout history feature"
   ```

5. **Push to your fork:**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**

## 🎨 Code Style Guidelines

### General Principles

1. **Follow Dart Style Guide:** Adhere to the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style)
2. **Use `flutter analyze`:** Ensure no analysis issues before committing
3. **Write clean, readable code:** Prioritize clarity over cleverness
4. **Add comments for complex logic:** Explain *why*, not *what*

### Formatting

```bash
# Auto-format your code
dart format .

# Check formatting
dart format --set-exit-if-changed .
```

### Naming Conventions

```dart
// Classes: PascalCase
class UserProfile {}

// Variables and functions: camelCase
String userName = '';
void fetchUserData() {}

// Constants: lowerCamelCase with const keyword
const int maxLoginAttempts = 3;

// Private members: _leadingUnderscore
String _privateVariable = '';
void _privateMethod() {}

// Enums: PascalCase
enum WorkoutType { cardio, strength, flexibility }
```

### File Organization

```dart
// 1. Imports (sorted alphabetically)
import 'dart:async';

import 'package:aigymbuddy/common/...';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 2. Class definition
class MyWidget extends StatelessWidget {
  // 3. Constructor
  const MyWidget({super.key});
  
  // 4. Public members
  final String property = '';
  
  // 5. Private members
  final String _privateProperty = '';
  
  // 6. Overridden methods
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // 7. Public methods
  void publicMethod() {}
  
  // 8. Private methods
  void _privateMethod() {}
}
```

### Widget Best Practices

```dart
// ✅ Good: Use const constructors when possible
const SizedBox(height: 16)

// ❌ Bad: Non-const when const is possible
SizedBox(height: 16)

// ✅ Good: Extract widgets for reusability and readability
Widget _buildHeader() {
  return Text('Header');
}

// ❌ Bad: Deeply nested widget trees in build method
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      child: Column(
        children: [
          Container(
            child: ...
          ),
        ],
      ),
    ),
  );
}

// ✅ Good: Use named parameters for clarity
RoundButton(
  title: 'Login',
  onPressed: handleLogin,
  isEnabled: true,
)

// ✅ Good: Dispose resources properly
@override
void dispose() {
  _controller.dispose();
  _focusNode.dispose();
  super.dispose();
}
```

### State Management

```dart
// ✅ Good: Use Provider for business logic state
class MyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyController>(
      builder: (context, controller, _) {
        return Text(controller.data);
      },
    );
  }
}

// ✅ Good: Use StatefulWidget only for local UI state
class MyView extends StatefulWidget {
  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  late final AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
```

### Error Handling

```dart
// ✅ Good: Use specific exception types
try {
  await performOperation();
} on AuthException catch (e) {
  _handleAuthError(e);
} on NetworkException catch (e) {
  _handleNetworkError(e);
} catch (e, stackTrace) {
  _logger.error('Unexpected error', error: e, stackTrace: stackTrace);
}

// ✅ Good: Use ErrorHandler for user-facing errors
try {
  await performOperation();
} catch (error, stackTrace) {
  if (!mounted) return;
  ErrorHandler.handleError(
    context,
    error: error,
    stackTrace: stackTrace,
    userMessage: 'Failed to perform operation',
  );
}
```

## 📝 Commit Message Convention

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring (no functional changes)
- `docs`: Documentation changes
- `test`: Adding or updating tests
- `style`: Code style changes (formatting, missing semi-colons, etc.)
- `perf`: Performance improvements
- `chore`: Maintenance tasks (dependencies, build scripts, etc.)

### Examples

```
feat(auth): add biometric authentication support

Implemented fingerprint and face ID authentication for faster login.

Closes #123
```

```
fix(workout): resolve duration calculation error

Fixed an issue where workout duration was incorrectly calculated
when pausing and resuming a workout session.

Fixes #456
```

```
refactor(home): migrate to provider state management

Replaced local setState with HomeController for better testability
and code organization.
```

## 🔀 Pull Request Process

### Before Submitting

1. **Ensure all tests pass:**
   ```bash
   flutter test
   ```

2. **Run static analysis:**
   ```bash
   flutter analyze
   ```

3. **Format your code:**
   ```bash
   dart format .
   ```

4. **Update documentation** if needed

5. **Add tests** for new functionality

### PR Title Format

Follow the same format as commit messages:
```
feat(auth): add biometric authentication
```

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Refactoring
- [ ] Documentation update
- [ ] Test addition/modification

## Testing
Describe how you tested your changes

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tested on multiple devices/platforms
```

### Review Process

1. At least one maintainer must review and approve
2. All CI checks must pass
3. Address all review comments
4. Squash commits before merging (if requested)

## 🧪 Testing Requirements

### Required Tests

- **Unit tests** for all business logic (controllers, use cases, repositories)
- **Widget tests** for new UI components
- **Integration tests** for critical user flows

### Test Coverage

- Aim for **80%+ coverage** for controllers and use cases
- New features should include comprehensive tests
- Bug fixes should include regression tests

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Writing Tests

```dart
// Example unit test
void main() {
  group('AuthController', () {
    late AuthController controller;
    late MockAuthUseCase mockUseCase;
    
    setUp(() {
      mockUseCase = MockAuthUseCase();
      controller = AuthController(useCase: mockUseCase);
    });
    
    test('login success updates current user', () async {
      // Arrange
      final user = AuthUser(id: '1', email: 'test@example.com');
      when(mockUseCase.login(any, any)).thenAnswer((_) async => user);
      
      // Act
      await controller.login(email: 'test@example.com', password: 'password');
      
      // Assert
      expect(controller.currentUser, equals(user));
      expect(controller.isLoading, isFalse);
    });
  });
}
```

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Provider Documentation](https://pub.dev/packages/provider)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Drift Documentation](https://drift.simonbinder.eu/)

## ❓ Questions?

If you have questions, please:

1. Check existing issues and discussions
2. Review the architecture documentation
3. Ask in the project's discussion forum
4. Contact the maintainers

Thank you for contributing! 🎉
