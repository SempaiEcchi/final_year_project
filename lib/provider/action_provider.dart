import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zavrsnirad/mvoas/action/esp32_actions.dart';
import 'package:zavrsnirad/mvoas/action/firebase_actions.dart';
import 'package:zavrsnirad/mvoas/action/storage_actions.dart';

List<SingleChildWidget> actionProviders = [
  Provider<ConnectToChannelA>(
    create: (context) => ConnectToChannelA(Provider.of(context, listen: false),
        Provider.of(context, listen: false)),
  ),
  Provider<SaveToStorageA>(
    create: (context) => SaveToStorageA(Provider.of(context, listen: false)),
  ),
  Provider<SaveScreenshotToFirebaseA>(
    create: (context) =>
        SaveScreenshotToFirebaseA(Provider.of(context, listen: false)),
  ),
];
