typedef UtcNow = DateTime Function();

/// Default implementation returning the current UTC timestamp.
DateTime defaultUtcNow() => DateTime.now().toUtc();

/// Ensures the provided [requested] limit is positive, otherwise the [fallback]
/// value is returned. The fallback must also be positive.
int resolvePositiveLimit(int requested, {required int fallback}) {
  if (fallback <= 0) {
    throw ArgumentError.value(fallback, 'fallback', 'Must be greater than 0');
  }

  return requested > 0 ? requested : fallback;
}

/// Returns the UTC timestamp [days] days before `now`. When a negative value is
/// provided the current timestamp is returned instead.
DateTime subtractDays(UtcNow now, int days) {
  final safeDays = days < 0 ? 0 : days;
  final reference = now();

  return safeDays == 0 ? reference : reference.subtract(Duration(days: safeDays));
}

/// Guarantees a UTC timestamp for values provided by the UI layer.
DateTime ensureUtc(DateTime value) => value.isUtc ? value : value.toUtc();
