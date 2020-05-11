import 'package:flutter/material.dart';

class StorageO {
  final String ip, ssid;

  const StorageO({
    @required this.ip,
    @required this.ssid,
  });
}

class ImagesO {
  final Map<String, String> images;

  ImagesO(this.images);
}
