import 'package:rxdart/rxdart.dart';
import 'package:zavrsnirad/mvoas/observable/storage_o.dart';
import 'package:zavrsnirad/mvoas/service/firebase_service.dart';
import 'package:zavrsnirad/mvoas/service/local_storage_service.dart';

class LocalStorageModel {
  final LocalStorageService localStorageService;
  final FirebaseService firebaseService;

  final BehaviorSubject<StorageO> storageO$ = BehaviorSubject();
  final BehaviorSubject<ImagesO> imagesO$ = BehaviorSubject();
  var keysListener;
  var imagesListener;

  LocalStorageModel(this.localStorageService, this.firebaseService) {
    keysListener = localStorageService.storageE$.listen((v) {
      storageO$.add(StorageO(ip: v.ip, ssid: v.ssid));
    });
    imagesListener = firebaseService.itemsE$.listen((value) async {
      Map<String, String> images = Map();
      await Future.forEach(value.items, (String name) async {
        var url = await firebaseService.getDownloadUrl(name);
        images[name] = url;
      }).whenComplete(() {
        imagesO$.add(ImagesO(images));
      });
    });
  }
}

