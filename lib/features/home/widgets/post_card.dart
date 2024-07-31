import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../utils/theme/theme_state.dart';
import '../data/users.dart';




class PostCard extends StatefulWidget {
  const PostCard({
    Key? key,
    required this.m,
  }) : super(key: key);

  final m;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  ValueNotifier<bool> expandListener = ValueNotifier<bool>(false);
  OverlayEntry? _overlayEntry;
  List<UserModel> selectedFriends = [];

  @override
  Widget build(BuildContext context) {
    String image64 = widget.m['file']['data'];
    Uint8List imageData = base64Decode(image64);
    return GestureDetector(
      onTap: () {
        _showFullScreenImage(context);
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                width: double.infinity,
                child: Image.memory(
                  imageData,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  HeartButton(), // Use the HeartButton widget here
                  GestureDetector(
                    onTap: () {
                      _navigateToFriendProfile(context, widget.m); // Navigation vers le profil de l'ami
                    },
                    child: Icon(
                      CupertinoIcons.chat_bubble_2,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      String imagePath = await _saveImageToTemp();
                      if (imagePath != null) {
                        shareImage(imagePath);
                      } else {
                        print('Failed to share image');
                      }
                    },
                    icon: Icon(
                      Icons.share,
                      size: 30,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      //saveImageFromAssets();
                    },
                    icon: Icon(CupertinoIcons.bookmark_fill),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: expandListener,
              builder: (context, value, _) {
                return GestureDetector(
                  onTap: widget.m['description'].length > 50
                      ? () {
                    expandListener.value = !value;
                    debugPrint("Hello There");
                    debugPrint("${widget.m.caption.length > 50}  && $value");
                  }
                      : null,
                  child: Text.rich(
                    TextSpan(
                      text: widget.m['userInsta']['fullName'],
                      children: [
                        TextSpan(
                          text: widget.m['description'].length > 50 && !value
                              ? " ${widget.m['description'].substring(0, 50)}"
                              : " ${widget.m['description']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        widget.m['description'].length > 50
                            ? TextSpan(
                          text: value ? "" : " ...more",
                          style: const TextStyle(
                            fontWeight: FontWeight.w200,
                          ),
                        )
                            : TextSpan(),
                      ],
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    String image64 = widget.m['file']['data'];
    Uint8List imageData = base64Decode(image64);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        bottom: 0,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
            _overlayEntry?.remove();
            _overlayEntry = null;
          },
          child: Material(
            color: Colors.black87,
            child: Center(
              child:Image.memory(
                imageData,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _navigateToFriendProfile(BuildContext context,dynamic user) {
    String image64 = user['file']['data'];
    Uint8List imageData = base64Decode(image64);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              user['userInsta']['fullName'],
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
                  // Action pour l'icône de la caméra
                },
              ),
              IconButton(
                icon: Icon(Icons.phone),
                onPressed: () {
                  // Action pour l'icône d'appel vocal
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Action pour l'icône de menu
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
                                      user['userInsta']['fullName'],
                                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                ListTile(
                                  trailing: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      '${user['description']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: Text(
                                    '${widget.m['description']}',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
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
                            // Action pour envoyer le message
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
      ),
    );
  }

  Future<String> _saveImageToTemp() async {
    // Replace with your asset image path
    String assetImagePath = widget.m.user.assetName;

    // Load the image from assets
    ByteData byteData = await rootBundle.load(assetImagePath);
    List<int> bytes = byteData.buffer.asUint8List();

    // Create temp directory
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Write to temp file
    File tempFile = File('$tempPath/example_image.png');
    await tempFile.writeAsBytes(bytes);

    // Return temp file path
    return tempFile.path;
  }

  void shareImage(String imagePath) {
    Share.shareFiles([imagePath], text: 'Check out this image!');
  }

  @override
  void dispose() {
    expandListener.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }
}


class HeartButton extends StatefulWidget {
  const HeartButton({Key? key}) : super(key: key);

  @override
  _HeartButtonState createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {
  bool hearted = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          hearted = !hearted;
        });
      },
      icon: hearted
          ? Icon(
        CupertinoIcons.heart_fill,
        color: Colors.orange.shade700,
        size: 30,
      )
          : Icon(
        CupertinoIcons.heart,
        size: 30,
      ),
    );
  }
}
