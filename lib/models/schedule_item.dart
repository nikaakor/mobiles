class ScheduleItem {
  final int id;
  final String title;
  final String speaker;
  final String startTime;
  final String location;

  ScheduleItem({
    required this.id,
    required this.title,
    required this.speaker,
    required this.startTime,
    required this.location,
  });

  factory ScheduleItem.fromMap(Map<String, dynamic> map) {
    return ScheduleItem(
      id: map['id'] ?? 0,
      title: map['title'] ?? 'Без назви',
      speaker: map['speaker'] ?? 'Не вказано',
      startTime: (map['startTime'] ?? map['start_time'] ?? map['time'] ?? '??:??').toString(),
      location: map['location'] ?? 'Локація не вказана',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'speaker': speaker,
      'startTime': startTime, 
      'location': location,
    };
  }
}