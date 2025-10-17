class HomeActionResult {
  const HomeActionResult._({
    required this.message,
    required this.isSuccess,
    this.shouldResetForm = false,
  });

  factory HomeActionResult.success(String message, {bool shouldResetForm = false}) {
    return HomeActionResult._(
      message: message,
      isSuccess: true,
      shouldResetForm: shouldResetForm,
    );
  }

  factory HomeActionResult.failure(String message) {
    return HomeActionResult._(message: message, isSuccess: false);
  }

  factory HomeActionResult.validationError(String message) {
    return HomeActionResult._(message: message, isSuccess: false);
  }

  final String message;
  final bool isSuccess;
  final bool shouldResetForm;
}
