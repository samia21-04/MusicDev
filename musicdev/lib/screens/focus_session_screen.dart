import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/timer_ring.dart';

class FocusSessionScreen extends StatefulWidget {
  const FocusSessionScreen({super.key});

  @override
  State<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen> {
  int _workDuration = 25 * 60;
  int _secondsRemaining = 25 * 60;
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isWorkInterval = true;
  int _completedPomodoros = 0;
  Timer? _timer;

  void _startTimer() {
    setState(() { _isRunning = true; _isPaused = false; });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _handleIntervalComplete();
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('End Session?',
            style: TextStyle(color: AppColors.cream)),
        content: const Text('Your progress will be saved.',
            style: TextStyle(color: AppColors.creamMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.creamMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _isRunning = false;
                _isPaused = false;
                _secondsRemaining = _workDuration;
                _completedPomodoros = 0;
                _isWorkInterval = true;
              });
            },
            child: const Text('End',
                style: TextStyle(color: AppColors.maroonLight)),
          ),
        ],
      ),
    );
  }

  void _handleIntervalComplete() {
    if (_isWorkInterval) {
      setState(() {
        _completedPomodoros++;
        _isWorkInterval = false;
        _secondsRemaining = 5 * 60; // 5 min break
      });
      _showIntervalDialog('Break Time!', 'Great work! Take a 5 minute break.');
    } else {
      setState(() {
        _isWorkInterval = true;
        _secondsRemaining = _workDuration;
      });
      _showIntervalDialog('Back to Focus!', 'Break is over. Ready to focus?');
    }
  }

  void _showIntervalDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(title, style: const TextStyle(color: AppColors.cream)),
        content: Text(message,
            style: const TextStyle(color: AppColors.creamMuted)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _startTimer();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isWorkInterval ? 'Focus Session' : 'Break Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ── Pomodoro counter ──────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < _completedPomodoros
                      ? AppColors.maroon
                      : AppColors.maroonDark,
                ),
              )),
            ),
            const SizedBox(height: 8),
            Text(
              '$_completedPomodoros / 4 Pomodoros',
              style: const TextStyle(color: AppColors.creamMuted, fontSize: 13),
            ),
            const SizedBox(height: 40),

            // ── Timer Ring ────────────────────────────────
            TimerRing(
              secondsRemaining: _secondsRemaining,
              totalSeconds: _isWorkInterval ? _workDuration : 5 * 60,
              label: _isWorkInterval ? 'Focus' : 'Break',
            ),
            const SizedBox(height: 48),

            // ── Controls ──────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRunning)
                  ElevatedButton.icon(
                    onPressed: _startTimer,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                    ),
                  ),
                if (_isRunning && !_isPaused)
                  ElevatedButton.icon(
                    onPressed: _pauseTimer,
                    icon: const Icon(Icons.pause_rounded),
                    label: const Text('Pause'),
                  ),
                if (_isPaused)
                  ElevatedButton.icon(
                    onPressed: _resumeTimer,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Resume'),
                  ),
                if (_isRunning || _isPaused) ...[
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _endSession,
                    icon: const Icon(Icons.stop_rounded),
                    label: const Text('End'),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 32),

            // ── Session info card ─────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _infoItem(Icons.timer_outlined, '25 min', 'Work'),
                    _divider(),
                    _infoItem(Icons.coffee_outlined, '5 min', 'Break'),
                    _divider(),
                    _infoItem(Icons.music_note_outlined, 'Lo-Fi', 'Sound'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.maroonLight, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: AppColors.cream,
                fontWeight: FontWeight.w500,
                fontSize: 14)),
        Text(label,
            style: const TextStyle(
                color: AppColors.creamFaint, fontSize: 11)),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 32, width: 0.5, color: AppColors.maroonDark);
  }
}