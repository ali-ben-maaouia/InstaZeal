import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:insta_clone/features/home/bloc/add_post/bloc.dart';
import 'package:insta_clone/features/home/bloc/add_post/event.dart';
import 'package:insta_clone/features/home/bloc/add_post/state.dart';
import 'package:insta_clone/features/home/repository/categories.dart';
import 'package:insta_clone/features/home/screens/home_screen.dart';
import 'dart:typed_data'; // For using Uint8List
import 'package:video_player/video_player.dart';
import 'package:insta_clone/utils/back_ground.dart';

import '../../repository/getPostByUserToken.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  Uint8List _mediaBytes = Uint8List(0); // Byte data for storing selected media (either image or video)
  File? _mediaFile; // File for storing selected media (only for mobile)
  VideoPlayerController? _videoController;
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  final TextEditingController hobbiesController = TextEditingController();

  String? _selectedImagePath; // Variable to store the selected image path
  int? _selectedImageIndex; // Variable to store the selected image index
  late CategoryRepo categoryRepo;
  // List of example images
  final Set<String> _selectedHobbies = {};
  late String _selectedHobbiesid = "";

  List<dynamic> exampleImages = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    getAllPostByToken();
  }
  Future<void> getAllPostByToken() async {
    var getallpostsBytoken = GetPostRepo();
    try {
      var fetchedPosts = await getallpostsBytoken.getAllPostByUserToken();
      setState(() { // Update loading state
        exampleImages=fetchedPosts;
      });
    } catch (error) {
      print('Error fetching posts: $error');

    }
  }

  void _showHobbyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Hobbies'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _categories.map((category) {
                    String categoryName = category['name'] as String;
                    String categoryid = (category['id']).toString();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RadioListTile<String>(
                          title: Text(categoryName),
                          value: categoryName,
                          groupValue: _selectedHobbies.isNotEmpty ? _selectedHobbies.first : null,
                          onChanged: (String? value) {
                            setDialogState(() {
                              _selectedHobbies.clear();
                              if (value != null) {
                                _selectedHobbies.add(value);
                                _selectedHobbiesid = categoryid;
                              } else {
                                _selectedHobbiesid = "";
                              }
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  var _categories = [];
  Future<void> _fetchCategories() async {
    print("categories");
    categoryRepo = new CategoryRepo();
    final categories = await categoryRepo.getCategories();
    setState(() {
      _categories = categories;
    });
    print("jjjjjjjjjjjjj");
    print(_categories);
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (kIsWeb) {
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _mediaBytes = bytes;
          _videoController?.dispose(); // Dispose any existing video controller
          _videoController = null;
          _selectedImagePath = null; // Clear selected image path
        });
      } else {
        print('No media selected.');
      }
    } else {
      setState(() {
        if (pickedFile != null) {
          _mediaFile = File(pickedFile.path);
          _videoController?.dispose(); // Dispose any existing video controller
          _videoController = null;
          _selectedImagePath = null; // Clear selected image path
        } else {
          print('No media selected.');
        }
      });
    }
  }

  Future<void> _getVideoFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _mediaFile = null; // Clear any existing image file
        _videoController?.dispose(); // Dispose any existing video controller

        // Initialize video controller with the picked file
        _videoController = kIsWeb
            ? VideoPlayerController.network(pickedFile.path)
            : VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized
            setState(() {});
          });

        _selectedImagePath = null; // Clear selected image path
      } else {
        print('No video selected.');
      }
    });
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
    required double width,
    bool enabled = true, // Added parameter to disable the text field
  }) {
    return Container(
      width: width * .90,
      height: width * .14,
      decoration: BoxDecoration(
        color: Color(0xffF4F4F4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                style: TextStyle(fontSize: width * .040),
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                ),
                enabled: enabled, // Apply the property to disable the text field
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getVideoFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mov', 'avi', '3GP'],
    );

    setState(() {
      if (result != null) {
        if (kIsWeb) {
          _mediaBytes = result.files.single.bytes!;
          _videoController?.dispose(); // Dispose any existing video controller

          // Initialize video controller with the picked file
          _videoController = VideoPlayerController.network(
            'data:video/mp4;base64,${base64Encode(_mediaBytes)}',
          )..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized
            setState(() {});
          });

          _selectedImagePath = null; // Clear selected image path
        } else {
          _mediaFile = File(result.files.single.path!);
          _videoController?.dispose(); // Dispose any existing video controller

          // Initialize video controller with the picked file
          _videoController = VideoPlayerController.file(_mediaFile!)
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized
              setState(() {});
            });

          _selectedImagePath = null; // Clear selected image path
        }
      } else {
        print('No video selected.');
      }
    });
  }

  @override
  void dispose() {
    // Dispose the video controller when the widget is disposed
    _videoController?.dispose();
    super.dispose();
  }

  Widget _buildTextField3({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    required double width,
  }) {
    return Container(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          filled: true,
          fillColor: Color(0XFFEDE8DF), // Change this to your desired color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField2({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    required double width,
  }) {
    return Container(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: _selectedHobbies.isNotEmpty ? _selectedHobbies.first : 'Select Hobbies',
          filled: true,
          fillColor: Color(0XFFEDE8DF), // Change this to your desired color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackGround(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('New Post'),
          actions: [
            TextButton(
              onPressed: () {
                context.read<AddPostBloc>().add(AddPostbuttonpressed(
                    description: _controller.text,
                    categoryId: _selectedHobbiesid,
                    PostImage: _selectedImagePath==null?_mediaBytes:base64Decode(_selectedImagePath!)
                ));
                print("hobbidd");
                print(_selectedHobbiesid);
              },
              child: Text(
                'Add Post',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
        body: BlocListener<AddPostBloc, AddPostState>(
          listener: (context, state) {
            if (state is AddPostSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else if (state is AddPostErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Select Image/Video'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  GestureDetector(
                                    child: Text('Take a picture'),
                                    onTap: () {
                                      _getImage(ImageSource.camera);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                  ),
                                  GestureDetector(
                                    child: Text('Select an image from gallery'),
                                    onTap: () {
                                      _getImage(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                  ),
                                  GestureDetector(
                                    child: Text('Select a video from files'),
                                    onTap: () {
                                      _getVideoFromFile();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(
                        child: _mediaFile == null && _selectedImagePath == null && _mediaBytes.isEmpty
                            ? Icon(Icons.camera_alt)
                            : kIsWeb
                            ? _mediaBytes.isNotEmpty
                            ? Image.memory(
                          _mediaBytes,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                            : _selectedImagePath != null
                            ? Image.memory(
                          base64Decode(_selectedImagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                            : Container()
                            : _mediaFile != null
                            ? Image.file(
                          _mediaFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                            : _selectedImagePath != null
                            ? Image.asset(
                          _selectedImagePath!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                            : Container(),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 150, // Ensure the width is consistent
                  child: SizedBox(
                    width: 150, // Ensure the width is consistent
                    height: 70, // Fixed height
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildTextField3(
                        icon: Icons.description,
                        hintText: "Description",
                        controller: _controller,
                        width: 150, // Ensure the width is consistent with SizedBox
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 150, // Ensure the width is consistent
                  child: GestureDetector(
                    onTap: () => _showHobbyDialog(context),
                    child: AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                        width: 150, // Ensure the width is consistent
                        height: 70, // Fixed height
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildTextField2(
                            icon: Icons.hourglass_bottom,
                            hintText: _selectedHobbies.isNotEmpty
                                ? _selectedHobbies.join(', ')
                                : 'Select Hobbies',
                            controller: hobbiesController,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent', // Section title
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8), // Space between title and ListView.builder
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: (exampleImages.length / 3).ceil(), // Adjusted for three images per row
                        itemBuilder: (context, index) {
                          int startIndex = index * 3; // Adjusted index for three images per row

                          return Row(
                            children: [
                              if (startIndex < exampleImages.length)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImagePath = exampleImages[startIndex]['file']['data'];
                                        _selectedImageIndex = startIndex;
                                        _mediaFile = null;
                                        _mediaBytes = Uint8List(0);
                                        _videoController?.dispose();
                                        _videoController = null;
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Image.memory(
                                          base64Decode(exampleImages[startIndex]['file']['data']),
                                          height: 110,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        if (_selectedImageIndex == startIndex)
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Icon(Icons.check_circle, color: Colors.green),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (startIndex + 1 < exampleImages.length)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImagePath = exampleImages[startIndex + 1]['file']['data'];
                                        _selectedImageIndex = startIndex + 1;
                                        _mediaFile = null;
                                        _mediaBytes = Uint8List(0);
                                        _videoController?.dispose();
                                        _videoController = null;
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Image.memory(
                                          base64Decode(exampleImages[startIndex + 1]['file']['data']),
                                          height: 110,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        if (_selectedImageIndex == startIndex + 1)
                                          Positioned(
                                            child: Icon(Icons.check_circle, color: Colors.green),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (startIndex + 2 < exampleImages.length)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImagePath = exampleImages[startIndex + 2]['file']['data'];
                                        _selectedImageIndex = startIndex + 2;
                                        _mediaFile = null;
                                        _mediaBytes = Uint8List(0);
                                        _videoController?.dispose();
                                        _videoController = null;
                                      });
                                    },
                                    child: Stack(
                                      children: [
                                        Image.memory(
                                          base64Decode(exampleImages[startIndex + 2]['file']['data']),
                                          height: 110,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        if (_selectedImageIndex == startIndex + 2)
                                          Positioned(
                                            child: Icon(Icons.check_circle, color: Colors.green),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
