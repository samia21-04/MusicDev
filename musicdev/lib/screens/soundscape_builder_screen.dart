import 'package:flutter/material.dart';
import '../main.dart';

class SoundscapeBuilderScreen extends StatefulWidget {
  const SoundscapeBuilderScreen({super.key});

  @override
  State<SoundscapeBuilderScreen> createState() =>
      _SoundscapeBuilderScreenState();
}

class _SoundscapeBuilderScreenState extends State<SoundscapeBuilderScreen> {
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

  // ── Sound icons map used directly in build ────────
  final Map<String, IconData> _soundIcons = {
    'Rain': Icons.water_drop_outlined,
    'Lo-Fi Music': Icons.headphones_outlined,
    'White Noise': Icons.waves_outlined,
    'Forest': Icons.forest_outlined,
    'Ocean Waves': Icons.beach_access_outlined,
    'Café Ambience': Icons.coffee_outlined,
  };

  void _applyAIDJ() {
    setState(() {
      _activeSounds.updateAll((key, _) => false);
      _activeSounds['Rain'] = true;
      _activeSounds['Lo-Fi Music'] = true;
      _volumes['Rain'] = 0.4;
      _volumes['Lo-Fi Music'] = 0.6;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.maroon,
        content: const Text('AI Focus DJ applied a calm study mix!',
            style: TextStyle(color: AppColors.cream)),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _savePreset() {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('Save Preset',
              style: TextStyle(color: AppColors.cream)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: AppColors.cream),
            decoration: const InputDecoration(
              labelText: 'Preset name',
              hintText: 'e.g. Late Night Study',
              hintStyle: TextStyle(color: AppColors.creamFaint),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.creamMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.maroon,
                    content: Text('Preset "${controller.text}" saved!',
                        style: const TextStyle(color: AppColors.cream)),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  int get _activeSoundCount =>
      _activeSounds.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soundscape Builder')),
      body: Column(
        children: [

          // ── AI DJ Banner ──────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.maroonDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.maroon, width: 0.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome,
                    color: AppColors.cream, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('AI Focus DJ',
                          style: TextStyle(
                              color: AppColors.cream,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 2),
                      Text('$_activeSoundCount sounds active',
                          style: const TextStyle(
                              color: AppColors.creamMuted, fontSize: 12)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _applyAIDJ,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                  ),
                  child:
                      const Text('Mix', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),

          // ── Sound Tiles ───────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _activeSounds.keys.map((sound) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _soundIcons[sound],
                                  color: _activeSounds[sound]!
                                      ? AppColors.maroonLight
                                      : AppColors.creamFaint,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  sound,
                                  style: TextStyle(
                                    color: _activeSounds[sound]!
                                        ? AppColors.cream
                                        : AppColors.creamMuted,
                                    fontSize: 15,
                                    fontWeight: _activeSounds[sound]!
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _activeSounds[sound]!,
                              onChanged: (val) => setState(
                                  () => _activeSounds[sound] = val),
                            ),
                          ],
                        ),
                        if (_activeSounds[sound]!)
                          Row(
                            children: [
                              const Icon(Icons.volume_down,
                                  color: AppColors.creamFaint, size: 16),
                              Expanded(
                                child: Slider(
                                  value: _volumes[sound]!,
                                  onChanged: (val) => setState(
                                      () => _volumes[sound] = val),
                                ),
                              ),
                              const Icon(Icons.volume_up,
                                  color: AppColors.creamFaint, size: 16),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Save Preset Button ────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _savePreset,
                icon: const Icon(Icons.bookmark_outline),
                label: const Text('Save as Preset'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}