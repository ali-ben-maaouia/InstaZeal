import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Importer MediaType depuis ce package
import 'package:insta_clone/features/home/environment.dart';

class AddPostRepo{
  final URL= environment.Url;
  AddPost(String? description,String categoryId,Uint8List imageBytes ) async {
    final url = Uri.parse('$URL/post/create');

    var request = http.MultipartRequest('POST', url);
    var pref = await SharedPreferences.getInstance();
    var authToken=pref.getString('token');

    print(authToken);
    request.headers['Authorization'] = 'Bearer $authToken';  // Ajoutez l'en-tête d'autorisation avec le token
    request.headers['Content-Type'] = 'multipart/form-data';  // Ajoutez l'en-tête Content-Type

    request.fields['description'] = description!;
    request.fields['categoryId'] = categoryId!;

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
      if (response.statusCode == 200) {
        print('post ajoute avec succès !');
        return response;
      } else {
        print('Erreur lors de l\'envoi de l\'image : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur : $e');
    }
  }
  SearchPost(String keyword ) async {

    var res= await http.post(Uri.parse('$URL/post/search?keyword=$keyword'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
    return res;

  }

}