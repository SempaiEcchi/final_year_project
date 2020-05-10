import 'package:flutter/foundation.dart';

class StorageE {
  final String ip, ssid;

  const StorageE({
    @required this.ip,
    @required this.ssid,
  });

  StorageE copyWith({String ip, ssid}) {
    return new StorageE(
      ssid: ssid ?? this.ssid,
      ip: ip ?? this.ip,
    );
  }
}
