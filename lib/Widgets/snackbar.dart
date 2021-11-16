import 'package:flutter/material.dart';

void showInSnackBar(
    String value, BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) {
  FocusScope.of(context).requestFocus(FocusNode());
  _scaffoldKey.currentState?.removeCurrentSnackBar();
  var kFont;
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: kFont),
    ),
    backgroundColor: Colors.black.withOpacity(0.5),
    duration: Duration(seconds: 3),
  ));
}
