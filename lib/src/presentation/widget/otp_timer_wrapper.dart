part of '../../../otp_timer.dart';

/// Use this widget as a root so bloc can work perfectly
class OtpTimerWrapper extends StatelessWidget {
  final Widget child;
  const OtpTimerWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimerControllerCubit>(
      create: (context) => TimerControllerCubit(),
      child: child,
    );
  }
}
