import 'package:certopus/Models/custom_theme.dart';
import 'package:certopus/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return Consumer<CustomTheme>(
      builder: (BuildContext context, CustomTheme theme, Widget child) {
        return Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              color: theme.getBackgroundColor,
            ),
            Container(
              width: size.width,
              height: size.height * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 210, 255, 1.0),
                    theme.getPrimaryColor
                  ],
                ),
              ),
              child: Center(
                child: Text(user.email ?? ''),
              ),
            ),
            Align(
              alignment: Alignment(0, -0.3),
              child: Container(
                width: size.width * 0.9,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5.0,
                      offset: Offset(0, 2.0),
                      color: theme.getSecondaryColor.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                key: const Key('homePage_logout_iconButton'),
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                onPressed: () => context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested()),
              ),
            ),
          ],
        );
      },
    );
  }
}
