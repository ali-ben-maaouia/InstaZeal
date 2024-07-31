import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:insta_clone/features/home/screens/modifierProfile.dart';
import 'package:insta_clone/features/home/screens/profileSetting.dart';
import 'package:insta_clone/utils/back_ground.dart';
import 'package:insta_clone/utils/backgroun2.dart';

import '../../repository/getPostByCategorie.dart';
import '../../repository/getUser.dart';
import '../searchPost.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UserProfilePage> {
  int _publications = 10;
  int _followers = 2;
  int _following = 20;
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];

  String userName = '';
  Uint8List? profileImageBytes; // Bytes of the profile image
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUsers();
    getPostByCategories();
  }

  Future<void> getPostByCategories() async {
    var getpostsByCategories = GetPostByCategorieRepo();
    try {
      var fetchedPosts = await getpostsByCategories.getPostByCategorie();
      setState(() {
        posts = fetchedPosts;
        filteredPosts = posts; // Initialize filteredPosts with all posts
        isLoading = false;
      });
      print("Posts fetched successfully: ${posts.length} items");
    } catch (error) {
      print('Error fetching posts: $error');
      setState(() {
        isLoading = false;
      });
    }
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
        userName = userjson['fullName'] ?? '';
      });
    } catch (e) {
      print('Failed to get user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackGround2(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                  SizedBox(height: 14.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Action pour partager le profil
                            },
                            child: Text('Partager le profil'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Action pour partager le profil
                            },
                            child: Text('Follow'),
                          ),
                        ],
                      )
                    ],
                  )

                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  childAspectRatio: 3 / 4.0,
                ),
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  String image64 = filteredPosts[index]['file']['data'];
                  Uint8List imageData = base64Decode(image64);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VideoDetailPage(filteredPosts[index]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.black,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Stack(
                          children: <Widget>[
                            (filteredPosts[index]['mediaType'] == "video")
                                ? VideoPlayerWidget(
                                videoPath:
                                filteredPosts[index]['videoPath'])
                                : Image.memory(
                              imageData,
                              fit: BoxFit.cover,
                            ),
                            Center(
                              child: Icon(Icons.play_arrow,
                                  size: 50, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
