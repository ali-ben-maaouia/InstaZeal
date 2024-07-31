import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/utils/back_ground.dart';
import 'package:video_player/video_player.dart';

import '../repository/getPostByCategorie.dart';

class SearchPost extends StatefulWidget {
  @override
  _SearchPostState createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost> {
  bool isLoading = true;
  List<dynamic> posts = [];
  List<dynamic> filteredPosts = [];

  @override
  void initState() {
    super.initState();
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

  void filterPosts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredPosts = posts;
      });
    } else {
      setState(() {
        filteredPosts = posts.where((post) {
          final description = post['description'].toLowerCase();
          return description.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackGround(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher des vidéos locales',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
            onChanged: (query) {
              filterPosts(query); // Filter posts based on the query
            },
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
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
                      builder: (context) => VideoDetailPage(filteredPosts[index]),
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
                            ? VideoPlayerWidget(videoPath: filteredPosts[index]['videoPath'])
                            : Image.memory(
                          imageData,
                          fit: BoxFit.cover,
                        ),
                        Center(
                          child: Icon(Icons.play_arrow, size: 50, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class VideoDetailPage extends StatefulWidget {
  final dynamic postDetail;

  VideoDetailPage(this.postDetail);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  bool cliqued = false;

  @override
  Widget build(BuildContext context) {
    String image64 = widget.postDetail['file']['data'];
    Uint8List imageData = base64Decode(image64);
    String userImage = widget.postDetail['userInsta']['file']['data'];
    Uint8List userImageCode = base64Decode(userImage);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 3 / 4.0,
                  child: (widget.postDetail['mediaType'] == "video")
                      ? VideoPlayerWidget(videoPath: widget.postDetail['videoPath'])
                      : Image.memory(
                    imageData,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: cliqued
                          ? Image.asset("assets/icon/heartIcon2.png", width: 24)
                          : Icon(CupertinoIcons.heart, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          cliqued = !cliqued;
                        });
                      },
                    ),
                    Text("22", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 5),
                    IconButton(
                      icon: Icon(CupertinoIcons.chat_bubble_2, size: 30, color: Colors.white),
                      onPressed: () {},
                    ),
                    Text("14", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 5),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share, size: 28, color: Colors.white),
                    ),
                    Text("12", style: TextStyle(color: Colors.white)),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.bookmark_fill, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.black,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(backgroundImage: MemoryImage(userImageCode)),
                    SizedBox(width: 8.0),
                    Text(widget.postDetail['userInsta']['fullName'], style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Column(
                        children: <Widget>[
                          Text(widget.postDetail['description'], style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                height: 5,
              ),
              Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Column(
                        children: <Widget>[
                          Text(((widget.postDetail['createdAt']).toString()).substring(0,10), style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  VideoPlayerWidget({required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.pause();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
