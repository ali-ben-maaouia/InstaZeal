import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../repository/Following_repo.dart';
import '../screens/addStorie/page/addStorie.dart';

class Stories extends StatefulWidget {
  const Stories({Key? key}) : super(key: key);

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  List<dynamic> storiesByFollowing = [];
  bool isLoading = true;

  Future<void> getStoriesByFollowing() async {
    var getStories = FollowingRepo();
    try {
      var fetchedStories = await getStories.getStoryByFollwing();
      setState(() {
        storiesByFollowing = fetchedStories as List;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching posts: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getStoriesByFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        StoryBackground(
          bottomText: "Your Story",
          avatarAssetName: 'assets/avatars/your_avatar.jpg',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddStory()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.deepOrange.shade400,
              image: const DecorationImage(
                image: AssetImage('assets/0_me.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.add_box_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        ...storiesByFollowing.asMap().entries.map((entry) {
          int index = entry.key;
          var story = entry.value;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenStoryPage(
                    stories: storiesByFollowing,
                    initialPageIndex: index,
                  ),
                ),
              );
            },
            child: StoryBackground(
              bottomText: story['userInsta']['fullName'],
              avatarAssetName: 'story.avatarAssetName',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenStoryPage(
                      stories: storiesByFollowing,
                      initialPageIndex: index,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Builder(
                  builder: (context) {
                    String image64 = story['file']['data'];
                    Uint8List imageData = base64Decode(image64);
                    return Image.memory(
                      imageData,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class FullScreenStoryPage extends StatefulWidget {
  final List stories;
  final int initialPageIndex;

  FullScreenStoryPage({required this.stories, required this.initialPageIndex});

  @override
  _FullScreenStoryPageState createState() => _FullScreenStoryPageState();
}

class _FullScreenStoryPageState extends State<FullScreenStoryPage> {
  TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    var story = widget.stories[widget.initialPageIndex];
    String image64 = story['file']['data'];
    Uint8List imageData = base64Decode(image64);

    String userimage64 = story['userInsta']['file']['data']; // Assuming avatar is a base64 string
    Uint8List userimageData = base64Decode(userimage64);
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (widget.initialPageIndex < widget.stories.length - 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenStoryPage(
                  stories: widget.stories,
                  initialPageIndex: widget.initialPageIndex + 1,
                ),
              ),
            );
          } else {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.memory(
                imageData,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: MemoryImage(
                      userimageData,
                    ),
                    radius: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    story['userInsta']['fullName'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Write a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              String comment = _commentController.text.trim();
                              if (comment.isNotEmpty) {
                                print('Comment sent: $comment');
                                _commentController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: _isLiked
                          ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 30,
                      )
                          : Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLiked = !_isLiked;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

class StoryBackground extends StatelessWidget {
  const StoryBackground({
    Key? key,
    required this.child,
    required this.bottomText,
    required this.avatarAssetName,
    required this.onTap,
  }) : super(key: key);

  final Widget child;
  final String bottomText;
  final String avatarAssetName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.all(6),
              width: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.deepOrange.shade300,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: child,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              bottomText,
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
