import 'package:flutter/material.dart';
import '../widgets/event_card.dart';
import '../data/sp_auth_repository.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authRepository = SharedPreferencesAuthRepository();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final user = await _authRepository.getCurrentUser();
    if (mounted) {
      setState(() => _user = user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = _user?.role == 'Організатор';

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAdmin ? (_user?.eventName.toUpperCase() ?? "EVENT RADAR") : "EVENT GUIDE",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              _user?.email ?? "Завантаження...",
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
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
          Text(
            isAdmin ? "МОНІТОРИНГ В РЕАЛЬНОМУ ЧАСІ" : "ВАШ РОЗКЛАД ТА ФІДБЕК",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          
          if (isAdmin) ..._buildAdminDashboard() else ..._buildGuestView(),
        ],
      ),
    );
  }

  // Віджети для Організатора
  List<Widget> _buildAdminDashboard() {
    return [
      const EventCard(title: "Вхід", value: "85 людей", status: "ЧЕРГА", icon: Icons.groups, accentColor: Color(0xFFF8B2A2)),
      const EventCard(title: "Якість повітря", value: "450 ppm", status: "СВІЖО", icon: Icons.air, accentColor: Color(0xFF57E69C)),
      const EventCard(title: "Настрій", value: "Задоволені", status: "ПОЗИТИВ", icon: Icons.sentiment_satisfied, accentColor: Color(0xFF98B8E0)),
      const EventCard(title: "Трапезна", value: "7 шт", status: "МАЛО", icon: Icons.fastfood, accentColor: Color(0xFFF8B2A2)),
    ];
  }

  // Віджети для Відвідувача
  List<Widget> _buildGuestView() {
    return [
      _buildScheduleCard(),
      const SizedBox(height: 30),
      const Center(child: Text("Як вам подія?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      const SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['😢', '😐', '🙂', '🤩'].map((emoji) => InkWell(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Дякуємо за відгук $emoji!"))),
          child: Text(emoji, style: const TextStyle(fontSize: 45)),
        )).toList(),
      ),
    ];
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 10)],
      ),
      child: const Column(
        children: [
          ListTile(leading: Icon(Icons.access_time, color: Color(0xFF98B8E0)), title: Text("Реєстрація"), subtitle: Text("10:00")),
          Divider(),
          ListTile(leading: Icon(Icons.mic, color: Color(0xFF57E69C)), title: Text("Лекція: IoT та Flutter"), subtitle: Text("11:30")),
          Divider(),
          ListTile(leading: Icon(Icons.fastfood_outlined, color: Color(0xFFF8B2A2)), title: Text("Обід (Канапки!)"), subtitle: Text("13:00")),
        ],
      ),
    );
  }
}