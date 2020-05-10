import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:provider/provider.dart';
import 'package:zavrsnirad/mvoas/observable/storage_o.dart';

class FirebasePhotos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ImagesO>(builder: (context, o, c) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            title: Text(
              'FIREBASE IMAGES',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: _buildWidgetsFromObservable(o),
              ),
            ),
          ));
    });
  }

  _buildWidgetsFromObservable(ImagesO o) {
    List<Widget> widgets = List();
    o.images.forEach((NAME, URL) {
      widgets.add(_NetworkImage(URL: URL, NAME: NAME));
    });
    return widgets;
  }
}

class _NetworkImage extends StatelessWidget {
  final String URL;
  final String NAME;

  const _NetworkImage({
    @required this.URL,
    this.NAME,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: <Widget>[
            Text(NAME),
            GestureZoomBox(
              child: CachedNetworkImage(
                imageUrl: URL,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
