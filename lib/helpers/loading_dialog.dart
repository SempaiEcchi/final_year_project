import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context) {
  var alert = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(child: CircularProgressIndicator()),
    ],
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
