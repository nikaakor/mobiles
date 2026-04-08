import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/auth_repository.dart';
import '../models/user_model.dart';

class SharedPreferencesAuthRepository implements AuthRepository {
  static const String _usersListKey = 'users_list';
  static const String _currentUserKey = 'current_user';

  Future<void> deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<bool> registerUser(UserModel user) async {
    final sp = await SharedPreferences.getInstance();
    
    List<String> usersRaw = sp.getStringList(_usersListKey) ?? [];
    
    bool exists = usersRaw.any((item) {
      final u = UserModel.fromMap(jsonDecode(item));
      return u.email == user.email;
    });

    if (exists) return false; 

    usersRaw.add(jsonEncode(user.toMap()));
    return await sp.setStringList(_usersListKey, usersRaw);
  }

  @override
  Future<UserModel?> loginUser(String email, String password) async {
    final sp = await SharedPreferences.getInstance();
    List<String> usersRaw = sp.getStringList(_usersListKey) ?? [];

    for (var item in usersRaw) {
      final user = UserModel.fromMap(jsonDecode(item));
      if (user.email == email && user.password == password) {
        await sp.setString(_currentUserKey, jsonEncode(user.toMap()));
        return user;
      }
    }
    return null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final sp = await SharedPreferences.getInstance();
    final data = sp.getString(_currentUserKey);
    if (data == null) return null;
    return UserModel.fromMap(jsonDecode(data));
  }

  @override
  Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_currentUserKey);
  }

  @override
  Future<bool> updateUser(UserModel updatedUser) async {
    final sp = await SharedPreferences.getInstance();
    List<String> usersRaw = sp.getStringList(_usersListKey) ?? [];

    int index = usersRaw.indexWhere((item) {
      final u = UserModel.fromMap(jsonDecode(item));
      return u.email == updatedUser.email;
    });

    if (index != -1) {
      usersRaw[index] = jsonEncode(updatedUser.toMap());
      await sp.setStringList(_usersListKey, usersRaw);
      await sp.setString(_currentUserKey, jsonEncode(updatedUser.toMap()));
      return true;
    }
    return false;
  }
}