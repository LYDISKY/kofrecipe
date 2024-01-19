import 'dart:convert';
import 'package:http/http.dart' as http;


class Recipe {
  final String titre;
  final String descRec;
  final String dateRec;
  final String tempsCuisson;
  final String imageRec;
  final String categorie;
  final int idUser;
  final String preparation;

  Recipe({
    required this.titre,
    required this.descRec,
    required this.dateRec,
    required this.tempsCuisson,
    required this.imageRec,
    required this.categorie,
    required this.idUser,
    required this.preparation,
    });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
     titre: json['titre'],
      descRec: json['desc_rec'],
      dateRec: json['date_rec'],
      tempsCuisson: json['temps_cuisson'],
      imageRec: json['image_rec'],
      categorie: json['categorie'],
      idUser: json['id_user'],
      preparation: json['preparation'],
    );
  }

  
}
Future<List<Recipe>> fetchFavoriteRecipes() async {
  final List<Recipe> recipes = [];
  final url = Uri.parse('http://192.168.0.110:8000/Recette');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      //List<dynamic> data = json.decode(response.body);
      recipes.addAll(data.map((item) => Recipe.fromJson(item)));
      print('Response Body: ${response.body}');
      print('Information récupéré');
    } else {
      throw Exception('Informations Non retrouvées');
    }
  } catch (error) {
    print('ERROR HERE');
    print(error);
  }

  return recipes;
}

