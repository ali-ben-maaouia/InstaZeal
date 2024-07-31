import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_clone/features/home/environment.dart';

class CategoryRepo {
  final URL= environment.Url;

  Future<List<dynamic>> getCategories() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
print(token);
    final response = await http.get(
      Uri.parse('$URL/categories'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
    print("rrrrrrrrrrrrr");
print(response);
    if (response.statusCode == 200) {
      // Decode the JSON response to a List of dynamic objects
      final List<dynamic> categories = json.decode(response.body);
      return categories;
    } else {
      // Handle the error if the response status code is not 200
      throw Exception('Failed to load categories. Status code: ${response.statusCode}');
    }
  }
}
