import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zavrsnirad/logger/logger.dart';
import 'package:zavrsnirad/mvoas/model/entity/firebase_entity.dart';
import 'package:zavrsnirad/shared/interfaces.dart';

class FirebaseService implements Disposable {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final BehaviorSubject<ItemsE> itemsE$ = BehaviorSubject.seeded(ItemsE());

  FirebaseService() {
    _signInAnon();
    listSaved();
  }

  Future<dynamic> _signInAnon() async {
    var user = await _auth.currentUser();
    if (user?.uid == null ?? true) return _auth.signInAnonymously();
  }

  saveScreenshotToFirebase({File image}) async {
    final StorageReference reference = storage.ref().child("gallery");

    StorageUploadTask uploadTask =
        reference.child(DateTime.now().toString()).putFile(image);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    logger.info('Image URL : $url');
  }

  Future<String> getDownloadUrl(String name) async {
    String URL =
        await storage.ref().child("gallery").child(name).getDownloadURL();
    return URL;
  }

  void listSaved() {
    final storageRef = storage.ref().child('gallery');
    storageRef.listAll().then((map) {
      var t = map['items'];
      itemsE$.add(ItemsE.fromMap(map));
    });
  }

  @override
  Future<void> dispose() {
    // TODO: implement dispose
  }
}
