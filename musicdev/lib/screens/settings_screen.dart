import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Work Duration: $_workDuration min'),
            Slider(
              value: _workDuration.toDouble(),
              min: 5,
              max: 60,
              divisions: 11,
              onChanged: (val) => setState(() => _workDuration = val.toInt()),
            ),
            Text('Break Duration: $_breakDuration min'),
            Slider(
              value: _breakDuration.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              onChanged: (val) => setState(() => _breakDuration = val.toInt()),
            ),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}