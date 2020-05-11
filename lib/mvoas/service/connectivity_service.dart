import 'dart:async';


import 'package:connectivity/connectivity.dart';
import 'package:rxdart/subjects.dart';
import 'package:zavrsnirad/logger/logger.dart';
import 'package:zavrsnirad/mvoas/model/entity/connection_entity.dart';
import 'package:zavrsnirad/mvoas/model/entity/storage_entity.dart';
import 'package:zavrsnirad/mvoas/observable/connection_o.dart';
import 'package:zavrsnirad/mvoas/service/local_storage_service.dart';
import 'package:zavrsnirad/shared/interfaces.dart';

class ConnectivityService implements Disposable {
  final LocalStorageService localStorageService;

  final Connectivity _connectivity = Connectivity();

  final BehaviorSubject<ConnectionE> connectionE$ =
      BehaviorSubject<ConnectionE>.seeded(
          ConnectionE(cstatus: Cstatus.notConnected));
  final BehaviorSubject<PingE> pingE$ = BehaviorSubject<PingE>();
  bool isTargetSSID = false;

  StreamSubscription<StorageE> listener;
  var pinger;
  String targetSSID;
  String targetIP;

  ConnectivityService(this.localStorageService) {
    initConnection();

    listener = localStorageService.storageE$.listen((storage) async {
      targetSSID = storage.ssid;
      targetIP = storage.ip;

      initConnection();
    });
  }

  Future<void> initConnection() async {
    ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      connectionE$.add(ConnectionE(cstatus: Cstatus.notConnected));
      logger.warning('Error : $e');
    }
    await _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    String wifiName, wifiBSSID, wifiIP, connectionStatus;

    switch (result) {
      case ConnectivityResult.wifi:
        try {
          wifiName = await _connectivity.getWifiName();
          logger.info("WiFi name : $wifiName");
        } catch (e) {
          logger.warning("Error : $e");
          wifiName = "Failed to get Wifi Name";
        }

        try {
          wifiBSSID = await _connectivity.getWifiBSSID();
        } catch (e) {
          logger.warning("Error : $e");
          wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          wifiIP = await _connectivity.getWifiIP();
        } catch (e) {
          logger.warning("Error : $e");
          wifiIP = "Failed to get Wifi IP";
        }

        connectionStatus = '$result\n'
            'Wifi Name: $wifiName\n'
            'Wifi BSSID: $wifiBSSID\n'
            'Wifi IP: $wifiIP\n';

        isTargetSSID = targetSSID == wifiName;
//        if (isTargetSSID) {
//          var ip = targetIP.replaceAll("ws://", "").split(":");
//
//          pinger = await ping("ws://"+ip[0], port: 80);
//          pingE$.add(PingE(info: pinger));
//        }
        isTargetSSID
            ? connectionE$.add(ConnectionE(
                cstatus: Cstatus.connected,
              ))
            : null;

        break;

      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        connectionStatus = result.toString();
        connectionE$.add(ConnectionE(cstatus: Cstatus.notConnected));

        break;

      default:
        connectionStatus = 'Failed to get connectivity.';
        connectionE$.add(ConnectionE(cstatus: Cstatus.notConnected));

        break;
    }
  }

  @override
  Future<void> dispose() {
    connectionE$.close();
  }
}
