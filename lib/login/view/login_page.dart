import 'dart:ui';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:certopus/Constants/colors.dart';
import 'package:certopus/Constants/strings.dart';
import 'package:certopus/Models/custom_theme.dart';
import 'package:certopus/Screens/signup.dart';
import 'package:certopus/Widgets/glass_light_leak.dart';
import 'package:certopus/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:formz/formz.dart';

class LoginPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
        child: Consumer<CustomTheme>(
            builder: (BuildContext context, CustomTheme theme, Widget child) {
          return Stack(
            children: [
              GlassLightLeak(),
              BlocListener<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.status.isSubmissionFailure) {
                    Scaffold.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(content: Text('Authentication Failure')),
                      );
                  }
                },
                child: Container(
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
                          'Login',
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  color: theme.getSecondaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontFamily: kFonts,
                                ),
                              ),
                              _EmailInput(
                                theme: theme,
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Text(
                                'Password',
                                style: TextStyle(
                                  color: theme.getSecondaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontFamily: kFonts,
                                ),
                              ),
                              _PasswordInput(
                                theme: theme,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        _LoginButton(
                          theme: theme,
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
                                'Don\'t have an account yet?',
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
                                      builder: (_) => Signup(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color:
                                            theme.isDark ? kWhite : kDarkBlue,
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key key,
    @required CustomTheme theme,
  })  : theme = theme,
        super(key: key);

  final CustomTheme theme;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : RaisedButton(
                key: const Key('loginForm_continue_raisedButton'),
                color: theme.isDark
                    ? Color.fromRGBO(37, 37, 55, 1.0)
                    : theme.getPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                onPressed: state.status.isValidated
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.width * 0.15,
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: kWhite,
                      fontFamily: kFonts,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    Key key,
    @required CustomTheme theme,
  })  : theme = theme,
        super(key: key);
  final CustomTheme theme;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.obscure != current.obscure,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          cursorColor: theme.getSecondaryColor,
          keyboardType: TextInputType.emailAddress,
          cursorRadius: Radius.circular(16.0),
          cursorWidth: 1.0,
          autocorrect: false,
          obscureText: state.obscure,
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          style: TextStyle(
            color: theme.isDark ? kDarkPrimary : kDarkBlue,
            fontFamily: kFonts,
            fontWeight: FontWeight.bold,
          ),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'yourpassword',
            errorText: state.password.invalid ? 'invalid password' : null,
            hintStyle: TextStyle(
              color: theme.getSecondaryColor.withOpacity(0.5),
              fontFamily: kFonts,
              fontWeight: FontWeight.w200,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                print("login page: ${state.obscure}");
                context.read<LoginCubit>().toggleLogin();
              },
              child: Icon(
                state.obscure
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye,
                size: 15.0,
                color: theme.isDark ? kWhite : kDarkBlue,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.getSecondaryColor.withOpacity(0.5),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({
    Key key,
    this.theme,
  }) : super(key: key);
  final CustomTheme theme;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          cursorColor: theme.getSecondaryColor,
          keyboardType: TextInputType.emailAddress,
          cursorRadius: Radius.circular(16.0),
          cursorWidth: 1.0,
          autocorrect: false,
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          style: TextStyle(
            color: theme.isDark ? kDarkPrimary : kDarkBlue,
            fontFamily: kFonts,
            fontWeight: FontWeight.bold,
          ),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'yourname@email.com',
            errorText: state.email.invalid ? 'invalid email' : null,
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
        );
      },
    );
  }
}
