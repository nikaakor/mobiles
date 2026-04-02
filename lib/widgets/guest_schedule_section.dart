import 'package:flutter/material.dart';
import '../../data/schedule_repository.dart';
import '../../models/schedule_item.dart';

class GuestScheduleSection extends StatefulWidget {
  const GuestScheduleSection({super.key});
  @override
  State<GuestScheduleSection> createState() => _GuestScheduleSectionState();
}

class _GuestScheduleSectionState extends State<GuestScheduleSection> {
  final _repository = ScheduleRepository();
  late Future<List<ScheduleItem>> _futureSchedule;

  @override
  void initState() {
    super.initState();
    _futureSchedule = _repository.fetchSchedule();
  }

  void _reload() {
    setState(() {
      _futureSchedule = _repository.fetchSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScheduleItem>>(
      future: _futureSchedule,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return const Center(child: Text('Розклад порожній або сервер офлайн'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              leading: const Icon(Icons.event, color: Color(0xFF57E69C)),
              title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${item.startTime} • ${item.location}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () async {
                  final success = await _repository.deleteScheduleItem(item.id);
                  if (success) _reload();
                },
              ),
            );
          },
        );
      },
    );
  }
}