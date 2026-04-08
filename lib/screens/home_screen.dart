import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import '../logic/user_cubit.dart';
import '../logic/schedule_cubit.dart';
import '../models/user_model.dart';
import '../data/mqtt_service.dart';
import '../widgets/home/mqtt_dashboard.dart';
import '../widgets/home/guest_schedule_section.dart';
import '../widgets/home/action_dialog.dart';

import 'package:my_flashlight/my_flashlight.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
  }

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      await _speechToText.listen(
        onResult: (result) {
          String command = result.recognizedWords.toLowerCase();
          debugPrint("Почуто: $command");
          
          // Магія Гаррі Поттера
          if (command.contains('lumos') || command.contains('люмос') || 
              command.contains('nox') || command.contains('нокс')) {
            _handleFlashlight();
            _stopListening();
          }
        },
      );
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  void _handleFlashlight() async {
    try {
      await MyFlashlight.toggleLight(); 
      if (await Vibrate.canVibrate) Vibrate.feedback(FeedbackType.medium);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Магічна помилка"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Спостерігаємо за MQTT
    context.watch<MqttService>(); 

    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, user) {
        final bool isAdmin = user?.role == 'Організатор';

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: _isListening ? Colors.yellow.shade800 : const Color(0xFF57E69C),
            title: Text(
              _isListening ? "МАГІЯ..." : (isAdmin ? "ADMIN RADAR" : "EVENT GUIDE"), 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            actions: [
              if (isAdmin)
                IconButton(
                  onPressed: () => _showAddDialog(context),
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                ),
              
              GestureDetector(
                onLongPressStart: (_) => _startListening(),
                onLongPressEnd: (_) => _stopListening(),
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    _isListening ? Icons.auto_fix_high : Icons.account_circle, 
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          
          body: RefreshIndicator(
            onRefresh: () => context.read<ScheduleCubit>().loadSchedule(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  isAdmin ? 'МОНІТОРИНГ СИСТЕМИ' : 'ДОСТУПНІ ПОДІЇ', 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)
                ),
                const SizedBox(height: 20),
                
                if (isAdmin) ...[
                  const MqttDashboard(),
                  const Divider(height: 40),
                ],
                
                const GuestScheduleSection(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ActionDialog(
        onSave: (newItem) => context.read<ScheduleCubit>().addItem(newItem),
      ),
    );
  }
}