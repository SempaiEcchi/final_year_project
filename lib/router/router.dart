import 'package:flutter/material.dart';
import 'package:zavrsnirad/mvoas/view/camera_connect_page.dart';
import 'package:zavrsnirad/mvoas/view/camera_view_page.dart';
import 'package:zavrsnirad/mvoas/view/firebase_photos.dart';

class Router {
  static Route generator(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homePage:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ConnectToCameraPage(),
        );
      case RouteName.cameraViewPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return CameraViewPage();
          },
        );
      case RouteName.firebasePhotos:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return FirebasePhotos();
          },
        );
      case RouteName.settings:
        return _Overlay(child: Settings());

      default:
        return MaterialPageRoute(
          builder: (_) => Container(),
        );
    }
  }
}

class RouteName {
  static const homePage = '/';
  static const cameraViewPage = 'cameraHome';
  static const settings = 'settings';

  static const firebasePhotos = "fbphotos";
}

class _Overlay extends ModalRoute {
  final Widget child;

  _Overlay({this.child});

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return Material(
      child: child,
      type: MaterialType.transparency,
    );
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => false;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration.zero;

  @override
  // TODO: implement barrierColor
  Color get barrierColor => null;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => "";
}
