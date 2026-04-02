import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mqtt_service.dart';
import '../data/schedule_repository.dart';
import '../data/sp_auth_repository.dart';
import '../models/user_model.dart';
import '../widgets/home/mqtt_dashboard.dart';
import '../widgets/home/guest_schedule_section.dart';
import '../widgets/home/action_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = SharedPreferencesAuthRepository();
  final _api = ScheduleRepository();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MqttService>().connect();
    });
  }

  void _loadUser() async {
    final user = await _auth.getCurrentUser();
    if (mounted) setState(() => _user = user);
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => ActionDialog(
        onSave: (newItem) async {
          final success = await _api.createScheduleItem(newItem);
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Подію додано! Перезавантажте сторінку')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = _user?.role == 'Організатор';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        flexibleSpace: Container(decoration: _appBarDecoration()),
        title: Text(isAdmin ? "ADMIN RADAR" : "EVENT GUIDE", 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          if (isAdmin)
            IconButton(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
            ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.account_circle, color: Colors.white),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(isAdmin ? 'МОНІТОРИНГ' : 'РОЗКЛАД', 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 20),
          if (isAdmin) const MqttDashboard(),
          const Divider(height: 40),
          const GuestScheduleSection(),
        ],
      ),
    );
  }

  BoxDecoration _appBarDecoration() => const BoxDecoration(
    gradient: LinearGradient(colors: [Color(0xFF57E69C), Color(0xFF98B8E0)]),
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
  );
}