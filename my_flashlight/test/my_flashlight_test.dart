import 'package:flutter_test/flutter_test.dart';
import 'package:my_flashlight/my_flashlight.dart';
import 'package:my_flashlight/my_flashlight_platform_interface.dart';
import 'package:my_flashlight/my_flashlight_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMyFlashlightPlatform
    with MockPlatformInterfaceMixin
    implements MyFlashlightPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MyFlashlightPlatform initialPlatform = MyFlashlightPlatform.instance;

  test('$MethodChannelMyFlashlight is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMyFlashlight>());
  });

  test('getPlatformVersion', () async {
    MyFlashlight myFlashlightPlugin = MyFlashlight();
    MockMyFlashlightPlatform fakePlatform = MockMyFlashlightPlatform();
    MyFlashlightPlatform.instance = fakePlatform;

    expect(await myFlashlightPlugin.getPlatformVersion(), '42');
  });
}
