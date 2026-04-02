import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/details_screen.dart';
import 'data/sp_auth_repository.dart';
import 'data/mqtt_service.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final authRepo = SharedPreferencesAuthRepository(); 
  final currentUser = await authRepo.getCurrentUser();

  final String startRoute = currentUser != null ? '/home' : '/login';

  runApp(
    ChangeNotifierProvider(
      create: (context) => MqttService(),
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
      debugShowCheckedModeBanner: false,
      title: 'Smart Event Flow',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF57E69C),
          primary: const Color(0xFF57E69C),
          secondary: const Color(0xFFF8B2A2),
          tertiary: const Color(0xFF98B8E0),
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