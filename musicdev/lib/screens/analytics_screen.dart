import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  // TODO: Replace with real data loaded from SQLite
  final List<Map<String, dynamic>> _mockData = [
    {'day': 'Mon', 'minutes': 50},
    {'day': 'Tue', 'minutes': 75},
    {'day': 'Wed', 'minutes': 25},
    {'day': 'Thu', 'minutes': 90},
    {'day': 'Fri', 'minutes': 60},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This Week',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Summary cards
            Row(
              children: [
                _statCard('Total Focus', '300 min'),
                const SizedBox(width: 12),
                _statCard('Sessions', '5'),
                const SizedBox(width: 12),
                _statCard('Streak', '3 days'),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Daily Focus Time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            // TODO: Replace this list with fl_chart bar chart
            Expanded(
              child: ListView.builder(
                itemCount: _mockData.length,
                itemBuilder: (context, index) {
                  final day = _mockData[index];
                  return ListTile(
                    title: Text(day['day']),
                    trailing: Text('${day['minutes']} min'),
                    subtitle: LinearProgressIndicator(
                      value: day['minutes'] / 100,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}