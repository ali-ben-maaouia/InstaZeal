import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insta_clone/features/home/screens/home_screen.dart';
import 'package:insta_clone/features/home/screens/reels.dart';
import 'package:insta_clone/features/home/screens/searchPost.dart';
import 'package:insta_clone/features/home/screens/profile.dart';
import 'package:insta_clone/utils/theme/theme_state.dart';

import '../features/home/screens/addPost/add.dart';

class BackGround2 extends StatelessWidget {
  const BackGround2({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Stack(
      children: [
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor,
                  ...themeProvider.themeMode
                      ? [
                    Colors.orange.withOpacity(.1),
                    Colors.blue.withOpacity(.2),
                  ]
                      : [
                    Colors.orange.shade100,
                    Colors.blue.shade100,
                  ]
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 20,
          left: 0,
          right: 0,
          child: child,
        ),
      ],
    );
  }
}
