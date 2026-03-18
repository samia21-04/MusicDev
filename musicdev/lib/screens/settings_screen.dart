import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _workDuration = 25;
  int _breakDuration = 5;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _workDuration = prefs.getInt('work_duration') ?? 25;
      _breakDuration = prefs.getInt('break_duration') ?? 5;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('work_duration', _workDuration);
    await prefs.setInt('break_duration', _breakDuration);
    await prefs.setBool('notifications', _notificationsEnabled);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.maroon,
        content: const Text('Settings saved!',
            style: TextStyle(color: AppColors.cream)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Timer Settings ────────────────────────────
            _sectionHeader('Timer'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _sliderRow(
                      label: 'Work Duration',
                      value: _workDuration,
                      suffix: 'min',
                      min: 5,
                      max: 60,
                      divisions: 11,
                      onChanged: (val) =>
                          setState(() => _workDuration = val.toInt()),
                    ),
                    const Divider(color: AppColors.maroonDark, height: 24),
                    _sliderRow(
                      label: 'Break Duration',
                      value: _breakDuration,
                      suffix: 'min',
                      min: 1,
                      max: 30,
                      divisions: 29,
                      onChanged: (val) =>
                          setState(() => _breakDuration = val.toInt()),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Notifications ─────────────────────────────
            _sectionHeader('Notifications'),
            Card(
              child: SwitchListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                title: const Text('Enable Notifications',
                    style: TextStyle(color: AppColors.cream)),
                subtitle: const Text('Get reminded to start focus sessions',
                    style: TextStyle(
                        color: AppColors.creamMuted, fontSize: 12)),
                value: _notificationsEnabled,
                onChanged: (val) =>
                    setState(() => _notificationsEnabled = val),
              ),
            ),
            const SizedBox(height: 20),

            // ── App Info ──────────────────────────────────
            _sectionHeader('About'),
            Card(
              child: Column(
                children: [
                  _infoTile('App Version', '1.0.0'),
                  const Divider(color: AppColors.maroonDark, height: 0),
                  _infoTile('Developer', 'Samia Haynes'),
                  const Divider(color: AppColors.maroonDark, height: 0),
                  _infoTile('Course', 'Mobile App Development'),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Save Button ───────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Save Settings',
                    style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.maroonLight,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _sliderRow({
    required String label,
    required int value,
    required String suffix,
    required double min,
    required double max,
    required int divisions,
    required void Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.creamMuted, fontSize: 13)),
            Text('$value $suffix',
                style: const TextStyle(
                    color: AppColors.cream, fontWeight: FontWeight.w500)),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return ListTile(
      dense: true,
      title: Text(label,
          style: const TextStyle(
              color: AppColors.creamMuted, fontSize: 13)),
      trailing: Text(value,
          style: const TextStyle(
              color: AppColors.cream, fontSize: 13)),
    );
  }
}