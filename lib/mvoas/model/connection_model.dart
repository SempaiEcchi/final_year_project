import 'package:rxdart/rxdart.dart';
import 'package:zavrsnirad/mvoas/observable/connection_o.dart';
import 'package:zavrsnirad/mvoas/service/connectivity_service.dart';
import 'package:zavrsnirad/shared/interfaces.dart';

class ConnectionModel implements Disposable {
  final ConnectivityService connectivityService;

  final BehaviorSubject<ConnectionO> connectionO$ =
      BehaviorSubject.seeded(ConnectionO.fromEnum(Cstatus.notConnected));

  final BehaviorSubject<PingO> pingO$ = BehaviorSubject();

  var _connectionListener;
  var _pingListener;

  ConnectionModel(this.connectivityService) {
    _connectionListener =
        connectivityService.connectionE$.listen((connectionStatus) {
      connectionO$.add(ConnectionO.fromEnum(connectionStatus.cstatus));
    });
    _pingListener = connectivityService.pingE$.listen((ping) {
      pingO$.add(PingO(ping.info.ms.toString()));
    });
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
    pingO$.close();
    connectionO$.close();
  }
}
