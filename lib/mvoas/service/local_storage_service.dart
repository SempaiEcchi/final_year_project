import 'dart:async';

import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zavrsnirad/mvoas/model/entity/storage_entity.dart';
import 'package:zavrsnirad/shared/interfaces.dart';

final rxPrefs = RxSharedPreferences(
  SharedPreferences.getInstance(),
  const DefaultLogger(),
);

class LocalStorageService implements Disposable {
  final BehaviorSubject<StorageE> storageE$ = BehaviorSubject.seeded(StorageE(
    ssid: initialSearchSSID,
    ip: initialIP,
  ));

  StorageE get _currentStorage => storageE$.value;

  String get currentIP => _currentStorage.ip;
  String get currentSSID => _currentStorage.ssid;

  static const String initialIP = "ws://192.168.4.1:8888";
  static const String initialSearchSSID = "ZAVRSNI";

  StreamSubscription<String> ipListener;
  StreamSubscription<String> SSIDListener;

  LocalStorageService() {
    _setInitialValues();

    ipListener = rxPrefs.getStringStream('IP').listen((String IP) {
      storageE$.add(_currentStorage.copyWith(ip: IP));
    });

    SSIDListener = rxPrefs.getStringStream('SSID').listen((String SSID) {
      storageE$.add(_currentStorage.copyWith(ssid: SSID));
    });
  }

  void _setInitialValues() async {
    rxPrefs.containsKey('IP').then((contains) {
      if (!contains) rxPrefs.setString('IP', initialIP);
    });
    rxPrefs.containsKey('SSID').then((contains) {
      if (!contains) rxPrefs.setString('SSID', initialSearchSSID);
    });
  }

  @override
  Future<void> dispose() {
    ipListener.cancel();
    SSIDListener.cancel();
    storageE$.close();
  }

  Future<void> saveToStorage({String ip, ssid}) async {
    await rxPrefs.setString('IP', ip);
    await rxPrefs.setString('SSID', ssid);
  }
}
