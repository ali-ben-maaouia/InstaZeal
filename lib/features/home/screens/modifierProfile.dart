import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/home/bloc/edit_profile/bloc.dart';
import 'package:insta_clone/features/home/bloc/edit_profile/state.dart';
import 'package:insta_clone/features/home/bloc/getUser/get_user/bloc.dart';
import 'package:insta_clone/features/home/bloc/getUser/get_user/state.dart';
import 'package:insta_clone/features/home/repository/getUser.dart';
import 'package:insta_clone/utils/back_ground.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../bloc/edit_profile/event.dart';
import 'home_screen.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image; // For mobile image files
  Uint8List? _webImage; // For web image files
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  Uint8List? profileImageBytes; // Bytes of the profile image

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    getUsers();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void getUsers() async {
    final getUserRepo getuserrepo = getUserRepo();
    try {
      var user = await getuserrepo.getUserByToken();
      setState(() {
        var userjson = jsonDecode(user);
        _usernameController.text = userjson['fullName'] ?? '';
        _phoneController.text = userjson['phoneNumber'] ?? '';
        _bioController.text = userjson['bio'] ?? '';
        String? base64String = userjson['file']['data']; // Assuming this is a base64 encoded string
        if (base64String != null) {
          try {
            profileImageBytes = base64Decode(base64String); // Convert base64 string to Uint8List
          } catch (e) {
            print('Failed to decode image: $e');
            profileImageBytes = null;
          }
        }
      });
    } catch (e) {
      print('Failed to get user: $e');
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _getImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        try {
          final bytes = await image.readAsBytes();
          setState(() {
            _webImage = bytes;
            _image = null;
          });
          print('Image selected for web');
        } catch (e) {
          print('Failed to read image bytes for web: $e');
        }
      } else {
        try {
          setState(() {
            _image = File(image.path);
            _webImage = null;
          });
          print('Image selected for mobile');
        } catch (e) {
          print('Failed to read image file for mobile: $e');
        }
      }
    } else {
      print('No image selected');
    }
  }

  Future<void> _saveChanges() async {
    // Prepare the base64 string of the new profile image if available
    String? newProfileImageBase64;
    if (_webImage != null) {
      newProfileImageBase64 = base64Encode(_webImage!);
    } else if (_image != null) {
      try {
        newProfileImageBase64 = base64Encode(await _image!.readAsBytes());
      } catch (e) {
        print('Failed to encode image: $e');
        newProfileImageBase64 = null;
      }
    }

    final updatedProfileData = {
      'fullName': _usernameController.text,
      'phoneNumber': _phoneController.text,
      'bio': _bioController.text,
      'profileImage': newProfileImageBase64,
      // Convert image to base64 if needed
    };

    // Add your API call or other logic to save the profile data
    // Example:
    // await updateProfile(updatedProfileData);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BackGround(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Modifier le profil'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _saveChanges,
            ),
          ],
        ),
        body: BlocListener<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            } else if (state is EditProfileErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _getImageFromGallery,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: _webImage != null
                                ? MemoryImage(_webImage!)
                                : _image != null
                                ? FileImage(_image!)
                                : (profileImageBytes != null)
                                ? MemoryImage(profileImageBytes!)
                                : AssetImage('assets/images/placeholder.png') as ImageProvider,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextButton(
                          onPressed: _getImageFromGallery,
                          child: Text(
                            'Changer la photo de profil',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nom d\'utilisateur',
                      hintText: 'Entrez votre nouveau nom d\'utilisateur',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Numéro de téléphone',
                      hintText: 'Entrez votre nouveau numéro de téléphone',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      hintText: 'Entrez votre nouvelle bio',
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EditProfileBloc>().add(loginbuttonpressed(
                          fullName: _usernameController.text,
                          phone: _phoneController.text,
                          bio: _bioController.text));
                    },
                    child: Text('Enregistrer les modifications'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
