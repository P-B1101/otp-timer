part of otp_timer;

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
