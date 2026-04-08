import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/user_cubit.dart';
import '../logic/schedule_cubit.dart';
import '../models/user_model.dart';
import '../widgets/home/mqtt_dashboard.dart';
import '../widgets/home/guest_schedule_section.dart';
import '../widgets/home/action_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, user) {
        final bool isAdmin = user?.role == 'Організатор';

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: const Color(0xFF57E69C),
            title: Text(
              isAdmin ? "ADMIN RADAR" : "EVENT GUIDE", 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            actions: [
              if (isAdmin)
                IconButton(
                  onPressed: () => _showAddDialog(context),
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/profile'),
                icon: const Icon(Icons.account_circle, color: Colors.white),
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