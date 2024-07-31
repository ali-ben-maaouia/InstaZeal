import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_clone/features/home/environment.dart';

class UnFollowingRepo{
  final URL= environment.Url;
  AddUnFollowing(int id)async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }
    try {
      var res = await http.delete(
        Uri.parse('$URL/follow/unfollow/$id'),
        headers: {'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',},
      );
      return res;
    }catch(e){
      print("error: $e");
    }

  }
}