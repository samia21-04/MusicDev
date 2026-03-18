import 'package:flutter/material.dart';

class SoundscapeBuilderScreen extends StatefulWidget {
  const SoundscapeBuilderScreen({super.key});

  @override
  State<SoundscapeBuilderScreen> createState() =>
      _SoundscapeBuilderScreenState();
}

class _SoundscapeBuilderScreenState extends State<SoundscapeBuilderScreen> {
  // Track which sounds are active and their volumes
  final Map<String, bool> _activeSounds = {
    'Rain': false,
    'Lo-Fi Music': false,
    'White Noise': false,
    'Forest': false,
    'Ocean Waves': false,
    'Café Ambience': false,
  };

  final Map<String, double> _volumes = {
    'Rain': 0.5,
    'Lo-Fi Music': 0.5,
    'White Noise': 0.5,
    'Forest': 0.5,
    'Ocean Waves': 0.5,
    'Café Ambience': 0.5,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soundscape Builder')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _activeSounds.keys.map((sound) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(sound,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            Switch(
                              value: _activeSounds[sound]!,
                              onChanged: (val) =>
                                  setState(() => _activeSounds[sound] = val),
                            ),
                          ],
                        ),
                        if (_activeSounds[sound]!)
                          Slider(
                            value: _volumes[sound]!,
                            onChanged: (val) =>
                                setState(() => _volumes[sound] = val),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      //  AI Focus DJ logic goes here
                    },
                    child: const Text('AI Focus DJ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      //  Save current mix as a preset
                    },
                    child: const Text('Save Preset'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}