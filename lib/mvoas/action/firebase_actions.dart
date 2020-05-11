import 'dart:io';

import 'package:zavrsnirad/mvoas/service/firebase_service.dart';

class FirebaseA {
  final FirebaseService firebaseService;

  FirebaseA(this.firebaseService);

  Future<void> saveScreenshotToFirebase(File image) async =>
      await firebaseService.saveScreenshotToFirebase(image: image);

  Future<void> saveVideoToFirebase(File video) async =>
      await firebaseService.saveVideoToFirebase(video: video);
}
