import 'package:flutter/material.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF57E69C), Color(0xFF98B8E0)]),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        title: const Text(
          "EVENT RADAR",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 30),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "МОНІТОРИНГ В РЕАЛЬНОМУ ЧАСІ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          const EventCard(
            title: "Вхід",
            value: "85 людей",
            status: "ЧЕРГА",
            icon: Icons.groups,
            accentColor: Color(0xFFF8B2A2),
          ),
          const EventCard(
            title: "Якість повітря",
            value: "450 ppm",
            status: "СВІЖО",
            icon: Icons.air,
            accentColor: Color(0xFF57E69C),
          ),
          const EventCard(
            title: "Настрій аудиторії",
            value: "Задоволені",
            status: "ПОЗИТИВ",
            icon: Icons.sentiment_very_satisfied,
            accentColor: Color(0xFF98B8E0),
          ),
          const EventCard(
            title: "Головна сцена",
            value: "78 dB",
            status: "АКТИВНО",
            icon: Icons.mic,
            accentColor: Color(0xFF57E69C),
          ),
          const EventCard(
            title: "Конференц-зал",
            value: "Високий",
            status: "СТАБІЛЬНО",
            icon: Icons.bolt,
            accentColor: Color(0xFF98B8E0),
          ),
          const EventCard(
            title: "Трапезна (Канапки)",
            value: "7 шт лишилось",
            status: "МАЛО",
            icon: Icons.fastfood,
            accentColor: Color(0xFFF8B2A2),
          ),
          const SizedBox(height: 10),
          _buildBreakInfo(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBreakInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8B2A2).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF8B2A2).withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFF8B2A2)),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              "ТЕРМІНОВО: В трапезній лишилось мало канапок! 🏃‍♂️🥪",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}