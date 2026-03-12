import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_input.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Реєстрація", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF98B8E0))),
            const SizedBox(height: 30),
            const CustomInput(label: "Ім'я та прізвище"),
            const CustomInput(label: "Електронна пошта"),
            const CustomInput(label: "Пароль", isPassword: true),
            const SizedBox(height: 20),
            PrimaryButton(
              text: "Зареєструватися", 
              onPressed: () => Navigator.pop(context)
            ),
          ],
        ),
      ),
    );
  }
}