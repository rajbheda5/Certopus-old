import 'package:certopus/Models/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomTheme>(
      builder: (BuildContext context, CustomTheme theme, Widget child) {
        return Container(
          color: theme.getBackgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: Row(
            children: [
              FlatButton(
                onPressed: () =>
                    Provider.of<CustomTheme>(context, listen: false).setDark(),
                child: Text(
                  'Dark',
                  style: TextStyle(color: theme.getSecondaryColor),
                ),
              ),
              FlatButton(
                onPressed: () =>
                    Provider.of<CustomTheme>(context, listen: false).setLight(),
                child: Text(
                  'Light',
                  style: TextStyle(color: theme.getSecondaryColor),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
