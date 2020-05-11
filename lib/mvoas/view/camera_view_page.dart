import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:intl/intl.dart';
import 'package:permission/permission.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:save_in_gallery/save_in_gallery.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zavrsnirad/mvoas/action/esp32_actions.dart';
import 'package:zavrsnirad/mvoas/action/firebase_actions.dart';
import 'package:zavrsnirad/mvoas/service/esp32_service.dart';
import 'package:zavrsnirad/mvoas/view/camera_connect_page.dart';
import 'package:zavrsnirad/provider/_provider.dart';
import 'package:zavrsnirad/t.dart';

class CameraViewPage extends StatefulWidget {
  @override
  _CameraViewPageState createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  final double videoWidth = 640;
  final double videoHeight = 480;

  String _timeString;

  var _globalKey = new GlobalKey();

  Timer _timer;
  bool isRecording;
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

  int frameNum;
  ProgressDialog pr;

  ESP32A esp32a;

  double adaptedWidth;

  double newVideoSizeHeight=480;
  @override
  void initState() {
    super.initState();
    esp32a = StaticProvider.of<ESP32A>(context);
    isRecording = false;

    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    frameNum = 0;
    VideoUtil.workPath = 'images';
    VideoUtil.getAppTempDirectory();

    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: 'Saving video ...',
        borderRadius: 10,
        backgroundColor: Colors.black,
        progressWidget: CircularProgressIndicator(),
        elevation: 10,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.white70, fontSize: 17, fontWeight: FontWeight.w300));
  }

  @override
  void dispose() {
    esp32a.disconnectFromChannel();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    adaptedWidth = screenWidth;
    newVideoSizeHeight = videoHeight * adaptedWidth / videoWidth;


    return Scaffold(
      body: false
          ? RepaintBoundary(
              key: _globalKey,
              child: Container(
                width: 100,
                height: 100,
                color: Colors.red,
              ),
            )
          : Consumer<ESP32Service>(builder: (context, o, c) {
              return Container(
                color: Colors.black,
                child: StreamBuilder(
                  stream: o.channel.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Future.delayed(Duration(milliseconds: 100)).then((_) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ConnectToCameraPage()));
                      });
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    } else {
                      if (isRecording) {
                        VideoUtil.saveImageFileToDirectory(
                            snapshot.data, 'image_$frameNum.jpg');
                        frameNum++;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  RepaintBoundary(
                                    key: _globalKey,
                                    child: GestureZoomBox(
                                      maxScale: 5.0,
                                      doubleTapScale: 2.0,
                                      duration: Duration(milliseconds: 200),
                                      child: Image.memory(
                                        snapshot.data,
                                        gaplessPlayback: true,
                                        width: adaptedWidth,
                                        height: videoHeight,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                      child: Align(
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 46,
                                        ),
                                        isRecording
                                            ? BlinkingTimer()
                                            : Container(),
                                      ],
                                    ),
                                    alignment: Alignment.topCenter,
                                  )),
                                  Positioned.fill(
                                      child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      _timeString,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ))
                                ],
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: Colors.black,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                            isRecording
                                                ? Icons.stop
                                                : Icons.videocam,
                                            size: 24,
                                          ),
                                          onPressed: videoRecording,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.photo_camera,
                                            size: 24,
                                          ),
                                          onPressed: () async {
                                            await takeScreenShot();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              );
            }),
      floatingActionButton: speedDial(),
    );
  }

  takeScreenShot({bool saveToFirebase = false}) async {
    Permission.requestPermissions([PermissionName.Storage]).then((value) async {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();

      ui.Image image = await boundary.toImage();
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      Directory d = Directory('/storage/emulated/0');
      if (d.existsSync()) {
        Directory(d.path + '/MyApp').createSync();
        File imgFile =
            new File(d.path + '/MyApp/screenshot${DateTime.now()}.png');
        print('saving to ${imgFile.path}');
        imgFile.createSync();
        imgFile.writeAsBytes(pngBytes);
        if (saveToFirebase)
          StaticProvider.of<FirebaseA>(context)
              .saveScreenshotToFirebase(imgFile);
      }
    });
    Fluttertoast.showToast(
        msg: "Image saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd HH:mm:ss').format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    Future.delayed(
        Duration.zero,
        () => setState(() {
              _timeString = _formatDateTime(now);
            }));
  }

  Widget speedDial() {
    return SpeedDial(
      overlayOpacity: 0.0,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          backgroundColor: Colors.orange,
          child: Icon(
            Icons.photo_camera,
            color: Colors.white,
          ),
          onTap: () async {
            await takeScreenShot(saveToFirebase: true);
          },
        ),
        SpeedDialChild(
                    child: Icon(Icons.photo_camera),
          onTap: () async {
            await takeScreenShot();
          },
        ),
        SpeedDialChild(
            child: isRecording ? Icon(Icons.stop) : Icon(Icons.videocam),
            onTap: videoRecording),
        SpeedDialChild(
            child: isRecording ? Icon(Icons.file_upload) : Icon(Icons.videocam),
            onTap: videoRecording(saveToFirebase:true))
      ],
    );
  }

  videoRecording({bool saveToFirebase=false}) {
    isRecording = !isRecording;
    if (!isRecording && frameNum > 0) {
      frameNum = 0;
      makeVideoWithFFMpeg(saveToFirebase);
    }
  }

  Future<int> execute(String command) async {
    return await _flutterFFmpeg.execute(command);
  }

  makeVideoWithFFMpeg(bool saveToFirebase) {
    pr.show();
    String tempVideofileName = "${DateTime.now().millisecondsSinceEpoch}.mp4";
    execute(VideoUtil.generateEncodeVideoScript("mpeg4", tempVideofileName))
        .then((rc) {
      pr.hide();
      if (rc == 0) {
        print("Video complete");
        String outputPath = VideoUtil.appTempDir + "/$tempVideofileName";
        _saveVideo(outputPath);
      }
    });
  }

  _saveVideo(String path) async {
    GallerySaver.saveVideo(path).then((result) {
      print("Video Save result : $result");

      Fluttertoast.showToast(
          msg: result ? "Video Saved" : "Video Failure!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      VideoUtil.deleteTempDirectory();
    });
  }
}
