import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../data/sp_auth_repository.dart';

class UserCubit extends Cubit<UserModel?> {
  final SharedPreferencesAuthRepository authRepo;
  UserCubit(this.authRepo) : super(null);

  Future<void> loadUser() async {
    final user = await authRepo.getCurrentUser();
    emit(user);
  }

  Future<void> deleteAccount() async {
    await authRepo.deleteAccount();
    emit(null);
  }
}