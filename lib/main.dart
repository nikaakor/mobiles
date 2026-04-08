import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/details_screen.dart';

import 'data/sp_auth_repository.dart';
import 'data/schedule_repository.dart';
import 'data/mqtt_service.dart';

import 'logic/schedule_cubit.dart';
import 'logic/user_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<ScheduleRepository>(ScheduleRepository());
  getIt.registerSingleton<SharedPreferencesAuthRepository>(SharedPreferencesAuthRepository());
}

void main() async {
  // Гарантуємо, що всі плагіни (SharedPreferences тощо) ініціалізовані
  WidgetsFlutterBinding.ensureInitialized();
  
  setup();

  final authRepo = getIt<SharedPreferencesAuthRepository>();
  final currentUser = await authRepo.getCurrentUser();
  
  final String startRoute = currentUser != null ? '/home' : '/login';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MqttService()..connect(),
        ),
        BlocProvider(
          create: (_) => ScheduleCubit(getIt<ScheduleRepository>())..loadSchedule(),
        ),
        BlocProvider(
          create: (_) => UserCubit(getIt<SharedPreferencesAuthRepository>())..loadUser(),
        ),
      ],
      child: SmartEventApp(initialRoute: startRoute),
    ),
  );
}

class SmartEventApp extends StatelessWidget {
  final String initialRoute;
  const SmartEventApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Event Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF57E69C)),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/details': (context) => const DetailsScreen(),
      },
    );
  }
}