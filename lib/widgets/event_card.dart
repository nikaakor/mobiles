import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String value;
  final String status;
  final IconData icon;
  final Color accentColor;

  const EventCard({
    super.key,
    required this.title,
    required this.value,
    required this.status,
    required this.icon,
    required this.accentColor,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/details', 
            arguments: {'title': widget.title, 'color': widget.accentColor}),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.accentColor.withValues(alpha: isHovered ? 1.0 : 0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.accentColor.withValues(alpha: 0.1),
                  blurRadius: isHovered ? 20 : 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: widget.accentColor.withValues(alpha: 0.1),
                  child: Icon(widget.icon, color: widget.accentColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(widget.value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Text(widget.status, style: TextStyle(color: widget.accentColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}