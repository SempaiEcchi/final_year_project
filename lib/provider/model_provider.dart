import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zavrsnirad/mvoas/model/connection_model.dart';
import 'package:zavrsnirad/mvoas/model/local_storage_model.dart';
import 'package:zavrsnirad/mvoas/service/connectivity_service.dart';
import 'package:zavrsnirad/mvoas/service/local_storage_service.dart';

List<SingleChildWidget> modelProviders = [
  Provider<LocalStorageModel>(
    create: (context) => LocalStorageModel(
        Provider.of<LocalStorageService>(context, listen: false),
        Provider.of(context, listen: false)),
    lazy: false,
  ),
  Provider<ConnectionModel>(
    create: (context) => ConnectionModel(
        Provider.of<ConnectivityService>(context, listen: false)),
    lazy: false,
  ),
];
