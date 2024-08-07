library otp_timer;

import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'src/domain/entity/time_holder.dart';
part 'src/presentation/cubit/timer_controller_cubit.dart';
part 'src/presentation/cubit/timer_controller_state.dart';
part 'src/presentation/widget/otp_timer.dart';
part 'src/presentation/widget/otp_timer_wrapper.dart';
part 'src/utils/utils.dart';

/// use this method to start timer with specific id.
/// use multiple id for multiple timer at once.
extension OtpTimerContextExt on BuildContext {
  void startTimer(String id) => read<TimerControllerCubit>().startTimer(id);

  void stopTimer(String id) => read<TimerControllerCubit>().stopTimer(id);
}

/// gives you typical timer format.
extension OtpTimerDurationExt on Duration {
  String get toMinuteAndSecond {
    final data = inSeconds;
    final minute = data ~/ 60;
    final seconds = data % 60;
    return '${minute._toTwoDigit}:${seconds._toTwoDigit}';
  }
}

extension OtpTimerIntExt on int {
  String get _toTwoDigit => this < 10 ? '0$this' : toString();
}
