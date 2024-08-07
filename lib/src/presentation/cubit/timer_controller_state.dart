part of '../../../otp_timer.dart';

class TimerControllerState extends Equatable {
  final List<TimeHolder> events;
  final bool startTimer;
  final bool stopTimer;
  const TimerControllerState({
    required this.events,
    required this.startTimer,
    required this.stopTimer,
  });

  @override
  List<Object> get props => [events, startTimer, stopTimer];

  factory TimerControllerState.init() => const TimerControllerState(
        events: [],
        startTimer: false,
        stopTimer: false,
      );

  TimerControllerState copyWith({
    bool? startTimer,
    bool? stopTimer,
  }) =>
      TimerControllerState(
        events: events,
        startTimer: startTimer ?? this.startTimer,
        stopTimer: stopTimer ?? this.stopTimer,
      );

  TimerControllerState addEvent(String id) {
    final hasEvent = events.any((element) => element.id == id);
    if (hasEvent) {
      return TimerControllerState(
        events: events
            .map((e) => e.id == id ? e.startWithNewDuration() : e)
            .toList(),
        startTimer: startTimer,
        stopTimer: stopTimer,
      );
    }
    return TimerControllerState(
      events: [...events, TimeHolder.create(id)],
      startTimer: startTimer,
      stopTimer: stopTimer,
    );
  }

  TimerControllerState tick(String id) {
    final hasEvent = events.any((element) => element.id == id);
    if (!hasEvent) return this;
    final newEvents = events.map((e) => e.id == id ? e.tick() : e).toList();
    return TimerControllerState(
      events: newEvents,
      startTimer: false,
      stopTimer: false,
    );
  }

  TimerControllerState stopTimerEvent(String id) {
    final hasEvent = events.any((element) => element.id == id);
    if (!hasEvent) return this;
    final newEvents = events.where((e) => e.id != id).toList();
    return TimerControllerState(
      events: newEvents,
      startTimer: false,
      stopTimer: true,
    );
  }

  TimerControllerState get clearEvents {
    final newEvents =
        events.where((element) => element.remainTime >= Duration.zero).toList();
    return TimerControllerState(
      events: newEvents,
      startTimer: false,
      stopTimer: false,
    );
  }

  Duration getDurationOf(String id) {
    final items = events.where((element) => element.id == id);
    if (items.isEmpty) return Duration.zero;
    return items.first.remainTime;
  }

  bool isFinished(String id) {
    final items = events.where((element) => element.id == id);
    if (items.isEmpty) return true;
    return items.first.remainTime < Duration.zero;
  }
}
