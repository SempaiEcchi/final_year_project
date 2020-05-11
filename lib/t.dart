import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class VideoUtil {
  static String workPath;
  static String appTempDir;

  static Future<void> getAppTempDirectory() async {
    appTempDir = '${(await getTemporaryDirectory()).path}/$workPath';
  }

  static Future<void> saveImageFileToDirectory(
      Uint8List byteData, String localName) async {
    Directory(appTempDir).create().then((Directory directory) async {
      final file = File('${directory.path}/$localName');

      await file.writeAsBytesSync(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      print("filePath : ${file.path}");
    });
  }

  static Future<void> deleteTempDirectory() {
    Directory(appTempDir).deleteSync(recursive: true);
  }

  static String generateEncodeVideoScript(String videoCodec, String fileName) {
    String outputPath = appTempDir + "/" + fileName;
    return "-hide_banner -y -i '" +
        appTempDir +
        "/" +
        "image_%d.jpg" +
        "' " +
        "-c:v " +
        videoCodec +
        " -r 12 " +
        outputPath;
  }
}

class BlinkingTimer extends StatefulWidget {
  @override
  _BlinkingTimerState createState() => _BlinkingTimerState();
}

class _BlinkingTimerState extends State<BlinkingTimer>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  DateTime currentTime;
  String _timeString;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();

    _timeString = "00:00";
    currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTimer());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 30,
      decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeTransition(
            opacity: _animationController,
            child: Container(
              width: 20,
              height: 20,
              decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(_timeString,style: TextStyle(color: Colors.white),)
        ],
      ),
    );
  }

  _getTimer() {
    final DateTime now = DateTime.now();
    Duration d = now.difference(currentTime);

    setState(() {
      _timeString =
          "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
    });
  }

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
