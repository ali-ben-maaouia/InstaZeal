import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Importer MediaType depuis ce package
import 'package:insta_clone/features/home/environment.dart';

  class StoryRepo{
    final URL= environment.Url;
  AddStory(String? description,Uint8List imageBytes ) async {
    final url = Uri.parse('$URL/story/create');

    var request = http.MultipartRequest('POST', url);
    var pref = await SharedPreferences.getInstance();
    var authToken=pref.getString('token');

    print(authToken);
    request.headers['Authorization'] = 'Bearer $authToken';  // Ajoutez l'en-tête d'autorisation avec le token
    request.headers['Content-Type'] = 'multipart/form-data';  // Ajoutez l'en-tête Content-Type

    request.fields['description'] = description!;

    request.files.add(http.MultipartFile.fromBytes(
      'file', // Le nom du champ pour le fichier
      imageBytes, // Les données du fichier
      filename: 'image.jpg', // Le nom du fichier à envoyer (vous pouvez choisir n'importe quel nom ici)
      contentType: MediaType('image', 'jpeg'), // Type MIME du fichier
    ));

    try {
      print("zzzzzzzzzzz");
      var response = await request.send();
      print(response);
      if (response.statusCode == 201) {
        print('story ajoute avec succès !');
        return response;
      } else {
        print('Erreur lors de l\'envoi de l\'image : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur : $e');
    }
  }
    Future<List<dynamic>> getAllStoriesByUserToken() async {
      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      if (token == null) {
        throw Exception('No token found');
      }

      final response = await http.get(
        Uri.parse('$URL/story/user/token'),
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