import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zavrsnirad/mvoas/action/esp32_actions.dart';
import 'package:zavrsnirad/mvoas/action/firebase_actions.dart';
import 'package:zavrsnirad/mvoas/action/storage_actions.dart';

List<SingleChildWidget> actionProviders = [
  Provider<ESP32A>(
    create: (context) => ESP32A(Provider.of(context, listen: false),
        Provider.of(context, listen: false)),
  ),
  Provider<SaveToStorageA>(
    create: (context) => SaveToStorageA(Provider.of(context, listen: false)),
  ),
  Provider<FirebaseA>(
    create: (context) =>
        FirebaseA(Provider.of(context, listen: false)),
  ),
];
