import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zavrsnirad/mvoas/model/connection_model.dart';
import 'package:zavrsnirad/mvoas/model/local_storage_model.dart';
import 'package:zavrsnirad/mvoas/observable/connection_o.dart';
import 'package:zavrsnirad/mvoas/observable/storage_o.dart';

List<SingleChildWidget> observableProviders = [
  StreamProvider<StorageO>(
    lazy: false,
    create: (context) =>
        Provider.of<LocalStorageModel>(context, listen: false).storageO$,
  ),
  StreamProvider<ConnectionO>(
    lazy: false,
    create: (context) =>
        Provider.of<ConnectionModel>(context, listen: false).connectionO$,
  ),
  StreamProvider<PingO>(
    lazy: false,
    create: (context) =>
        Provider.of<ConnectionModel>(context, listen: false).pingO$,
  ),
  StreamProvider<ImagesO>(
    lazy: false,
    create: (context) =>
        Provider.of<LocalStorageModel>(context, listen: false).imagesO$,
  ),
];
