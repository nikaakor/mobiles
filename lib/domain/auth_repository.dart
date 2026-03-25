import '../models/user_model.dart';

abstract class AuthRepository {
  Future<bool> registerUser(UserModel user);
  Future<UserModel?> loginUser(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> updateUser(UserModel user);
}