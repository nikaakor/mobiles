import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/schedule_cubit.dart';
import '../../models/schedule_item.dart';

class GuestScheduleSection extends StatelessWidget {
  const GuestScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Рендеринг даних тепер відбувається через стейт-менеджмент
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: Color(0xFF57E69C)),
            ),
          );
        }

        if (state is ScheduleError) {
          return Center(child: Text('Помилка: ${state.message}'));
        }

        if (state is ScheduleLoaded) {
          final items = state.items;
          if (items.isEmpty) return const Center(child: Text('Розклад порожній 📅'));

          // Сортування за часом
          items.sort((a, b) => a.startTime.compareTo(b.startTime));

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _buildModernCard(context, items[index]),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildModernCard(BuildContext context, ScheduleItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Ліва частина: ЧАС
              Container(
                width: 90,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF57E69C), Color(0xFF43C6AC)],
                  ),
                ),
                child: Center(
                  child: Text(
                    item.startTime,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Контент
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      _rowIcon(Icons.person_rounded, item.speaker),
                      _rowIcon(Icons.location_on_rounded, item.location),
                    ],
                  ),
                ),
              ),
              // Видалення через Cubit (АПІ в коді віджета ЗАБОРОНЕНИЙ за вимогою)
              IconButton(
                onPressed: () => context.read<ScheduleCubit>().deleteItem(item.id),
                icon: Icon(Icons.delete_outline_rounded, color: Colors.red.withValues(alpha: 0.5)),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.grey))),
      ],
    );
  }
}