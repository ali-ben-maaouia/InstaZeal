import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:html' as html;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:insta_clone/features/home/bloc/addStorie/story/bloc.dart';
import 'package:insta_clone/features/home/bloc/addStorie/story/event.dart';
import 'package:insta_clone/features/home/bloc/addStorie/story/state.dart';
import 'package:insta_clone/features/home/repository/getPostByUserToken.dart';
import 'package:insta_clone/features/home/screens/home_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:insta_clone/utils/back_ground.dart';

import '../../../repository/Story_repo.dart';
import '../../../repository/getPostByCategorie.dart';

class AddStory extends StatefulWidget {
  @override
  _AddStoryState createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  File? _mediaFile;
  Uint8List _imageBytes = Uint8List(0);
  VideoPlayerController? _videoController;
  TextEditingController _controller = TextEditingController();
  String? _selectedImagePath;
  int? _selectedImageIndex;
  bool isLoading=true;

  // Liste d'exemple d'images
  List<dynamic> exampleImages = [];

  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    getAllStories();
  }
  // Méthode pour sélectionner une image depuis la galerie ou la caméra
  Future<void> _getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _mediaFile = File(image.path);
          _imageBytes = bytes;
        });
      } else {
        setState(() {
          _mediaFile = File(image.path);
        });
      }
    }
  }
  Future<void> getAllStories() async {
    var getallstoriesBytoken = StoryRepo();
    try {
      var fetchedPosts = await getallstoriesBytoken.getAllStoriesByUserToken();
      setState(() { // Update loading state
        exampleImages=fetchedPosts;
      });
    } catch (error) {
      print('Error fetching posts: $error');

    }
  }

  // Méthode pour sélectionner une vidéo depuis la caméra
  Future<void> _getVideoFromCamera() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(File(pickedFile.path))
        ..initialize().then((_) {
          setState(() {});
        });
      setState(() {
        _mediaFile = File(pickedFile.path);
        _selectedImagePath = null;
      });
    } else {
      print('Aucune vidéo sélectionnée.');
    }
  }

  // Méthode pour sélectionner une vidéo depuis les fichiers
  Future<void> _getVideoFromFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mov', 'avi', '3gp'], // Include common formats
      );

      if (result != null) {
        if (kIsWeb) {
          final bytes = result.files.single.bytes;
          if (bytes != null) {
            // Convert bytes to Blob and create a URL
            final blob = html.Blob([bytes]);
            final url = html.Url.createObjectUrlFromBlob(blob);

            // Initialize video player controller
            _videoController?.dispose();
            _videoController = VideoPlayerController.network(url);

            try {
              await _videoController!.initialize();
              setState(() {});
            } catch (error) {
              print('Error initializing video controller: $error');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: Video format not supported.')),
              );
            }

            setState(() {
              _mediaFile = null;
              _selectedImagePath = null;
            });
          } else {
            print('Error: No bytes found for the selected file.');
          }
        } else {
          final filePath = result.files.single.path;
          if (filePath != null) {
            _videoController?.dispose();
            _videoController = VideoPlayerController.file(File(filePath));

            try {
              await _videoController!.initialize();
              setState(() {});
            } catch (error) {
              print('Error initializing video controller: $error');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: Video format not supported.')),
              );
            }

            setState(() {
              _mediaFile = File(filePath);
              _selectedImagePath = null;
            });
          } else {
            print('Error: No path found for the selected file.');
          }
        }
      } else {
        print('Error: No video selected.');
      }
    } catch (e) {
      print('Error picking video: $e');
    }
  }

  Future<String> uploadAndConvertVideo(File videoFile) async {
    // This method should handle uploading the video file to a conversion service
    // and return the URL of the converted video.

    // Example (pseudo-code):
    // 1. Upload video to service
    // 2. Request conversion
    // 3. Wait for conversion to complete
    // 4. Fetch converted video URL

    return 'https://your-service.com/converted-video.mp4'; // Replace with actual URL
  }
  Future<Uint8List> _getImageBytes(String imagePath) async {
    try {
      File imageFile = File(imagePath);
      Uint8List imageBytes = await imageFile.readAsBytes();
      return imageBytes;
    } catch (e) {
      print('Error reading image file: $e');
      return Uint8List(0);
    }
  }
  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackGround(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Nouveau Post'),
          actions: [
            TextButton(
              onPressed: () async {
                Uint8List imageBytes = _imageBytes;

                if (imageBytes == null || imageBytes.isEmpty) {
                  // If _imageBytes is null or empty, try converting _selectedImagePath
                  if (_selectedImagePath != null) {
                    imageBytes = base64Decode(_selectedImagePath!);
                  } else {
                    // Handle case where there is neither image bytes nor path
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No image selected. Please select an image.')),
                    );
                    return; // Exit early if there's no image to upload
                  }
                }

                print("Image path: $_selectedImagePath");

                // Dispatch event with the available image data
                context.read<StoryBloc>().add(addstorybuttonpressed(
                  storyImage: imageBytes,
                  description: _controller.text,
                ));
              },
              child: Text(
                'Ajouter Story',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
        body: BlocListener<StoryBloc, StoryState>(
          listener: (context, state) {
            if (state is AddStorySuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            } else if (state is AddStoryErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Sélectionner Image/Vidéo'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text('Prendre une photo'),
                                        onTap: () {
                                          _getImage(ImageSource.camera);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                      GestureDetector(
                                        child: Text('Sélectionner une image depuis la galerie'),
                                        onTap: () {
                                          _getImage(ImageSource.gallery);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                      GestureDetector(
                                        child: Text('Sélectionner une vidéo depuis les fichiers'),
                                        onTap: () {
                                          _getVideoFromFile();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                      GestureDetector(
                                        child: Text('Enregistrer une vidéo'),
                                        onTap: () {
                                          _getVideoFromCamera();
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
                        child: _mediaFile == null && _selectedImagePath == null
                            ? Icon(Icons.camera_alt)
              : _mediaFile != null
        ? kIsWeb
        ? Image.memory(
          _imageBytes,
          fit: BoxFit.cover,
          width: double.infinity,
        )
            : _videoController != null && _videoController!.value.isInitialized
        ? AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      )
          : Image.file(
      _mediaFile!,
      fit: BoxFit.cover,
      width: double.infinity,
    )
        : _selectedImagePath != null
    ? Image.memory(
                          base64Decode(_selectedImagePath!),
    fit: BoxFit.cover,
    width: double.infinity,
    )
        : Container(),
    ),

    ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: 'Entrez votre Description',
                                hintStyle: TextStyle(color: Color(0XFF895D19)),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
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
                              'Récents',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
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
                                              _imageBytes = Uint8List(0);
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
                                              _imageBytes = Uint8List(0);
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
                                              _imageBytes = Uint8List(0);
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
              if (context.watch<StoryBloc>().state is StoryLoadingState)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
