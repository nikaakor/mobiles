import 'package:flutter/material.dart';
import '../../data/schedule_repository.dart';
import '../../models/schedule_item.dart';

class GuestScheduleSection extends StatefulWidget {
  const GuestScheduleSection({super.key});
  @override
  State<GuestScheduleSection> createState() => _GuestScheduleSectionState();
}

class _GuestScheduleSectionState extends State<GuestScheduleSection> {
  final _repo = ScheduleRepository();
  late Future<List<ScheduleItem>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => setState(() { _future = _repo.fetchSchedule(); });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScheduleItem>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF57E69C)));
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) return const Center(child: Text('Подій немає 📭'));

        items.sort((a, b) => a.startTime.compareTo(b.startTime));

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _buildModernCard(items[index]),
        );
      },
    );
  }

  Widget _buildModernCard(ScheduleItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 90,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF57E69C), Color(0xFF43C6AC)],
                  ),
                ),
                child: Center(
                  child: Text(
                    item.startTime, // ТУТ БУДЕ ТВОЄ 12:30
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF2D3436))),
                      const SizedBox(height: 6),
                      _rowIcon(Icons.person_rounded, item.speaker),
                      const SizedBox(height: 4),
                      _rowIcon(Icons.location_on_rounded, item.location),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (await _repo.deleteScheduleItem(item.id)) _reload();
                },
                icon: Icon(Icons.delete_outline_rounded, color: Colors.red.withOpacity(0.5)),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFFB2BEC3)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF636E72))),
      ],
    );
  }
}