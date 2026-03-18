import 'dart:async';

class TimerService {
  int secondsRemaining;
  final int workDuration;    // in seconds
  final int breakDuration;   // in seconds
  bool isWorkInterval = true;
  bool isPaused = false;
  int completedPomodoros = 0;

  Timer? _timer;

  // Callbacks so the UI can react to changes
  final void Function(int seconds) onTick;
  final void Function() onIntervalComplete;

  TimerService({
    required this.workDuration,
    required this.breakDuration,
    required this.onTick,
    required this.onIntervalComplete,
  }) : secondsRemaining = workDuration;

  void start() {
    isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        onTick(secondsRemaining);
      } else {
        _timer?.cancel();
        _handleIntervalComplete();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    isPaused = true;
  }

  void resume() {
    isPaused = false;
    start();
  }

  void reset() {
    _timer?.cancel();
    secondsRemaining = workDuration;
    isWorkInterval = true;
    completedPomodoros = 0;
    isPaused = false;
  }

  void stop() {
    _timer?.cancel();
  }

  void _handleIntervalComplete() {
    if (isWorkInterval) {
      completedPomodoros++;
      isWorkInterval = false;
      secondsRemaining = breakDuration;
    } else {
      isWorkInterval = true;
      secondsRemaining = workDuration;
    }
    onIntervalComplete();
  }

  // Format seconds as MM:SS for display
  static String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void dispose() {
    _timer?.cancel();
  }
}