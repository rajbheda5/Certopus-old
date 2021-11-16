import 'dart:convert';
import 'dart:math';

import 'package:certopus/Constants/colors.dart';
import 'package:certopus/Constants/strings.dart';
import 'package:certopus/Models/custom_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final CollectionReference firestoreUsers =
      FirebaseFirestore.instance.collection('users');
  String hash = 'null';

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void generateHash() {
    String privateKey = getRandomString(64);
    var encodedKey = utf8.encode(privateKey);
    var encodedText =
        utf8.encode(_nameController.text + _eventNameController.text);
    var hmacSHA256 = Hmac(sha256, encodedKey);
    var digest = hmacSHA256.convert(encodedText);
    hash = digest.toString();
    setState(() {});
    firestoreUsers
        .doc(Provider.of<User>(context, listen: false).uid)
        .collection('certificates')
        .doc(hash)
        .set({
      'private_key': privateKey,
      'name': _nameController.text,
      'event': _eventNameController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<CustomTheme>(
      builder: (BuildContext context, CustomTheme theme, Widget child) {
        return Container(
          color: theme.getBackgroundColor,
          width: double.infinity,
          height: size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  cursorColor: theme.getSecondaryColor,
                  keyboardType: TextInputType.name,
                  cursorRadius: Radius.circular(16.0),
                  cursorWidth: 1.0,
                  autocorrect: false,
                  validator: (String value) {
                    if (value.length < 5) return 'Please enter your full name';
                    return null;
                  },
                  style: TextStyle(
                    color: theme.isDark ? kDarkPrimary : kDarkBlue,
                    fontFamily: kFonts,
                    fontWeight: FontWeight.bold,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    hintStyle: TextStyle(
                      color: theme.getSecondaryColor.withOpacity(0.5),
                      fontFamily: kFonts,
                      fontWeight: FontWeight.w200,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.getSecondaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                TextFormField(
                  controller: _eventNameController,
                  cursorColor: theme.getSecondaryColor,
                  keyboardType: TextInputType.name,
                  cursorRadius: Radius.circular(16.0),
                  cursorWidth: 1.0,
                  autocorrect: false,
                  validator: (String value) {
                    if (value.length < 5) return 'Please enter your full name';
                    return null;
                  },
                  style: TextStyle(
                    color: theme.isDark ? kDarkPrimary : kDarkBlue,
                    fontFamily: kFonts,
                    fontWeight: FontWeight.bold,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Event Name',
                    hintStyle: TextStyle(
                      color: theme.getSecondaryColor.withOpacity(0.5),
                      fontFamily: kFonts,
                      fontWeight: FontWeight.w200,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.getSecondaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text(
                  'Hash : $hash',
                  style: TextStyle(
                      fontFamily: kFonts, color: theme.getSecondaryColor),
                ),
                SizedBox(
                  height: 40.0,
                ),
                FlatButton(
                  color: theme.isDark
                      ? Color.fromRGBO(37, 37, 55, 1.0)
                      : theme.getPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      generateHash();
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.width * 0.15,
                    alignment: Alignment.center,
                    child: Text(
                      'Generate Hash',
                      style: TextStyle(
                        color: kWhite,
                        fontFamily: kFonts,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
