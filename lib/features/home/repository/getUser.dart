import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_clone/features/home/environment.dart';

class getUserRepo {
  final URL= environment.Url;
  getUserByToken() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final response = await http.get(
      Uri.parse('$URL/user/token'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      },
    );
    print("rrrrrrrrrrrrr");
    print(response.statusCode==200);
    if (response.statusCode == 200) {
      // Decode the JSON response to a List of dynamic objects
      return response.body;
    } else {
      // Handle the error if the response status code is not 200
      throw Exception('Failed to load user. Status code: ${response.statusCode}');
    }
  }
}
