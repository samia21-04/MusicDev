import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _moods = ['Calm', 'Focused', 'Energized', 'Stressed', 'Tired'];
  final List<String> _taskTypes = ['Study', 'Work', 'Creative', 'Reading', 'Planning'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Studio'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.self_improvement, color: AppColors.maroonLight),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Greeting ─────────────────────────────────
            Text(
              'Ready to focus?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppColors.cream,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Set your mood and start a session',
              style: TextStyle(fontSize: 14, color: AppColors.creamMuted),
            ),
            const SizedBox(height: 28),

            // ── Mood Selector ─────────────────────────────
            _sectionLabel('How are you feeling?'),
            const SizedBox(height: 10),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _moods.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final mood = _moods[index];
                  final selected = provider.selectedMood == mood;
                  return GestureDetector(
                    onTap: () => provider.setMood(mood),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.maroon : AppColors.surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: selected ? AppColors.maroon : AppColors.maroonDark,
                        ),
                      ),
                      child: Text(
                        mood,
                        style: TextStyle(
                          color: selected ? AppColors.cream : AppColors.creamMuted,
                          fontSize: 13,
                          fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── Task Type ─────────────────────────────────
            _sectionLabel('What are you working on?'),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: provider.selectedTaskType,
              dropdownColor: AppColors.card,
              style: const TextStyle(color: AppColors.cream),
              decoration: const InputDecoration(labelText: 'Task Type'),
              items: _taskTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) {
                if (val != null) provider.setTaskType(val);
              },
            ),
            const SizedBox(height: 24),

            // ── Energy Level ──────────────────────────────
            _sectionLabel('Energy Level: ${provider.energyLevel} / 5'),
            Slider(
              value: provider.energyLevel.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: '${provider.energyLevel}',
              onChanged: (val) => provider.setEnergyLevel(val.toInt()),
            ),
            const SizedBox(height: 28),

            // ── Start Button ──────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start Focus Session'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── Recent Sessions ───────────────────────────
            _sectionLabel('Recent Sessions'),
            const SizedBox(height: 10),
            provider.sessions.isEmpty
                ? _emptyState('No sessions yet. Start your first one!')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.sessions.length.clamp(0, 3),
                    itemBuilder: (context, index) {
                      final session = provider.sessions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.maroonDark,
                            child: Icon(Icons.self_improvement,
                                color: AppColors.cream, size: 18),
                          ),
                          title: Text(
                            session.title ?? 'Focus Session',
                            style: const TextStyle(
                                color: AppColors.cream, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            '${session.mood} · ${session.taskType} · ${session.durationMins} min',
                            style: const TextStyle(
                                color: AppColors.creamMuted, fontSize: 12),
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: AppColors.creamFaint),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.creamMuted,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _emptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.maroonDark),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.creamFaint, fontSize: 13),
      ),
    );
  }
}