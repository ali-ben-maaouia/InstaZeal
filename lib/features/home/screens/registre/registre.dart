import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/home/bloc/registre/bloc.dart';
import 'package:insta_clone/features/home/bloc/registre/state.dart';
import 'package:insta_clone/features/home/repository/categories.dart';
import 'package:insta_clone/features/home/screens/login/login.dart';
import 'package:insta_clone/utils/backgroun2.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/registre/event.dart';
import '../../data/hobbies.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController hobbiesController = TextEditingController();

  final Set<String> _selectedHobbies = {};
  late String _selectedHobbiesid = "";
  final PageController _pageController = PageController();
  int _currentStep = 0;
  XFile? _imageFile;
  late Uint8List _imageBytes = Uint8List(0);
  late RegistreBloc registreBloc;
  late CategoryRepo categoryRepo;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        // For Web: Read the image as bytes
        final bytes = await image.readAsBytes();
        setState(() {
          _imageFile = image;
          _imageBytes = bytes;
        });
      } else {
        // For Mobile: Read the image as a file
        setState(() {
          _imageFile = image;
        });
      }
    }
  }

  var _categories = [];

  @override
  void initState() {
    super.initState();

    registreBloc = BlocProvider.of<RegistreBloc>(context);
    categoryRepo = CategoryRepo(); // Initialize
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final categories = await categoryRepo.getCategories();
    setState(() {
      _categories = categories;
    });
    print(_categories);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return  Scaffold(
        body: BlocListener<RegistreBloc, RegistreState>(
          listener: (context, state) {
            if (state is userRegistreSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => loginwidget()),
              );
            } else if (state is userRegistreErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(deviceWidth * 0.05),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/icon/insta2.jpg',
                          height: deviceWidth * .30,
                        ),
                        SizedBox(height: deviceWidth * .05),
                        Container(
                          height: deviceWidth * .60,
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentStep = index;
                              });
                            },
                            children: [
                              _buildStep1(deviceWidth),
                              _buildStep2(deviceWidth),
                              _buildStep3(deviceWidth),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            if (_currentStep > 0)
                              IconButton(
                                icon: Icon(Icons.arrow_back, color: Color(0xff00258B)), // Back icon color
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                },
                              ),
                            Spacer(),
                            Container(
                              color: Color(0xffE8E8E8),
                              child: _buildNavigationButton(
                                deviceWidth: deviceWidth,
                                color: _currentStep == 2 ? Colors.green : Theme.of(context).scaffoldBackgroundColor, // Next or Sign Up button color
                                text: _currentStep == 2 ? 'Sign Up' : 'Next',
                                onPressed: () {
                                  if (_currentStep < 2) {
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn,
                                    );
                                  } else {
                                    print(_imageBytes);
                                    // Handle signup logic
                                    context.read<RegistreBloc>().add(Registrebuttonpressed(
                                      image: _imageBytes,
                                      gender: "",
                                      website: websiteController.text,
                                      fullName: usernameController.text,
                                      bio: "",
                                      phoneNumber: phoneController.text,
                                      categoryIds: _selectedHobbiesid,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ));
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: deviceWidth * .06),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: deviceWidth * .045,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  fontSize: deviceWidth * .045,
                                  color: Color(0xff00258B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: deviceWidth * .06),
                      ],
                    ),
                  ),
                ),
              ),
              if (context.watch<RegistreBloc>().state is RegistreLoadingState)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      );

  }

  Widget _buildNavigationButton({
    required double deviceWidth,
    required Color color,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color, // Button background color
        minimumSize: Size(deviceWidth * .45, deviceWidth * .14), // Button size
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Rounded border
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: deviceWidth * .040, // Text size
          fontWeight: FontWeight.bold, // Text weight
        ),
      ),
    );
  }

  Widget _buildStep1(double deviceWidth) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust to avoid overlap
        children: [
          Container(
          color: Color(0xffE8E8E8),
            child: _buildTextField(
              icon: Icons.person,
              hintText: S.of(context).Username,
              controller: usernameController,
              width: deviceWidth,
            ),
          ),
          SizedBox(height: deviceWidth * .03),
          _buildTextField(
            icon: Icons.email,
            hintText: S.of(context).email,
            controller: emailController,
            width: deviceWidth,
          ),
          SizedBox(height: deviceWidth * .03),
          _buildTextField(
            icon: Icons.call,
            hintText: S.of(context).phone,
            controller: phoneController,
            width: deviceWidth,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerField({required double width}) {
    return GestureDetector(
      onTap: _pickImage, // Calls the method to pick an image when the user clicks the field
      child: Container(
        width: width * 0.90,
        height: width * .14, // Same height as the text fields
        decoration: BoxDecoration(
          color: Color(0xffF4F4F4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Icon(
                Icons.image,
                color: Colors.grey, // You can adjust the icon color here
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  _imageFile == null ? 'Select Image' : 'Selected image: ${_imageFile!.name}',
                  style: TextStyle(
                    fontSize: width * .040,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep2(double deviceWidth) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust to avoid overlap
        children: [
          _buildImagePickerField(
            width: deviceWidth,
          ),
          SizedBox(height: deviceWidth * .03),
          _buildTextField(
            icon: Icons.language,
            hintText: 'Web Site',
            controller: websiteController,
            obscureText: false,
            width: deviceWidth,
          ),
          SizedBox(height: deviceWidth * .03),
          GestureDetector(
            onTap: () => _showHobbyDialog(context),
            child: AbsorbPointer(
              absorbing: true,
              child: _buildTextField(
                icon: Icons.hourglass_bottom,
                hintText: _selectedHobbies.isNotEmpty
                    ? _selectedHobbies.join(', ')
                    : 'Select Hobbies',
                controller: hobbiesController,
                width: deviceWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(double deviceWidth) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust to avoid overlap
        children: [
          _buildTextField(
            icon: Icons.lock,
            hintText: 'Password',
            controller: passwordController,
            obscureText: true,
            width: deviceWidth,
          ),
          SizedBox(height: deviceWidth * .03),
          _buildTextField(
            icon: Icons.lock,
            hintText: 'Confirm Password',
            controller: confirmPasswordController,
            obscureText: true,
            width: deviceWidth,
          ),
        ],
      ),
    );
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
                    print(category['id']);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          title: Text(categoryName),
                          value: _selectedHobbies.contains(categoryName),
                          onChanged: (bool? value) {
                            setDialogState(() {
                              if (value == true) {
                                _selectedHobbies.add(categoryName);
                                // Add category ID to _selectedHobbiesid
                                if (_selectedHobbiesid.isEmpty) {
                                  _selectedHobbiesid = categoryid;
                                } else {
                                  _selectedHobbiesid += ',${categoryid}';
                                }
                              } else {
                                _selectedHobbies.remove(categoryName);
                                // Remove category ID from _selectedHobbiesid
                                List<String> ids = _selectedHobbiesid.split(',');
                                ids.remove(categoryid);
                                _selectedHobbiesid = ids.join(',');
                              }
                            });
                          },
                        )
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
                print("rerererer");
                print(_selectedHobbiesid);
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
}
