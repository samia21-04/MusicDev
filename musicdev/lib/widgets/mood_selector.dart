import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final void Function(String) onMoodChanged;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodChanged,
  });

  static const List<String> moods = [
    'Calm', 'Focused', 'Energized', 'Stressed', 'Tired'
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedMood,
      decoration: const InputDecoration(
        labelText: 'Current Mood',
        border: OutlineInputBorder(),
      ),
      items: moods
          .map((mood) => DropdownMenuItem(value: mood, child: Text(mood)))
          .toList(),
      onChanged: (val) {
        if (val != null) onMoodChanged(val);
      },
    );
  }
}