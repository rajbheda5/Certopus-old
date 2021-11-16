import 'package:certopus/Constants/colors.dart';
import 'package:certopus/Constants/strings.dart';
import 'package:certopus/Models/custom_theme.dart';
import 'package:certopus/home/home.dart';
import 'package:certopus/login/view/login_page.dart';
import 'package:certopus/Widgets/glass_light_leak.dart';
import 'package:certopus/Widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  final TextEditingController _orgNameController = TextEditingController();
  String _selectedDate;
  bool _obscureTextLogin = true;
  bool _confirmobscureTextLogin = true;
  bool _success;
  String _userEmail;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference firestoreUsers =
      FirebaseFirestore.instance.collection('users');

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _confirmtoggleLogin() {
    setState(() {
      _confirmobscureTextLogin = !_confirmobscureTextLogin;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime date = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Provider.of<CustomTheme>(context).isDark
                ? ThemeData.dark()
                : ThemeData.light(),
            child: child,
          );
        },
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1903, 1),
        helpText: 'SELECT YOUR BIRTHDATE',
        lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        _selectedDate = DateFormat.yMMMMd('en_US').format(date);
        _dateController.text = _selectedDate;
      });
    }
  }

  void _register() async {
    if (Provider.of<User>(context) == null) {
      try {
        final User user = (await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ))
            .user;
        if (user != null) {
          setState(() {
            _success = true;
            _userEmail = user.email;
            try {
              firestoreUsers.doc(user.uid).set({
                'full_name': _nameController.text,
                'birthdate': _dateController.text,
                'organisation': _orgNameController.text,
              });
              user.sendEmailVerification();
            } catch (e) {
              print(e);
            }
          });
        } else {
          _success = false;
        }
      } catch (e) {
        print(e);
      }
    } else {
      Provider.of<User>(context).sendEmailVerification();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<CustomTheme>(
        builder: (BuildContext context, CustomTheme theme, Widget child) {
          return Stack(
            children: [
              GlassLightLeak(),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.1,
                          color: theme.isDark ? kWhite : kDarkBlue,
                          fontFamily: kFonts,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Flexible(
                          child: Form(
                        key: _formKey,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Full Name',
                                style: TextStyle(
                                  color: theme.getSecondaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontFamily: kFonts,
                                ),
                              ),
                              TextFormField(
                                controller: _nameController,
                                cursorColor: theme.getSecondaryColor,
                                keyboardType: TextInputType.name,
                                cursorRadius: Radius.circular(16.0),
                                cursorWidth: 1.0,
                                autocorrect: false,
                                validator: (String value) {
                                  if (value.length < 5)
                                    return 'Please enter your full name';
                                  return null;
                                },
                                style: TextStyle(
                                  color:
                                      theme.isDark ? kDarkPrimary : kDarkBlue,
                                  fontFamily: kFonts,
                                  fontWeight: FontWeight.bold,
                                ),
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: 'Full Name',
                                  hintStyle: TextStyle(
                                    color: theme.getSecondaryColor
                                        .withOpacity(0.5),
                                    fontFamily: kFonts,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.getSecondaryColor
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Text(
                                'Email',
                                style: TextStyle(
                                  color: theme.getSecondaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontFamily: kFonts,
                                ),
                              ),
                              TextFormField(
                                controller: _emailController,
                                cursorColor: theme.getSecondaryColor,
                                keyboardType: TextInputType.emailAddress,
                                cursorRadius: Radius.circular(16.0),
                                cursorWidth: 1.0,
                                autocorrect: false,
                                validator: (String value) {
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);
                                  if (value.isEmpty)
                                    return 'Please enter your email';
                                  if (!emailValid)
                                    return 'Please enter a valid email';
                                  return null;
                                },
                                style: TextStyle(
                                  color:
                                      theme.isDark ? kDarkPrimary : kDarkBlue,
                                  fontFamily: kFonts,
                                  fontWeight: FontWeight.bold,
                                ),
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: 'yourname@email.com',
                                  hintStyle: TextStyle(
                                    color: theme.getSecondaryColor
                                        .withOpacity(0.5),
                                    fontFamily: kFonts,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.getSecondaryColor
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Text(
                                'Birthdate',
                                style: TextStyle(
                                  color: theme.getSecondaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontFamily: kFonts,
                                ),
                              ),
                              TextFormField(
                                controller: _dateController,
                                cursorColor: theme.getSecondaryColor,
                                keyboardType: TextInputType.datetime,
                                cursorRadius: Radius.circular(16.0),
                                cursorWidth: 1.0,
                                validator: (String value) {
                                  if (value.length < 10)
                                    return 'Please enter valid date';
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9/]")),
                                ],
                                style: TextStyle(
                                  color:
                                      theme.isDark ? kDarkPrimary : kDarkBlue,
                                  fontFamily: kFonts,
                                  fontWeight: FontWeight.bold,
                                ),
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: 'DD/MM/YYYY',
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.calendar_today_outlined,
                                        size: 15.0,
                                        color:
                                            theme.isDark ? kWhite : kDarkBlue,
                                      ),
                                      onPressed: () {
                                        _selectDate(context);
                                      }),
                                  hintStyle: TextStyle(
                                    color: theme.getSecondaryColor
                                        .withOpacity(0.5),
                                    fontFamily: kFonts,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.getSecondaryColor
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Text(
                                'Organisation',
                                style: TextStyle(
                                  color: theme.getSecondaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontFamily: kFonts,
                                ),
                              ),
                              TextFormField(
                                controller: _orgNameController,
                                cursorColor: theme.getSecondaryColor,
                                keyboardType: TextInputType.name,
                                cursorRadius: Radius.circular(16.0),
                                cursorWidth: 1.0,
                                autocorrect: false,
                                validator: (String value) {
                                  if (value.length < 3)
                                    return 'Please enter your Organisation name';
                                  return null;
                                },
                                style: TextStyle(
                                  color:
                                      theme.isDark ? kDarkPrimary : kDarkBlue,
                                  fontFamily: kFonts,
                                  fontWeight: FontWeight.bold,
                                ),
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: 'Organisation Name',
                                  hintStyle: TextStyle(
                                    color: theme.getSecondaryColor
                                        .withOpacity(0.5),
                                    fontFamily: kFonts,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.getSecondaryColor
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40),
                              Text(
                                'Password',
                                style: TextStyle(
                                  color: theme.getSecondaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontFamily: kFonts,
                                ),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                cursorColor: theme.getSecondaryColor,
                                keyboardType: TextInputType.emailAddress,
                                cursorRadius: Radius.circular(16.0),
                                cursorWidth: 1.0,
                                autocorrect: false,
                                obscureText: _obscureTextLogin,
                                validator: (String value) {
                                  if (value.length < 8)
                                    return 'Please enter a strong Password';
                                  return null;
                                },
                                style: TextStyle(
                                  color:
                                      theme.isDark ? kDarkPrimary : kDarkBlue,
                                  fontFamily: kFonts,
                                  fontWeight: FontWeight.bold,
                                ),
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: 'Your Password',
                                  hintStyle: TextStyle(
                                    color: theme.getSecondaryColor
                                        .withOpacity(0.5),
                                    fontFamily: kFonts,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: _toggleLogin,
                                    child: Icon(
                                      _obscureTextLogin
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: theme.isDark ? kWhite : kDarkBlue,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.getSecondaryColor
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Text(
                                'Confirm Password',
                                style: TextStyle(
                                  color: theme.getSecondaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontFamily: kFonts,
                                ),
                              ),
                              TextFormField(
                                controller: _confirmpasswordController,
                                cursorColor: theme.getSecondaryColor,
                                keyboardType: TextInputType.emailAddress,
                                cursorRadius: Radius.circular(16.0),
                                cursorWidth: 1.0,
                                autocorrect: false,
                                obscureText: _confirmobscureTextLogin,
                                validator: (String value) {
                                  if (value != _passwordController.text)
                                    return 'Confirm your password again!';
                                  return null;
                                },
                                style: TextStyle(
                                  color:
                                      theme.isDark ? kDarkPrimary : kDarkBlue,
                                  fontFamily: kFonts,
                                  fontWeight: FontWeight.bold,
                                ),
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: 'Confirm your Password',
                                  hintStyle: TextStyle(
                                    color: theme.getSecondaryColor
                                        .withOpacity(0.5),
                                    fontFamily: kFonts,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: _confirmtoggleLogin,
                                    child: Icon(
                                      _confirmobscureTextLogin
                                          ? FontAwesomeIcons.eye
                                          : FontAwesomeIcons.eyeSlash,
                                      size: 15.0,
                                      color: theme.isDark ? kWhite : kDarkBlue,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: theme.getSecondaryColor
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
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
                            _register();
                            showInSnackBar(
                                'Verification email sent! Please verify',
                                context,
                                _scaffoldKey);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => HomePage(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.width * 0.15,
                          alignment: Alignment.center,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: kWhite,
                              fontFamily: kFonts,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Already have an account yet?',
                              style: TextStyle(
                                color: theme.isDark
                                    ? kLightSecondary.withOpacity(0.8)
                                    : theme.getSecondaryColor,
                                fontFamily: kFonts,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LoginPage(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Sign up',
                                    style: TextStyle(
                                      color: theme.isDark ? kWhite : kDarkBlue,
                                      fontFamily: kFonts,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: theme.isDark ? kWhite : kDarkBlue,
                                    size: 16.0,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
