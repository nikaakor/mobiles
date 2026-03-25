import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../widgets/event_card.dart';
import '../data/sp_auth_repository.dart';
import '../models/user_model.dart';
import '../data/mqtt_service.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authRepository = SharedPreferencesAuthRepository();
  UserModel? _user;
  
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _setupConnectivity();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MqttService>(context, listen: false).connect();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _loadUserInfo() async {
    final user = await _authRepository.getCurrentUser();
    if (mounted) {
      setState(() => _user = user);
    }
  }

  void _setupConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (mounted) {
        setState(() {
          _isOffline = results.contains(ConnectivityResult.none);
        });
      }
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Вихід"),
        content: const Text("Ви впевнені, що хочете вийти з системи?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Скасувати")
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await _authRepository.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
            child: const Text("Вийти", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 30),
          )
        ],
      ),
      body: Column(
        children: [
          if (_isOffline)
            Container(
              width: double.infinity,
              color: Colors.orangeAccent,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: const Text(
                "Відсутнє підключення до мережі",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView(
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
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAdminDashboard() {
    final mqtt = Provider.of<MqttService>(context);
    
    return [
      StreamBuilder<String>(
        stream: mqtt.crowdStream,
        initialData: mqtt.crowdCount,
        builder: (context, snapshot) {
          final val = snapshot.data ?? "0";
          final count = int.tryParse(val) ?? 0;
          return EventCard(
            title: "Вхід",
            value: "$val людей",
            status: count > 100 ? "ЧЕРГА" : "ВІЛЬНО",
            icon: Icons.groups,
            accentColor: const Color(0xFFF8B2A2),
          );
        },
      ),
      const SizedBox(height: 10),

      StreamBuilder<String>(
        stream: mqtt.airStream,
        initialData: mqtt.airQuality,
        builder: (context, snapshot) {
          final val = snapshot.data ?? "400";
          final ppm = int.tryParse(val) ?? 400;
          return EventCard(
            title: "Якість повітря", 
            value: "$val ppm", 
            status: ppm > 800 ? "ДУШНО" : "СВІЖО", 
            icon: Icons.air, 
            accentColor: const Color(0xFF57E69C)
          );
        },
      ),
      const SizedBox(height: 10),

      StreamBuilder<String>(
        stream: mqtt.tempStream,
        initialData: mqtt.temperature,
        builder: (context, snapshot) {
          final val = snapshot.data ?? "20.0";
          final t = double.tryParse(val) ?? 20.0;
          return EventCard(
            title: "Температура", 
            value: "$val°C", 
            status: t > 24 ? "СПЕКОТНО" : "КОМФОРТ", 
            icon: Icons.thermostat, 
            accentColor: const Color(0xFF98B8E0)
          );
        },
      ),
      const SizedBox(height: 10),

      StreamBuilder<String>(
        stream: mqtt.foodStream,
        initialData: mqtt.foodCount,
        builder: (context, snapshot) {
          final val = snapshot.data ?? "0";
          final items = int.tryParse(val) ?? 0;
          return EventCard(
            title: "Трапезна", 
            value: "$val шт", 
            status: items < 15 ? "МАЛО" : "ДОСТАТНЬО", 
            icon: Icons.fastfood, 
            accentColor: const Color(0xFFF8B2A2)
          );
        },
      ),
    ];
  }

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
        boxShadow: [BoxShadow(color: Colors.black..withValues(alpha: 0.05), blurRadius: 10)],
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