import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mqtt_service.dart';
import '../event_card.dart';

class MqttDashboard extends StatelessWidget {
  const MqttDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final mqtt = context.watch<MqttService>();
    return Column(
      children: [
        _card(mqtt.crowdStream, mqtt.crowdCount, 'Вхід', ' осіб', Icons.groups, 
            const Color(0xFFF8B2A2), (v) => (int.tryParse(v) ?? 0) > 100 ? 'ЧЕРГА' : 'ВІЛЬНО'),
        const SizedBox(height: 10),
        _card(mqtt.tempStream, mqtt.temperature, 'Температура', '°C', Icons.thermostat, 
            const Color(0xFF98B8E0), (v) => (double.tryParse(v) ?? 20) > 24 ? 'СПЕКОТНО' : 'КОМФОРТ'),
        const SizedBox(height: 10),
        _card(mqtt.airStream, mqtt.airQuality, 'Повітря', ' ppm', Icons.air, 
            const Color(0xFF57E69C), (v) => (int.tryParse(v) ?? 400) > 800 ? 'ДУШНО' : 'СВІЖО'),
        const SizedBox(height: 10),
        _card(mqtt.foodStream, mqtt.foodCount, 'Трапезна', ' шт', Icons.fastfood, 
            const Color(0xFFF8B2A2), (v) => (int.tryParse(v) ?? 0) < 15 ? 'МАЛО' : 'ДОСТАТНЬО'),
      ],
    );
  }

  Widget _card(Stream<String> s, String init, String t, String suf, IconData i, Color c, String Function(String) sb) {
    return StreamBuilder<String>(
      stream: s,
      initialData: init,
      builder: (_, snap) => EventCard(title: t, value: '${snap.data ?? init}$suf', 
          status: sb(snap.data ?? init), icon: i, accentColor: c),
    );
  }
}