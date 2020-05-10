import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zavrsnirad/provider/action_provider.dart';
import 'package:zavrsnirad/provider/model_provider.dart';
import 'package:zavrsnirad/provider/observable_provider.dart';
import 'package:zavrsnirad/provider/service_provider.dart';

List<SingleChildWidget> providers = [
  ...serviceProviders,
  ...modelProviders,
  ...observableProviders,
  ...actionProviders
];

class StaticProvider extends Provider {
  static T of<T>(BuildContext context) =>
      Provider.of<T>(context, listen: false);
}
