import 'package:flutter/material.dart';
import 'package:insta_clone/features/home/repository/getPostByUserToken.dart';
import '../../../utils/back_ground.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/stories_bar.dart';
import 'listAmie.dart'; // Ensure this import is correct

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDragging = false;
  List<dynamic> posts = []; // Initialize posts with an empty list
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    getPostByToken(); // Call the async method but do not await
  }

  void navigateToAnotherPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FriendListPage()),
    );
  }

  Future<void> getPostByToken() async {
    var getposts = GetPostRepo();
    try {
      var fetchedPosts = await getposts.getPostByUserToken();
      setState(() {
        posts = fetchedPosts as List;
        isLoading = false; // Update loading state
      });
    } catch (error) {
      print('Error fetching posts: $error');
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackGround(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          scrolledUnderElevation: 0,
        ),
        body: GestureDetector(
          onHorizontalDragStart: (_) {
            _isDragging = true;
          },
          onHorizontalDragUpdate: (details) {
            if (_isDragging) {
              if (details.primaryDelta! < -10) {
                navigateToAnotherPage();
                _isDragging = false;
              }
            }
          },
          onHorizontalDragEnd: (_) {
            _isDragging = false;
          },
          child: isLoading
              ? const Center(child: CircularProgressIndicator()) // Show loading indicator
              : CustomScrollView(
            slivers: [
              const CustomAppBar(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const Text("Stories"),
                      const SizedBox(
                        height: 110,
                        child: Stories(),
                      ),
                      const SizedBox(height: 20),
                      const Text("Trending Posts"),
                      if (posts.isNotEmpty)
                        ...posts.map(
                              (e) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                            child: PostCard(
                              m: e,
                            ),
                          ),
                        ).toList(),
                      if (posts.isEmpty)
                        const Center(
                          child: Text("No posts available"),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
