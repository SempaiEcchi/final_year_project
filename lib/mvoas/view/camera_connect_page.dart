import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:permission/permission.dart';
import 'package:provider/provider.dart';
import 'package:zavrsnirad/mvoas/action/esp32_actions.dart';
import 'package:zavrsnirad/mvoas/action/storage_actions.dart';
import 'package:zavrsnirad/mvoas/observable/connection_o.dart';
import 'package:zavrsnirad/mvoas/observable/storage_o.dart';
import 'package:zavrsnirad/mvoas/service/connectivity_service.dart';
import 'package:zavrsnirad/mvoas/view/camera_view_page.dart';
import 'package:zavrsnirad/provider/_provider.dart';
import 'package:zavrsnirad/router/router.dart';

class ConnectToCameraPage extends StatefulWidget {
  @override
  _ConnectToCameraPageState createState() => _ConnectToCameraPageState();
}

class _ConnectToCameraPageState extends State<ConnectToCameraPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionO>(builder: (context, o, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.photo_library),
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteName.firebasePhotos),
          ),
          actions: <Widget>[
            IconButton(
              color: Colors.black,
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(RouteName.settings);
              },
            )
          ],
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'ESP32-CAM App',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Spacer(),
              LoadingRotating.square(
                backgroundColor: Colors.white,
                borderColor: o.cstatus == Cstatus.notConnected
                    ? Colors.red
                    : Colors.purpleAccent,
                size: 100,
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    o.connectionStatus.toUpperCase() + " TO ESP32",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w300, fontSize: 26.0),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(color: Colors.red)),
                onPressed: () async {
                  await Permission.requestPermissions(
                      [PermissionName.Internet, PermissionName.Location]);

                  o.cstatus == Cstatus.connected
                      ? await _connectToChannel(context)
                      : await _retryConnection(context);
                },
                color: o.cstatus == Cstatus.notConnected
                    ? Colors.red
                    : Colors.purpleAccent,
                textColor: Colors.white,
                child: Text(
                  o.cstatus == Cstatus.connected
                      ? "Connect"
                      : "Retry connection",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    });
  }

  _connectToChannel(BuildContext context) async {
    await StaticProvider.of<ConnectToChannelA>(context)
        .connectToChannel()
        .then((channel) {
      return Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => CameraViewPage(
          channel: channel,
        ),
      ));
    }).catchError((err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    });
  }

  void _retryConnection(BuildContext context) {
    StaticProvider.of<ConnectivityService>(context).initConnection();
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var _ipController = TextEditingController();
  var _SSIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageO>(builder: (context, o, snapshot) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Here you can edit the connection IP and search SSID',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
            Flexible(
              child: Container(
                height: 60,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _ipController..text = o.ip,
                      decoration: InputDecoration(
                          labelText: 'IP', border: OutlineInputBorder()),
//                        controller: controller,
                    )),
              ),
            ),
            Flexible(
              child: Container(
                height: 60,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _SSIDController..text = o.ssid,
                      decoration: InputDecoration(
                          labelText: 'SSID', border: OutlineInputBorder()),
//                        controller: controller,
                    )),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RaisedButton(
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: Colors.red)),
              onPressed: () async {
                await StaticProvider.of<SaveToStorageA>(context).saveToStorage(
                  _ipController.text,
                  _SSIDController.text,
                );
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Text(
                "SAVE",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    _SSIDController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
