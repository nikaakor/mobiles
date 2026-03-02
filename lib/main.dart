import 'package:flutter/material.dart';

void main() {
  runApp(const WizardApp());
}

class WizardApp extends StatelessWidget {
  const WizardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WizardGame(),
    );
  }
}

class WizardGame extends StatefulWidget {
  const WizardGame({super.key});

  @override
  State<WizardGame> createState() => _WizardGameState();
}

class _WizardGameState extends State<WizardGame> {
  int _energy = 0;
  String _status = 'First Year Student';

  final TextEditingController _controller = TextEditingController();

  void _castSpell(String input) {
    setState(() {
      if (input == 'Avada Kedavra') {
        _energy = 0;
      } else if (input == 'Expelliarmus') {
        _energy += 10;
      } else if (input == 'Expecto Patronum') {
        if (_energy > 50) {
          _energy += 30;
        }
      } else {
        final int? value = int.tryParse(input);
        if (value != null) {
          _energy += value;
        }
      }

      _updateStatus();
    });
  }

  void _updateStatus() {
    if (_energy >= 100) {
      _status = 'Master Wizard';
    } else if (_energy >= 50) {
      _status = 'Advanced Wizard';
    } else if (_energy < 0) {
      _status = 'Lost in the Forbidden Forest';
    } else {
      _status = 'Young Wizard';
    }
  }

  Color _backgroundColor() {
    if (_energy >= 100) return Colors.purple.shade200;
    if (_energy >= 50) return Colors.blue.shade200;
    if (_energy < 0) return Colors.red.shade200;
    return Colors.grey.shade200;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _backgroundColor(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Wizard Energy: $_energy',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Status: $_status',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Cast a spell or enter number',
                  ),
                  onSubmitted: (value) {
                    _castSpell(value);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}