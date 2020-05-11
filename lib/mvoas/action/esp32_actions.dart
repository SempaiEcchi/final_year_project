import 'package:web_socket_channel/io.dart';
import 'package:zavrsnirad/mvoas/service/esp32_service.dart';
import 'package:zavrsnirad/mvoas/service/local_storage_service.dart';

class ESP32A {
  final ESP32Service esp32service;
  final LocalStorageService localStorageService;

  ESP32A(this.esp32service, this.localStorageService);

  Future<void> connectToChannel() {
     return esp32service.connectToChannel(ip: localStorageService.currentIP);
  }

  Future<void> disconnectFromChannel() => null;
//      esp32service.disconnectFromChannel();
}
