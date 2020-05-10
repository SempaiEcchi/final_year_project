import 'package:web_socket_channel/io.dart';
import 'package:zavrsnirad/mvoas/service/esp32_service.dart';
import 'package:zavrsnirad/mvoas/service/local_storage_service.dart';

class ConnectToChannelA {
  final ESP32Service esp32service;
  final LocalStorageService localStorageService;

  ConnectToChannelA(this.esp32service, this.localStorageService);

  Future<IOWebSocketChannel> connectToChannel() =>
      esp32service.connectToChannel(ip: localStorageService.storageE$.value.ip);
}
