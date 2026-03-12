import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String title = args['title'];
    final Color color = args['color'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color.withValues(alpha: 0.2),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Аналітика відвідувачів",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: color.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Заповненість", style: TextStyle(fontWeight: FontWeight.w500)),
                      Text("85%", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.85,
                    backgroundColor: Colors.white,
                    color: color,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              "Демографія (AI Recognition)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            
            Row(
              children: [
                _buildGenderStat(Icons.female, "12 дівчат", const Color(0xFFF8B2A2)),
                const SizedBox(width: 15),
                _buildGenderStat(Icons.male, "73 хлопці", const Color(0xFF98B8E0)),
              ],
            ),
            
            const SizedBox(height: 30),
            
            const Text(
              "Деталі зони",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _infoRow("Температура", "22°C"),
            _infoRow("Рівень шуму", "Середній"),
            _infoRow("Очікуваний час виходу", "~15 хв"),
            
            const SizedBox(height: 40),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "ПОВЕРНУТИСЬ",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderStat(IconData icon, String text, Color col) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: col.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: col, size: 30),
            const SizedBox(height: 8),
            Text(text, style: TextStyle(color: col, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}