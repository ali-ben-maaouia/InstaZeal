import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:insta_clone/features/home/environment.dart';
class LoginRepo{
  final URL= environment.Url;
  login(String email, String password)async {
    var res= await http.post(Uri.parse('$URL/v1/auth/signin'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode({'email': email, 'password': password})
    );
    return res;

  }
}