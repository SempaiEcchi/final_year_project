import 'package:web_socket_channel/io.dart';
import 'package:zavrsnirad/logger/logger.dart';
import 'package:zavrsnirad/mvoas/service/connectivity_service.dart';
import 'package:zavrsnirad/shared/interfaces.dart';

class ESP32Service implements Disposable {
  final ConnectivityService connectivityService;

  ESP32Service({this.connectivityService});

  Future<IOWebSocketChannel> connectToChannel({ip}) async {
    try {
      IOWebSocketChannel ioWebSocketChannel = IOWebSocketChannel.connect(ip);
      return ioWebSocketChannel;
    } catch (e) {
      logger.warning('Error : $e');
    }
  }

  @override
  Future<void> dispose() {}
}
