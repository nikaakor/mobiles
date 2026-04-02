import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:flutter/foundation.dart';

class MqttService extends ChangeNotifier {
  MqttBrowserClient? client;
  
  String crowdCount = "0";
  String temperature = "20.0";
  String airQuality = "450";
  String foodCount = "0";

  final _crowdController = StreamController<String>.broadcast();
  final _tempController = StreamController<String>.broadcast();
  final _airController = StreamController<String>.broadcast();
  final _foodController = StreamController<String>.broadcast();

  Stream<String> get crowdStream => _crowdController.stream;
  Stream<String> get tempStream => _tempController.stream;
  Stream<String> get airStream => _airController.stream;
  Stream<String> get foodStream => _foodController.stream;

  Future<bool> connect() async {
    client = MqttBrowserClient(
      'ws://broker.emqx.io/mqtt',
      'nika_client_${DateTime.now().millisecondsSinceEpoch}',
    );

    client!.port = 8083;
    client!.keepAlivePeriod = 20;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(client!.clientIdentifier)
        .startClean();
    client!.connectionMessage = connMessage;

    try {
      await client!.connect();
      if (client!.connectionStatus?.state == MqttConnectionState.connected) {
        debugPrint('✅ MQTT підключено до smart_event');
        _setupSubscriptions();
        return true;
      }
    } catch (e) {
      debugPrint('❌ Помилка MQTT: $e');
    }
    return false;
  }

  void _setupSubscriptions() {
    const String topicPath = 'smart_event/hall_1/+';
    client!.subscribe(topicPath, MqttQos.atMostOnce);

    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final recMess = messages[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final topic = messages[0].topic;

      if (topic.endsWith('people')) {
        crowdCount = payload;
        _crowdController.add(payload);
      } else if (topic.endsWith('temp')) {
        temperature = payload;
        _tempController.add(payload);
      } else if (topic.endsWith('air')) {
        airQuality = payload;
        _airController.add(payload);
      } else if (topic.endsWith('food')) {
        foodCount = payload;
        _foodController.add(payload);
      }

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _crowdController.close();
    _tempController.close();
    _airController.close();
    _foodController.close();
    client?.disconnect();
    super.dispose();
  }
}