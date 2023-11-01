part of otp_timer;

class TimerControllerState extends Equatable {
  final List<TimeHolder> events;
  final bool startTimer;
  const TimerControllerState({
    required this.events,
    required this.startTimer,
  });

  @override
  List<Object> get props => [events, startTimer];

  factory TimerControllerState.init() =>
      const TimerControllerState(events: [], startTimer: false);

  TimerControllerState copyWith({
    bool? startTimer,
  }) =>
      TimerControllerState(
        events: events,
        startTimer: startTimer ?? this.startTimer,
      );

  TimerControllerState addEvent(String id) {
    final hasEvent = events.any((element) => element.id == id);
    if (hasEvent) {
      return TimerControllerState(
        events: events
            .map((e) => e.id == id ? e.startWithNewDuration() : e)
            .toList(),
        startTimer: startTimer,
      );
    }
    return TimerControllerState(
      events: [...events, TimeHolder.create(id)],
      startTimer: startTimer,
    );
  }

  TimerControllerState tick(String id) {
    final hasEvent = events.any((element) => element.id == id);
    if (!hasEvent) return this;
    final newEvents = events.map((e) => e.id == id ? e.tick() : e).toList();
    return TimerControllerState(
      events: newEvents,
      startTimer: false,
    );
  }

  TimerControllerState get clearEvents {
    final newEvents =
        events.where((element) => element.remainTime >= Duration.zero).toList();
    return TimerControllerState(
      events: newEvents,
      startTimer: false,
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
