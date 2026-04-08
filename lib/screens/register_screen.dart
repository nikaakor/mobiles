import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/validators.dart';
import '../data/sp_auth_repository.dart';
import '../models/user_model.dart';
import '../logic/user_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(), 
        _emailController = TextEditingController(), 
        _passwordController = TextEditingController(), 
        _eventController = TextEditingController(), 
        _phoneController = TextEditingController(), 
        _ageController = TextEditingController();
  final _authRepository = SharedPreferencesAuthRepository();
  String _selectedRole = 'Відвідувач', _selectedGender = 'Не вказано';

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
    if (!_formKey.currentState!.validate()) return;

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

    try {
      final success = await _authRepository.registerUser(user);
      
      if (!mounted) return;

      if (success) {
        await _authRepository.loginUser(user.email, user.password);
        
        if (!mounted) return;
        
        context.read<UserCubit>().loadUser(); 
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Помилка реєстрації. Можливо, такий Email вже існує.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person_add_outlined, size: 70, color: Color(0xFF57E69C)),
                  const Text("Реєстрація", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  _buildField(_nameController, "Ім'я", Icons.face_rounded, Validators.validateName),
                  _buildField(_phoneController, "Телефон", Icons.phone, null, TextInputType.phone),
                  Row(
                    children: [
                      Expanded(child: _buildField(_ageController, "Вік", Icons.cake, null, TextInputType.number)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildGenderDropdown()),
                    ],
                  ),
                  _buildRoleDropdown(),
                  if (_selectedRole == 'Організатор') _buildField(_eventController, "Назва події", Icons.event, null),
                  _buildField(_emailController, "Email", Icons.email_outlined, Validators.validateEmail, TextInputType.emailAddress),
                  _buildField(_passwordController, "Пароль", Icons.lock_outline_rounded, Validators.validatePassword, null, true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55), 
                      backgroundColor: const Color(0xFF57E69C), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                    ),
                    onPressed: _handleRegister,
                    child: const Text("ЗАРЕЄСТРУВАТИСЯ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController c, String l, IconData i, String? Function(String?)? v, [TextInputType? t, bool o = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c, 
        obscureText: o, 
        validator: v, 
        keyboardType: t,
        decoration: InputDecoration(
          labelText: l, 
          prefixIcon: Icon(i), 
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedGender,
        decoration: InputDecoration(labelText: "Гендер", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        items: ['Не вказано', 'Чоловік', 'Жінка'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
        onChanged: (val) => setState(() => _selectedGender = val!),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedRole, 
        decoration: InputDecoration(
          labelText: "Роль", 
          prefixIcon: const Icon(Icons.psychology), 
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
        ),
        items: ['Відвідувач', 'Організатор'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
        onChanged: (val) => setState(() => _selectedRole = val!),
      ),
    );
  }
}