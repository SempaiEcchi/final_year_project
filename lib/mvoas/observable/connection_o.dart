import 'package:flutter/foundation.dart';

class ConnectionO {
  final Cstatus cstatus;
  final String connectionStatus;

  const ConnectionO({
    @required this.cstatus,
    @required this.connectionStatus,
  });

  factory ConnectionO.fromEnum(Cstatus status) {
    switch (status) {
      case Cstatus.notConnected:
        return ConnectionO(
            cstatus: Cstatus.notConnected, connectionStatus: 'NOT CONNECTED');
        break;

      case Cstatus.connected:
        return ConnectionO(
            cstatus: Cstatus.connected, connectionStatus: 'CONNECTED');
        break;
      default:
        return ConnectionO(
            cstatus: Cstatus.notConnected, connectionStatus: 'NOT CONNECTED');
    }
  }
}

class PingO {
  final String time;

  PingO(this.time);
}

enum Cstatus { notConnected, connected }
