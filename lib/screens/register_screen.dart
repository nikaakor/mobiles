import 'package:flutter/material.dart';
import '../domain/validators.dart';
import '../data/sp_auth_repository.dart';
import '../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _eventController = TextEditingController(); 
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  
  final _authRepository = SharedPreferencesAuthRepository();
  String _selectedRole = 'Відвідувач'; 
  String _selectedGender = 'Не вказано';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _eventController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
        eventName: _selectedRole == 'Організатор' ? _eventController.text : 'Загальна подія',
        gender: _selectedGender,
        age: int.tryParse(_ageController.text) ?? 0,
        phone: _phoneController.text,
      );

      final success = await _authRepository.registerUser(user);
      
      if (!mounted) return;
      if (success) {
        await _authRepository.loginUser(user.email, user.password);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Реєстрація успішна!'), backgroundColor: Color(0xFF57E69C)),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Користувач вже існує'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person_add_outlined, size: 70, color: Color(0xFF57E69C)),
                  const Text("Реєстрація", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Ім'я", prefixIcon: Icon(Icons.face), border: OutlineInputBorder()),
                    validator: Validators.validateName,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: "Телефон", prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(labelText: "Вік", border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedGender,
                          decoration: const InputDecoration(labelText: "Гендер", border: OutlineInputBorder()),
                          items: ['Не вказано', 'Чоловік', 'Жінка'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                          onChanged: (val) => setState(() => _selectedGender = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    initialValue: _selectedRole,
                    decoration: const InputDecoration(labelText: "Роль", prefixIcon: Icon(Icons.psychology), border: OutlineInputBorder()),
                    items: ['Відвідувач', 'Організатор'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (val) => setState(() => _selectedRole = val!),
                  ),
                  const SizedBox(height: 16),

                  if (_selectedRole == 'Організатор') ...[
                    TextFormField(
                      controller: _eventController,
                      decoration: const InputDecoration(labelText: "Назва події", prefixIcon: Icon(Icons.event), border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                  ],

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Пароль", prefixIcon: Icon(Icons.lock), border: OutlineInputBorder()),
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 30),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), backgroundColor: const Color(0xFF57E69C)),
                    onPressed: _handleRegister,
                    child: const Text("ЗАРЕЄСТРУВАТИСЯ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}