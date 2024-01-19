import 'package:http/http.dart' as http;
import 'dart:convert';

class RecetteAPI {
  static const String baseUrl = "http://192.168.1.65:8000"; 

  Future<bool> ajouterRecette(Recette recette, String authToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Recette'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(recette.toJson()), 
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}

class Recette {
  final String titre;
  final String descRec;
  final String tempsCuisson;
  final String categorie;
  final String preparation;
  final String imageRec; 

  Recette({
    required this.titre,
    required this.descRec,
    required this.tempsCuisson,
    required this.categorie,
    required this.preparation,
    required this.imageRec,
  });

  Map<String, dynamic> toJson() {
    return {
      'titre': titre,
      'desc_rec': descRec,
      'temps_cuisson': tempsCuisson,
      'categorie': categorie,
      'preparation': preparation,
      'image_rec': imageRec,
    };
  }
}
