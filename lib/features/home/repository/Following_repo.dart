import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:insta_clone/features/home/environment.dart';

import 'package:shared_preferences/shared_preferences.dart';
class FollowingRepo{
  final URL= environment.Url;
  AddFollowing(int id)async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }
    try {
      var res = await http.post(
        Uri.parse('$URL/follow/following/$id'),
        headers: {'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',},
      );
      return res;
    }catch(e){
      print("error: $e");
    }

  }
  Future<List<dynamic>> getStoryByFollwing() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('$URL/story/following'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      },
    );

    print("Response status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      // Decode the JSON response to a
      final  List<dynamic> jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      // Handle the error if the response status code is not 200
      throw Exception('Failed to load user profile. Status code: ${response.statusCode}');
    }
  }

}