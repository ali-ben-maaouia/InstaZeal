import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reels'),
      ),
      body: ReelList(),
    );
  }
}

class ReelList extends StatefulWidget {
  @override
  _ReelListState createState() => _ReelListState();
}

class _ReelListState extends State<ReelList> {
  final List<String> videoAssetPaths = [
    'assets/video/Traumatismesmusculaires.mp4',
    'assets/video/Traumatismesmusculaires.mp4',
    'assets/video/Traumatismesmusculaires.mp4',
    // Add more video paths here
  ];

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: videoAssetPaths.length,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        return ReelWidget(
          videoAssetPath: videoAssetPaths[index],
          isVisible: _currentPage == index,
        );
      },
    );
  }
}

class ReelWidget extends StatefulWidget {
  final String videoAssetPath;
  final bool isVisible;

  ReelWidget({required this.videoAssetPath, required this.isVisible});

  @override
  _ReelWidgetState createState() => _ReelWidgetState();
}

class _ReelWidgetState extends State<ReelWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAssetPath)
      ..initialize().then((_) {
        setState(() {});
        if (widget.isVisible) {
          _controller.play();
          _controller.setLooping(true);
        }
      });
  }

  @override
  void didUpdateWidget(ReelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible && widget.isVisible) {
      _controller.play();
    } else if (!widget.isVisible) {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: VideoPlayer(_controller),
          ),
          Positioned(
            bottom: 28.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/0_me.jpeg'),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    'ali ben maaouia',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 16.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(CupertinoIcons.chat_bubble_2, size: 30, color: Colors.white),
                      onPressed: () {},
                    ),
                    Text(
                      '1',
                      style: TextStyle(color: Colors.white, fontSize: 27),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(CupertinoIcons.heart, size: 30, color: Colors.white),
                      onPressed: () {},
                    ),
                    Text(
                      '2',
                      style: TextStyle(color: Colors.white, fontSize: 27),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share, size: 30, color: Colors.white),
                      onPressed: () {},
                    ),
                    Text(
                      '3',
                      style: TextStyle(color: Colors.white, fontSize: 27),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 25,
            child: LinearProgressIndicator(
              value: _controller.value.position.inMilliseconds /
                  _controller.value.duration.inMilliseconds,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    )
        : Center(child: CircularProgressIndicator());
  }
}
