import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_clone/features/home/environment.dart';

class EditProfileRepo {
  final URL= environment.Url;
  Future<http.Response> EditProfile(String fullName, String? phone, String? bio) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final url = Uri.parse('$URL/user/update');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fullName': fullName,
        'phoneNumber': phone,
        'bio': bio,
      }),
    );

    return response;
  }
}
