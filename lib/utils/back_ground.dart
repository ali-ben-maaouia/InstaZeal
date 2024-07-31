import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:insta_clone/features/home/screens/home_screen.dart';
import 'package:insta_clone/features/home/screens/reels.dart';
import 'package:insta_clone/features/home/screens/searchPost.dart';
import 'package:insta_clone/features/home/screens/profile.dart';
import 'package:insta_clone/utils/theme/theme_state.dart';

import '../features/home/repository/getUser.dart';
import '../features/home/screens/addPost/add.dart';

class BackGround extends StatefulWidget {
  const BackGround({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _BackGroundState createState() => _BackGroundState();
}
class _BackGroundState extends State<BackGround> {
  Uint8List? profileImageBytes; // Bytes of the profile image

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    final getUserRepo getuserrepo = getUserRepo();
    try {
      var user = await getuserrepo.getUserByToken();
      setState(() {
        var userjson = jsonDecode(user);
        String? base64String = userjson['file']['data']; // Assuming this is a base64 encoded string

        if (base64String != null) {
          profileImageBytes = base64Decode(base64String); // Convert base64 string to Uint8List
        }
      });
    } catch (e) {
      print('Failed to get user: $e');
    }
  }

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
          bottom: 80,
          left: 0,
          right: 0,
          child: widget.child,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        _navigateToPage('Home', HomeScreen());
                      },
                      icon: Icon(
                        Icons.home_filled,
                        color: themeProvider.currentPage == 'Home'
                            ? Colors.orange.shade700
                            : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _navigateToPage('Search', SearchPost());
                      },
                      icon: Icon(
                        Icons.search,
                        color: themeProvider.currentPage == 'Search'
                            ? Colors.orange.shade700
                            : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _navigateToPage('post', NewPostPage());
                      },
                      icon: Icon(
                        Icons.add_box_outlined,
                        color: themeProvider.currentPage == 'post'
                            ? Colors.orange.shade700
                            : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _navigateToPage('Reels', ReelsPage());
                      },
                      icon: Icon(
                        Icons.favorite_border,
                        color: themeProvider.currentPage == 'Reels'
                            ? Colors.orange.shade700
                            : Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _navigateToPage('Profile', ProfilePage());
                      },
                      icon: profileImageBytes != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(122),
                        child: Image.memory(
                          profileImageBytes!,
                          fit: BoxFit.cover,
                          height: 25,
                          width: 25,
                        ),
                      )
                          : Icon(
                        Icons.account_circle,
                        size: 25,
                        color: themeProvider.currentPage == 'Profile'
                            ? Colors.orange.shade700
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToPage(String page, Widget destination) {
    setState(() {
      Provider.of<ThemeProvider>(context, listen: false).updateNavigation(page);
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }
}
