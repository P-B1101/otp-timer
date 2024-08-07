part of '../../../otp_timer.dart';

typedef TimerWidgetBuilder = Widget Function(Duration remainTime);

/// [id] use for handle events.
///
/// [builder] gives you [Duration] so you can show the remaining time.
///
/// [action] can be used to show action button that trigger start timer.
class OtpTimer extends StatefulWidget {
  final String? id;
  final TimerWidgetBuilder builder;
  final Widget? action;

  const OtpTimer({
    super.key,
    required this.id,
    required this.builder,
    this.action,
  });

  @override
  State<OtpTimer> createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addNewEventAndStart();
    });
  }

  @override
  void didUpdateWidget(covariant OtpTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      _addNewEventAndStart();
    }
  }

  void _addNewEventAndStart() {
    if (widget.id == null) return;
    final state = context.read<TimerControllerCubit>().addEvent(widget.id!);
    if (state.startTimer) _startTimer();
  }

  void _startTimer() {
    if (_timer != null) _stopTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        _stopTimer();
        return;
      }
      _tick();
    });
  }

  void _tick() {
    if (widget.id == null) return;
    final isFinished = context.read<TimerControllerCubit>().tick(widget.id!);
    if (isFinished) _stopTimer();
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerControllerCubit, TimerControllerState>(
      listenWhen: (previous, current) =>
          previous.startTimer != current.startTimer,
      listener: (context, state) {
        if (state.startTimer) _startTimer();
        if (state.stopTimer) _stopTimer();
      },
      buildWhen: (previous, current) =>
          (previous.getDurationOf(widget.id ?? '') !=
              current.getDurationOf(widget.id ?? '')) ||
          (previous.startTimer != current.startTimer) ||
          (previous.isFinished(widget.id ?? '') !=
              current.isFinished(widget.id ?? '')),
      builder: (context, state) => AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        sizeCurve: Curves.ease,
        firstCurve: Curves.ease,
        secondCurve: Curves.ease,
        crossFadeState: widget.id == null || state.isFinished(widget.id ?? '')
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: widget.builder(state.getDurationOf(widget.id ?? '')),
        secondChild: widget.action ?? const SizedBox(),
      ),
    );
  }
}
