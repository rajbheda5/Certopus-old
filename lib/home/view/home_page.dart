import 'package:certopus/Constants/colors.dart';
import 'package:certopus/Models/custom_theme.dart';
import 'package:certopus/Screens/create_page.dart';
import 'package:certopus/Screens/dashboard.dart';
import 'package:certopus/Screens/events_page.dart';
import 'package:certopus/Screens/profile_page.dart';
import 'package:certopus/Widgets/bottom_nav_bar_painter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
      _controller.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void pageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  PageController _controller = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    setTheme();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool('isDark') ?? false;
    isDark
        ? Provider.of<CustomTheme>(context, listen: false).setDark()
        : Provider.of<CustomTheme>(context, listen: false).setLight();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<CustomTheme>(
      builder: (BuildContext context, CustomTheme theme, Widget child) {
        return Scaffold(
          body: Stack(
            children: [
              PageView(
                controller: _controller,
                onPageChanged: (index) => pageChanged(index),
                children: [
                  Dashboard(),
                  CreatePage(),
                  EventsPage(),
                  ProfilePage(),
                ],
              ),
              //Nav Bar
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: size.width,
                  height: 80,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      CustomPaint(
                        size: Size(size.width, 80),
                        painter: BNBCustomPainter(theme.getPrimaryColor),
                      ),
                      Center(
                        heightFactor: 0.6,
                        child: FloatingActionButton(
                            backgroundColor: kOrange,
                            child: Icon(Icons.camera_enhance),
                            elevation: 0.1,
                            onPressed: () {}),
                      ),
                      Container(
                        width: size.width,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.home,
                                color: currentIndex == 0 ? kOrange : kWhite,
                                size: currentIndex == 0 ? 34 : 24,
                              ),
                              onPressed: () {
                                setBottomBarIndex(0);
                              },
                              splashColor: Colors.white,
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.note_add,
                                  color: currentIndex == 1 ? kOrange : kWhite,
                                  size: currentIndex == 1 ? 34 : 24,
                                ),
                                onPressed: () {
                                  setBottomBarIndex(1);
                                }),
                            Container(
                              width: size.width * 0.20,
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.tour,
                                  color: currentIndex == 2 ? kOrange : kWhite,
                                  size: currentIndex == 2 ? 34 : 24,
                                ),
                                onPressed: () {
                                  setBottomBarIndex(2);
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.account_circle,
                                  color: currentIndex == 3 ? kOrange : kWhite,
                                  size: currentIndex == 3 ? 34 : 24,
                                ),
                                onPressed: () {
                                  setBottomBarIndex(3);
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
