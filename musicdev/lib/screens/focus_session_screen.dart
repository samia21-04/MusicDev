import 'dart:async';
import 'package:flutter/material.dart';

class FocusSessionScreen extends StatefulWidget {
  const FocusSessionScreen({super.key});

  @override
  State<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen> {
  int _workDuration = 25 * 60; // seconds
  int _secondsRemaining = 25 * 60;
  bool _isRunning = false;
  bool _isPaused = false;
  int _completedPomodoros = 0;
  Timer? _timer;

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        setState(() {
          _completedPomodoros++;
          _isRunning = false;
          _secondsRemaining = _workDuration;
        });
        // TODO: Show break dialog here
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isPaused = true);
  }

  void _resumeTimer() {
    setState(() => _isPaused = false);
    _startTimer();
  }

  void _endSession() {
    _timer?.cancel();
    // TODO: Save session to SQLite before popping
    Navigator.pop(context);
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Session')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_secondsRemaining),
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Pomodoros completed: $_completedPomodoros'),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning)
                  ElevatedButton(
                    onPressed: _startTimer,
                    child: const Text('Start'),
                  ),
                if (_isRunning && !_isPaused)
                  ElevatedButton(
                    onPressed: _pauseTimer,
                    child: const Text('Pause'),
                  ),
                if (_isPaused)
                  ElevatedButton(
                    onPressed: _resumeTimer,
                    child: const Text('Resume'),
                  ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: _endSession,
                  child: const Text('End Session'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}