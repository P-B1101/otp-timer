part of '../../../otp_timer.dart';

class TimerControllerCubit extends Cubit<TimerControllerState> {
  TimerControllerCubit() : super(TimerControllerState.init());

  TimerControllerState addEvent(String id) {
    final newState = state.addEvent(id);
    emit(newState);
    return newState;
  }

  bool tick(String id) {
    final newState = state.tick(id);
    final mState = newState.clearEvents;
    emit(mState);
    return newState.getDurationOf(id) < Duration.zero;
  }

  void startTimer(String id) {
    final newState = state.addEvent(id);
    emit(newState.copyWith(startTimer: true));
  }

  void stopTimer(String id) {
    final newState = state.stopTimerEvent(id);
    emit(newState.copyWith(stopTimer: true));
  }
}
