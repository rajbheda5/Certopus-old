import 'package:certopus/Models/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomTheme>(
      builder: (BuildContext context, CustomTheme theme, Widget child) {
        return Container(
          color: theme.getBackgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: Center(child: Text('Events')),
        );
      },
    );
  }
}
