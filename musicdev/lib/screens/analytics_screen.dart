import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../main.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final List<Map<String, dynamic>> _weekData = [
    {'day': 'Mon', 'minutes': 50},
    {'day': 'Tue', 'minutes': 75},
    {'day': 'Wed', 'minutes': 25},
    {'day': 'Thu', 'minutes': 90},
    {'day': 'Fri', 'minutes': 60},
    {'day': 'Sat', 'minutes': 40},
    {'day': 'Sun', 'minutes': 0},
  ];

  int get _totalMinutes =>
      _weekData.fold(0, (sum, d) => sum + (d['minutes'] as int));

  int get _totalSessions => _weekData.where((d) => d['minutes'] > 0).length;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SessionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Summary Cards ─────────────────────────────
            Row(
              children: [
                _statCard('$_totalMinutes min', 'Total Focus'),
                const SizedBox(width: 12),
                _statCard('$_totalSessions', 'Sessions'),
                const SizedBox(width: 12),
                _statCard('3 days', 'Streak'),
              ],
            ),
            const SizedBox(height: 28),

            // ── Bar Chart ─────────────────────────────────
            _sectionLabel('This Week'),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _weekData.map((data) {
                          final int mins = data['minutes'] as int;
                          final double maxHeight = 120;
                          final double barHeight =
                              mins == 0 ? 4 : (mins / 100) * maxHeight;
                          final bool isToday = data['day'] == 'Thu';

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                mins > 0 ? '${mins}m' : '',
                                style: const TextStyle(
                                    color: AppColors.creamMuted,
                                    fontSize: 10),
                              ),
                              const SizedBox(height: 4),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                width: 28,
                                height: barHeight,
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? AppColors.maroon
                                      : AppColors.maroonDark,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                data['day'],
                                style: TextStyle(
                                  color: isToday
                                      ? AppColors.cream
                                      : AppColors.creamFaint,
                                  fontSize: 11,
                                  fontWeight: isToday
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Session History ───────────────────────────
            _sectionLabel('Session History'),
            const SizedBox(height: 12),
            provider.sessions.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.maroonDark),
                    ),
                    child: const Text(
                      'No sessions recorded yet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.creamFaint, fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.sessions.length,
                    itemBuilder: (context, index) {
                      final session = provider.sessions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.maroonDark,
                            child: Text(
                              '${session.durationMins}m',
                              style: const TextStyle(
                                  color: AppColors.cream, fontSize: 11),
                            ),
                          ),
                          title: Text(
                            session.title ?? 'Focus Session',
                            style: const TextStyle(color: AppColors.cream),
                          ),
                          subtitle: Text(
                            '${session.mood} · ${session.taskType}',
                            style: const TextStyle(
                                color: AppColors.creamMuted, fontSize: 12),
                          ),
                          trailing: Text(
                            session.createdAt.substring(0, 10),
                            style: const TextStyle(
                                color: AppColors.creamFaint, fontSize: 11),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.maroonDark),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: AppColors.cream,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: AppColors.creamMuted, fontSize: 11)),
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
}