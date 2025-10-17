typedef UtcNow = DateTime Function();

DateTime defaultUtcNow() => DateTime.now().toUtc();

int resolvePositiveLimit(int requested, {required int fallback}) {
  return requested > 0 ? requested : fallback;
}

DateTime subtractDays(UtcNow now, int days) {
  return now().subtract(Duration(days: days));
}
