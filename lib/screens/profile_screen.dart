import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Мій профіль"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF98B8E0),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text("Вероніка Корчагін", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("Адміністратор системи", style: TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem("Локації", "5", const Color(0xFF98B8E0)),
                    _statItem("Датчики", "14", const Color(0xFF57E69C)),
                    _statItem("Алерти", "2", const Color(0xFFF8B2A2)),
                  ],
                ),
                const SizedBox(height: 30),
                _infoCard(Icons.email, "Пошта", "v.korchahin@university.edu"),
                _infoCard(Icons.settings_remote, "Шлюз IoT", "Активний ID: 4402"),
                _infoCard(Icons.notifications_active, "Сповіщення", "Увімкнено"),
                const SizedBox(height: 40),
                PrimaryButton(
                  text: "Вийти", 
                  color: const Color(0xFFF8B2A2),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login')
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    ]);
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15)),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF98B8E0), size: 20),
        const SizedBox(width: 16),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value, style: const TextStyle(color: Colors.blueGrey)),
      ]),
    );
  }
}