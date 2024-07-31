import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:insta_clone/features/home/screens/modifierProfile.dart';
import 'package:insta_clone/features/home/screens/profileSetting.dart';
import 'package:insta_clone/utils/back_ground.dart';

import '../repository/getUser.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _publications = 10;
  int _followers = 2;
  int _following = 20;
  String userName='';
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
        setState(() {
          userName=userjson['fullName']??'';
        });
      });
    } catch (e) {
      print('Failed to get user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackGround(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Profil'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Naviguer vers l'écran de paramètres
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: (profileImageBytes != null)
                        ? MemoryImage(profileImageBytes!)
                        : AssetImage('assets/images/placeholder.png') as ImageProvider,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    userName,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  // Ajout des trois colonnes ici
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$_publications',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Publications',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '$_followers',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Followers',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '$_following',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Suivi(e)s',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage()),
                      );
                      // Action pour suivre ou autre interaction
                    },
                    child: Text('Modifier le profil'),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // Action pour partager le profil
                    },
                    child: Text('Partager le profil'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 2.0,
                children: List.generate(12, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://example.com/post-image-$index.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
