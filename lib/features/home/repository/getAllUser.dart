import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insta_clone/features/home/environment.dart';

class getAllUserRepo {
  final URL= environment.Url;
  Future<List<dynamic>> getUserByToken() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final response = await http.get(
      Uri.parse('$URL/user/all'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Decode the JSON response
      final jsonResponse = json.decode(response.body);

      // Check if jsonResponse is a List<dynamic>
      if (jsonResponse is List) {
        // Return the list directly if it's a List
        return jsonResponse;
      } else if (jsonResponse is Map<String, dynamic>) {
        // Handle the case where jsonResponse is a single object (_JsonMap)
        // Convert it to a List with a single item
        return [jsonResponse];
      } else {
        // Handle unexpected response format
        throw Exception('Unexpected response format');
      }
    } else {
      // Handle the error if the response status code is not 200
      throw Exception('Failed to load user. Status code: ${response.statusCode}');
    }
  }
  Future<List<dynamic>> getFoloowers() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');

    final response = await http.get(
      Uri.parse('$URL/follow/followers/token'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Decode the JSON response
      final jsonResponse = json.decode(response.body);

      // Check if jsonResponse is a List<dynamic>
      if (jsonResponse is List) {
        // Return the list directly if it's a List
        return jsonResponse;
      } else if (jsonResponse is Map<String, dynamic>) {
        // Handle the case where jsonResponse is a single object (_JsonMap)
        // Convert it to a List with a single item
        return [jsonResponse];
      } else {
        // Handle unexpected response format
        throw Exception('Unexpected response format');
      }
    } else {
      // Handle the error if the response status code is not 200
      throw Exception('Failed to load user. Status code: ${response.statusCode}');
    }
  }



}
