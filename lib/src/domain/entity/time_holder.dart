part of '../../../otp_timer.dart';

class TimeHolder extends Equatable {
  final String id;
  final Duration remainTime;
  final DateTime startDate;

  const TimeHolder({
    required this.id,
    required this.remainTime,
    required this.startDate,
  });

  @override
  List<Object?> get props => [id, remainTime, startDate.toString()];

  factory TimeHolder.create(String id) => TimeHolder(
        id: id,
        remainTime: OtpUtils.timerDuration,
        startDate: DateTime.now(),
      );

  TimeHolder startWithNewDuration() => TimeHolder(
        id: id,
        remainTime: () {
          if (DateTime.now().isAfter(startDate.add(OtpUtils.timerDuration))) {
            return OtpUtils.timerDuration;
          }
          final value = DateTime.now().difference(startDate).inSeconds;
          return Duration(
              seconds: min(remainTime.inSeconds - value + 1,
                  OtpUtils.timerDuration.inSeconds));
        }(),
        startDate: DateTime.now(),
      );

  TimeHolder tick() => TimeHolder(
        id: id,
        remainTime: remainTime - const Duration(seconds: 1),
        startDate: startDate,
      );

  TimeHolder lastTick() => TimeHolder(
        id: id,
        remainTime: const Duration(seconds: 0),
        startDate: startDate,
      );
}
