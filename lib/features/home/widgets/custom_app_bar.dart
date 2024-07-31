import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/theme/theme_state.dart';
import 'package:provider/provider.dart';

import '../screens/listAmie.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int unreadMessageCount = 5; // Exemple de nombre de messages non lus (vous pouvez le remplacer par votre propre logique)
    int notificationCount = 3; // Exemple de nombre de notifications (vous pouvez le remplacer par votre propre logique)

    return SliverAppBar(
      automaticallyImplyLeading: false, // Ne pas inclure l'icône de retour
      backgroundColor: Colors.transparent,
      primary: true,
      title: Row(
        children: [
          Image.asset(
            'assets/icon/insta2.jpg',
            height: 45,
          ),
          const SizedBox(width: 10),
          const Text("SocioGram"),
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                // Ajouter l'action pour le bouton de notification
              },
              icon: Stack(
                children: [
                  Icon(CupertinoIcons.bell),
                  if (notificationCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '$notificationCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FriendListPage()),
                );
              },
              icon: Stack(
                children: [
                  Icon(CupertinoIcons.chat_bubble_2),
                  if (unreadMessageCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '$unreadMessageCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        Consumer<ThemeProvider>(builder: (context, value, _) {
          return IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).swap();
            },
            icon: value.themeMode
                ? const Icon(
              Icons.sunny,
            )
                : const Icon(CupertinoIcons.moon_fill),
          );
        }),
      ],
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MaterialApp(
        home: Scaffold(
          body: CustomAppBar(),
        ),
      ),
    ),
  );
}
