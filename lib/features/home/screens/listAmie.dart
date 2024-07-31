import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/home/bloc/following/bloc.dart';
import 'package:insta_clone/features/home/bloc/following/event.dart';
import 'package:insta_clone/features/home/bloc/following/state.dart';
import 'package:insta_clone/features/home/bloc/unfollow/bloc.dart';
import 'package:insta_clone/features/home/bloc/unfollow/event.dart'; // Assurez-vous d'importer l'événement UnFollowButtonPressed
import 'package:insta_clone/features/home/bloc/unfollow/state.dart';
import 'package:insta_clone/features/home/repository/Following_repo.dart';
import 'package:insta_clone/features/home/repository/UnFollowin_repo.dart';
import 'package:insta_clone/features/home/screens/profile.dart';
import 'package:insta_clone/features/home/screens/profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // new

import '../../../utils/theme/theme_state.dart';
import '../repository/getAllUser.dart';
import '../repository/getUser.dart';
import 'home_screen.dart';

class Friend {
  final int id;
  final String name;
  final String imageUrl;
  final String message;

  Friend( {required this.id,required this.name, required this.imageUrl, required this.message});
}

class FriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  List<dynamic> followers = [];
  List<bool> followingStates =[];
  int? indexToUpdate;
  bool isLoading = true;
  var userId;
  @override
  void initState() {
    super.initState();
    getFollowers(); // Call the async method but do not
    getUsers();
    getUser();
  }
  String addLineBreaks(String text, int lineLength) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i += lineLength) {
      buffer.write(text.substring(i, i + lineLength > text.length ? text.length : i + lineLength));
      if (i + lineLength < text.length) {
        buffer.write('\n');
      }
    }
    return buffer.toString();
  }

  Future<void> getFollowers() async {
    var getusers = getAllUserRepo();
    try {
      var fetchedFollowers = await getusers.getFoloowers();
      setState(() {
        followers = fetchedFollowers as List;
        isLoading = false; // Update loading state
      });
    } catch (error) {
      print('Error fetching posts: $error');
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }
  Future<void> getUser() async {
    var getuser = getUserRepo();
    try {
      var fetcheduser = await getuser.getUserByToken();
      setState(() {
        userId = ( jsonDecode(fetcheduser)['id']);
        print("$userId gjbjjjjjjjjjjjjjjjjjj");
      });
    } catch (error) {
      print('Error fetching user: $error');
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isDragging = false;
  List<dynamic> users=[];

  @override
  void dispose() {
    // Nettoyer le contrôleur lorsque le widget est supprimé
    _controller.dispose();
    super.dispose();
  }
  Future<DocumentReference> addMessageToGuestBook(String message,int reciverId) {


    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
          "reciverId":reciverId,
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': "alii",
      'userId': userId,
    });
    _scrollToBottom();
  }
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  Future<void> getUsers() async {
    final getAllUserRepo getalluserrepo = getAllUserRepo();
    try {
      var user = await getalluserrepo.getUserByToken();
      setState(() {
        users = user as List;
        followingStates = List.generate(users.length, (index) => false);
        isLoading=false;
      });
    } catch (e) {
      print('Failed to get user: $e');
    }
  }


  void navigateToHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FollowingBloc(followingRepo: FollowingRepo())),
        BlocProvider(create: (_) => UnFollowingBloc(unFollowingRepo: UnFollowingRepo())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friends List'),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<FollowingBloc, FollowingState>(
              listener: (context, state) {
                if (state is AddFollowingSuccessState) {
                  setState(() {
                    if (indexToUpdate != null) {
                      followingStates[indexToUpdate!] = true;
                    }
                  });
                } else if (state is AddFollowingErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            ),
            BlocListener<UnFollowingBloc, UnFollowingState>(
              listener: (context, state) {
                if (state is UnAddFollowingSuccessState) {
                  setState(() {
                    if (indexToUpdate != null) {
                      followingStates[indexToUpdate!] = false;
                    }
                  });
                } else if (state is UnAddFollowingErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            ),
          ],
          child: GestureDetector(
            onHorizontalDragStart: (_) {
              isDragging = true;
            },
            onHorizontalDragUpdate: (details) {
              if (isDragging) {
                if (details.primaryDelta! > 10) {
                  navigateToHomeScreen(context);
                  isDragging = false;
                }
              }
            },
            onHorizontalDragEnd: (_) {
              isDragging = false;
            },
            child: Stack(
              children: [
                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          ...Provider.of<ThemeProvider>(context).themeMode
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
                (isLoading==false)?Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView.builder(

                        itemCount: followers.length,
                        itemBuilder: (context, index) {
                          String image64 = followers[index]['file']['data'];
                          Uint8List imageData = base64Decode(image64);
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: MemoryImage(imageData),
                            ),
                            title: Text(followers[index]['fullName']),
                            //subtitle: Text(friends[index].message),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                // Action when user taps on more button
                              },
                            ),
                            onTap: () {
                              _navigateToFriendProfile(context, followers[index]);
                            },
                          );
                        },
                      ),
                    ),
                    Divider(height: 0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final actualIndex = index + 1;  // Adjust to start from 1
                          String? image64 = users[index]['file']?['data'];
                          Uint8List? imageData =image64!=null? base64Decode(image64!):null;
                          return ListTile(
                            leading: (imageData == null)?
                            // Handle the case where imageData is null
                            CircleAvatar(
                              backgroundImage: null,
                            )// or some other placeholder widget
                           :
                           CircleAvatar(
                          backgroundImage: MemoryImage(imageData),
                          ),
                            title: Text(users[index]["fullName"]),
                            subtitle: Text(users[index]['website']),
                            trailing: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  indexToUpdate = index;
                                });
                                if (followingStates[index]&& users[index]["followed"]==true) {
                                  context.read<UnFollowingBloc>().add(
                                    addUnFollowingbuttonpressed(id: actualIndex),
                                  );
                                } else {
                                  context.read<FollowingBloc>().add(
                                    addFollowingbuttonpressed(id: actualIndex),
                                  );
                                }
                              },
                              child:users[index]["followed"]==true
                                  ? Text('UnFollow', style: TextStyle(color: Colors.blue))
                                  : Text('Follow'),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UserProfilePage()),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ):const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _navigateToFriendProfile(BuildContext context, var friend) {
    String image64 = friend['file']['data'];
    Uint8List imageData = base64Decode(image64);
    Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          friend['fullName'],
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Action for the camera icon
            },
          ),
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {
              // Action for the phone icon
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Action for the menu icon
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    ...Provider.of<ThemeProvider>(context).themeMode
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: MemoryImage(imageData),
                                  radius: 50,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  friend['fullName'],
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('guestbook')
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          var documents = snapshot.data!.docs;
                          return Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,  // Makes ListView take only as much vertical space as needed
                                    physics: NeverScrollableScrollPhysics(), // Disable scrolling on ListView
                                    itemCount: documents.length,
                                    itemBuilder: (context, index) {
                                      var data = documents[index].data() as Map<String, dynamic>;
                                      String displayedText = data['text'] ?? '';

                                      // Determine message card based on the sender
                                      bool isFromCurrentUser = data['reciverId'] == friend['id'] && data['userId'] == userId;
                                      bool isToCurrentUser = data['reciverId'] == userId && friend['id'] == data['userId'];

                                      if (isFromCurrentUser) {
                                        // Message from the friend to the current user
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding for spacing
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Card(
                                              elevation: 2.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              color: Colors.blue,
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(context).size.width * 0.7, // Adjust width to fit within screen
                                                ),
                                                child: Text(
                                                  displayedText,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  softWrap: true,
                                                  overflow: TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (isToCurrentUser) {
                                        // Message from the current user to the friend
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding for spacing
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Card(
                                              elevation: 2.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              color: Color(0XFFf8f6f3),
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                constraints: BoxConstraints(
                                                  maxWidth: MediaQuery.of(context).size.width * 0.7, // Adjust width to fit within screen
                                                ),
                                                child: Text(
                                                  displayedText,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                  softWrap: true,
                                                  overflow: TextOverflow.visible,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        // Hide the tile if the message doesn't match the criteria
                                        return SizedBox.shrink();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    hintText: 'Entrez votre message...',
                    suffixIcon: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.send),
                      onPressed: () {
                        addMessageToGuestBook(_controller.text, friend['id']);
                        _controller.clear();
                      },
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    ));
  }
}
