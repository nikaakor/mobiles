import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/user_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Використовуємо context.watch, щоб віджет оновлювався автоматично
    final user = context.watch<UserCubit>().state;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: const Text("Мій Профіль", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF57E69C),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(user.role, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 30),
                  _buildInfoCard(Icons.email, "Email", user.email),
                  _buildInfoCard(Icons.phone, "Телефон", user.phone),
                  _buildInfoCard(Icons.cake, "Вік", user.age.toString()),
                  _buildInfoCard(Icons.wc, "Стать", user.gender),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      context.read<UserCubit>().deleteAccount();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text("Видалити акаунт", style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF98B8E0)),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}