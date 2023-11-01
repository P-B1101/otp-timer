# otp_timer

Help you to create timer base features like otp. work with id so it change handle multiple timers.

## Getting started

To use this plugin, add `otp_timer` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

## Usage

#### Example 

```dart

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OtpTimerWrapper(
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}


...

OtpTimer(
    id: id,
    builder: (remainTime) => Text(remainTime.toMinuteAndSecond),
    action: TextButton(
    onPressed: isLoading ? null : _startTimer,
    child: isLoading
        ? const Padding(
            padding: EdgeInsets.all(4),
            child: CircularProgressIndicator.adaptive(),
            )
        : const Text('Start timer'),
    ),
),

...

 void _startTimer() async {
    OtpUtils.timerDuration = Duration(seconds: 10 + Random().nextInt(110));
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    setState(() {
      isLoading = false;
      id = 'ABC';
    });
    context.startTimer(id!);
  }

```