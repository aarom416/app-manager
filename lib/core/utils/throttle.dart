import 'dart:async';

class Throttle {
  final Duration delay;
  bool waiting = false;
  Timer? _timer;

  Throttle({required this.delay});

  void run(action) {
    if (!waiting) {
      action();
      waiting = true;
      _timer = Timer(delay, () {
        waiting = false;
      });
    }
  }
}
