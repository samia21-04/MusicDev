import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMood = 'Calm';
  int _energyLevel = 3;

  final List<String> _moods = ['Calm', 'Focused', 'Energized', 'Stressed', 'Tired'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Studio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How are you feeling?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedMood,
              items: _moods
                  .map((mood) =>
                      DropdownMenuItem(value: mood, child: Text(mood)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedMood = val!),
              decoration: const InputDecoration(
                labelText: 'Mood',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Energy Level: $_energyLevel / 5',
                style: const TextStyle(fontSize: 16)),
            Slider(
              value: _energyLevel.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: '$_energyLevel',
              onChanged: (val) => setState(() => _energyLevel = val.toInt()),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to Focus Session screen
                  // Pass mood and energy level as arguments
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Start Focus Session',
                    style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}