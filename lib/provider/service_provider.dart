import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zavrsnirad/mvoas/service/connectivity_service.dart';
import 'package:zavrsnirad/mvoas/service/esp32_service.dart';
import 'package:zavrsnirad/mvoas/service/firebase_service.dart';
import 'package:zavrsnirad/mvoas/service/local_storage_service.dart';

List<SingleChildWidget> serviceProviders = [
  Provider<LocalStorageService>(
    create: (context) => LocalStorageService(),
    lazy: false,
  ),
  Provider<ESP32Service>(
    create: (context) => ESP32Service(),
    lazy: false,
  ),
  Provider<ConnectivityService>(
    create: (context) =>
        ConnectivityService(Provider.of(context, listen: false)),
    lazy: false,
  ),
  Provider<FirebaseService>(
    create: (context) => FirebaseService(),
    lazy: false,
  ),
];
