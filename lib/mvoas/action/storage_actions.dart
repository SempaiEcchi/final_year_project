import 'package:zavrsnirad/mvoas/service/local_storage_service.dart';

class SaveToStorageA {
  final LocalStorageService localStorageService;

  SaveToStorageA(this.localStorageService);

  Future<void> saveToStorage(String ip, ssid) async =>
      await localStorageService.saveToStorage(ip: ip, ssid: ssid);
}
