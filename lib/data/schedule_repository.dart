import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/schedule_item.dart';

class ScheduleRepository {
  static const _baseUrl = 'http://192.168.0.109:5001';

  Future<List<ScheduleItem>> fetchSchedule() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/schedule'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        debugPrint("ДАНІ З СЕРВЕРА: $data"); 
        return data.map((item) => ScheduleItem.fromMap(item)).toList();
      }
    } catch (e) {
      debugPrint("ПОМИЛКА ГЕТ: $e");
    }
    return [];
  }

  Future<bool> createScheduleItem(ScheduleItem item) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/schedule'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': item.title,
          'speaker': item.speaker,
          'startTime': item.startTime, 
          'location': item.location,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('POST error: $e');
      return false;
    }
  }

  Future<bool> deleteScheduleItem(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/schedule/$id'));
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('DELETE error: $e');
      return false;
    }
  }
}
