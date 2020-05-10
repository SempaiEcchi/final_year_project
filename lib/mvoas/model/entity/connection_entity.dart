import 'package:dart_mc_ping/model/status_response.dart';
import 'package:flutter/foundation.dart';
import 'package:zavrsnirad/mvoas/observable/connection_o.dart';

class ConnectionE {
  final Cstatus cstatus;

  const ConnectionE({
    @required this.cstatus,
  });
}

class PingE {
  final StatusResponse info;

  const PingE({
    @required this.info,
  });
}
