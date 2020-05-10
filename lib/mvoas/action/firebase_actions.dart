import 'dart:io';

import 'package:zavrsnirad/mvoas/service/firebase_service.dart';

class SaveScreenshotToFirebaseA {
  final FirebaseService firebaseService;

  SaveScreenshotToFirebaseA(this.firebaseService);

  Future<void> saveScreenshotToFirebase(File image) async =>
      await firebaseService.saveScreenshotToFirebase(image: image);
}
