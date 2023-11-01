part of otp_timer;

typedef TimerWidgetBuilder = Widget Function(Duration remainTime);

class TimerWidget extends StatefulWidget {
  final String? id;
  final TimerWidgetBuilder builder;
  final Widget? action;

  const TimerWidget({
    super.key,
    required this.id,
    required this.builder,
    this.action,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addNewEventAndStart();
    });
  }

  @override
  void didUpdateWidget(covariant TimerWidget oldWidget) {
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
