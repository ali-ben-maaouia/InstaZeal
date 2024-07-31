import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';  // Importer MediaType depuis ce package
import 'package:insta_clone/features/home/environment.dart';

class RegistreRepo{
  final URL= environment.Url;
  registre(Uint8List imageBytes,String gender,String website,String fullName,String bio,String phoneNumber,String categoryIds,String email,String password ) async {
    final url = Uri.parse('$URL/v1/auth/signup/user');

    var request = http.MultipartRequest('POST', url);

    request.fields['fullName'] = fullName;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['bio'] = bio;
    request.fields['website'] = website;
    request.fields['phoneNumber'] = phoneNumber;
    request.fields['gender'] = gender;

    request.fields['categoryIds'] = categoryIds;
    request.files.add(http.MultipartFile.fromBytes(
      'file', // Le nom du champ pour le fichier
      imageBytes, // Les données du fichier
      filename: 'image.jpg', // Le nom du fichier à envoyer (vous pouvez choisir n'importe quel nom ici)
      contentType: MediaType('image', 'jpeg'), // Type MIME du fichier
    ));

    try {
      var response = await request.send();
      print(response);
      if (response.statusCode == 201) {
        print('Image envoyée avec succès !');
        return response;
      } else {
        print('Erreur lors de l\'envoi de l\'image : ${response.statusCode}');
        print('Corps de la réponse : ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Erreur : $e');
    }
  }

}