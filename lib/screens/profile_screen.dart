import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/sp_auth_repository.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authRepository = SharedPreferencesAuthRepository();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await _authRepository.getCurrentUser();
    if (!mounted) return;
    setState(() => _currentUser = user);
  }

  void _showEditProfileDialog() {
    if (_currentUser == null) return;

    final nameEdit = TextEditingController(text: _currentUser?.name);
    final phoneEdit = TextEditingController(text: _currentUser?.phone);
    final ageEdit = TextEditingController(text: _currentUser?.age.toString());
    final eventEdit = TextEditingController(text: _currentUser?.eventName);
    String genderEdit = _currentUser?.gender ?? 'Не вказано';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Редагувати профіль"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameEdit, decoration: const InputDecoration(labelText: "Ім'я")),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneEdit, 
                  decoration: const InputDecoration(labelText: "Телефон"), 
                  keyboardType: TextInputType.phone
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ageEdit, 
                  decoration: const InputDecoration(labelText: "Вік"), 
                  keyboardType: TextInputType.number
                ),
                const SizedBox(height: 8),
                if (_currentUser?.role == 'Організатор')
                  TextField(controller: eventEdit, decoration: const InputDecoration(labelText: "Назва події")),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: genderEdit,
                  items: ['Не вказано', 'Чоловік', 'Жінка']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => genderEdit = val!),
                  decoration: const InputDecoration(labelText: "Гендер"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text("Скасувати")
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF57E69C)),
              // ignore: use_build_context_synchronously
              onPressed: () async {
                final updated = _currentUser!.copyWith(
                  name: nameEdit.text,
                  phone: phoneEdit.text,
                  age: int.tryParse(ageEdit.text) ?? 0,
                  gender: genderEdit,
                  eventName: eventEdit.text,
                );

                await _authRepository.updateUser(updated);

                if (!mounted) return;

                _loadUser();
                Navigator.of(context).pop(); 

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Дані успішно оновлено!")),
                );
              },
              child: const Text("Зберегти", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAccount() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Видалити акаунт?"),
        content: const Text("Ця дія безповоротна. Всі ваші дані будуть видалені."),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Скасувати")),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text("ВИДАЛИТИ", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );

    if (confirm == true) {
      final sp = await SharedPreferences.getInstance();
      await sp.clear();
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: const Text("Мій профіль", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF57E69C)),
            onPressed: _showEditProfileDialog,
          )
        ],
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 65,
                    backgroundColor: Color(0xFFB4CBEA),
                    child: Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _currentUser!.name,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentUser!.role == 'Організатор' 
                        ? "Організатор: ${_currentUser!.eventName}" 
                        : "Відвідувач події",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem("5", "Локації", const Color(0xFF98B8E0)),
                      _buildStatItem("14", "Датчики", const Color(0xFF57E69C)),
                      _buildStatItem("2", "Алерти", const Color(0xFFF8B2A2)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildInfoCard(Icons.email_outlined, "Пошта", _currentUser!.email),
                  _buildInfoCard(Icons.phone_android, "Телефон", _currentUser!.phone.isEmpty ? "Не вказано" : _currentUser!.phone),
                  _buildInfoCard(Icons.cake_outlined, "Вік", "${_currentUser!.age} років"),
                  _buildInfoCard(Icons.wc_outlined, "Гендер", _currentUser!.gender),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1BDB1),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text("Вийти", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  TextButton(
                    onPressed: _deleteAccount,
                    child: const Text("Видалити акаунт", style: TextStyle(color: Colors.redAccent)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF98B8E0)),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Color(0xFF7E8A99))),
        ],
      ),
    );
  }
}