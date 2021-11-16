import 'dart:math';
import 'dart:ui';

import 'package:certopus/Constants/colors.dart';
import 'package:certopus/Models/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { top, center, bottom }

class GlassLightLeak extends StatelessWidget {
  final _tween = TimelineTween<AniProps>()
    ..addScene(begin: 0.milliseconds, end: 1000.milliseconds)
        .animate(AniProps.top, tween: 0.0.tweenTo(100.0))
    ..addScene(begin: 1000.milliseconds, end: 1500.milliseconds)
        .animate(AniProps.center, tween: 100.0.tweenTo(200.0))
    ..addScene(begin: 0.milliseconds, duration: 1500.milliseconds)
        .animate(AniProps.bottom, tween: 100.0.tweenTo(200.0));
  final Random _random = Random();
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomTheme>(
        builder: (BuildContext context, CustomTheme theme, Widget child) {
      return PlayAnimation<TimelineValue<AniProps>>(
          tween: _tween, // Pass in tween
          duration: _tween.duration, // Obtain duration
          builder: (context, child, value) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: theme.getBackgroundColor,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: AnimatedContainer(
                      decoration: BoxDecoration(
                        color: theme.isDark
                            ? kLightPrimary
                            : theme.getPrimaryColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      duration: Duration(seconds: 5),
                      transform: Matrix4.identity()
                        ..setEntry(
                            1,
                            3,
                            _random.nextDouble() * value.get(AniProps.top) -
                                100.0),
                      width: value.get(AniProps.top),
                      height: value.get(AniProps.top)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      color: theme.isDark
                          ? kBlue
                          : theme.getPrimaryColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    duration: Duration(seconds: 5),
                    transform: Matrix4.identity()
                      ..setEntry(
                          1,
                          3,
                          _random.nextDouble() * value.get(AniProps.center) -
                              150.0),
                    width: value.get(AniProps.center),
                    height: 2 * value.get(AniProps.center),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      color: theme.getPrimaryColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    duration: Duration(seconds: 5),
                    transform: Matrix4.identity()
                      ..setEntry(1, 3,
                          _random.nextDouble() * value.get(AniProps.bottom)),
                    width: value.get(AniProps.bottom),
                    height: value.get(AniProps.bottom),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 70, sigmaY: 100),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            );
          });
    });
  }
}
