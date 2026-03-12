import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.radar, size: 80, color: Color(0xFF57E69C)),
              const Text("Event Flow", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
              const SizedBox(height: 40),
              const CustomInput(label: "Електронна пошта"),
              const CustomInput(label: "Пароль", isPassword: true),
              const SizedBox(height: 20),
              PrimaryButton(text: "Увійти", onPressed: () => Navigator.pushNamed(context, '/home')),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text("Створити акаунт", style: TextStyle(color: Color(0xFF98B8E0))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}