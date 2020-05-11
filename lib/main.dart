import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zavrsnirad/provider/_provider.dart';
import 'package:zavrsnirad/router/router.dart';

void main() {

  runApp(MyApp());
}
var navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp( debugShowCheckedModeBanner: false,

        navigatorKey: navigatorKey,
        title: 'ESP32 CAM',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: Router.generator,
        initialRoute: RouteName.homePage,
      ),
    );
  }
}
