import 'package:flutter/material.dart';
import '../../models/schedule_item.dart';

class ActionDialog extends StatefulWidget {
  final Function(ScheduleItem) onSave;
  const ActionDialog({super.key, required this.onSave});

  @override
  State<ActionDialog> createState() => _ActionDialogState();
}

class _ActionDialogState extends State<ActionDialog> {
  final _titleController = TextEditingController();
  final _speakerController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Нова подія', style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField(_titleController, 'Назва події', Icons.title),
            _buildField(_speakerController, 'Спікер', Icons.person),
            _buildField(_timeController, 'Час (напр. 12:30)', Icons.access_time),
            _buildField(_locationController, 'Локація', Icons.location_on),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Скасувати', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF57E69C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            if (_titleController.text.isNotEmpty && _timeController.text.isNotEmpty) {
              final item = ScheduleItem(
                id: 0,
                title: _titleController.text,
                speaker: _speakerController.text,
                startTime: _timeController.text,
                location: _locationController.text,
              );
              widget.onSave(item);
              Navigator.pop(context);
            }
          },
          child: const Text('Зберегти', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}