import 'package:calendar_agenda/src/calendar.dart';

/// Controller that enables imperative interactions with [CalendarAgenda].
class CalendarAgendaController {
  CalendarAgendaState? _state;

  /// Whether the controller is currently attached to a [CalendarAgenda].
  bool get isAttached => _state != null;

  /// Binds the controller to the given [CalendarAgendaState].
  void bindState(CalendarAgendaState state) {
    _state = state;
  }

  /// Jumps the calendar to the provided [date].
  void goToDay(
    DateTime date, {
    bool animate = true,
    bool notifyListeners = true,
  }) {
    _state?.selectDate(
      date,
      animate: animate,
      notifyListeners: notifyListeners,
    );
  }

  /// Clears the state reference to avoid memory leaks.
  void dispose() {
    _state = null;
  }
}
