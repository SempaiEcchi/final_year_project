import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zavrsnirad/logger/logger.dart';
import 'package:zavrsnirad/mvoas/service/connectivity_service.dart';
import 'package:zavrsnirad/shared/interfaces.dart';

class ESP32Service implements Disposable {
  final ConnectivityService connectivityService;

  ESP32Service({this.connectivityService});

  WebSocketChannel channel;

  Future<void> connectToChannel({ip}) async {
    try {
      channel= IOWebSocketChannel.connect(ip);
     } catch (e) {
      logger.warning('Error : $e');
    }
  }

  Future<void> disconnectFromChannel() async {
    await channel.sink.close();
  }

  @override
  Future<void> dispose() {}
}
