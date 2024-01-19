import 'package:flutter/material.dart';
import 'package:kof_recipe/services/recette_model.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(198, 155, 89, 1.0),
        shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30.0), 
        ),
      ),
        title: const Center(child: Text(
          'MES FAVORIS',
          
          )),
      ),
      body: FutureBuilder<List<Recipe>>(
    future: fetchFavoriteRecipes(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Erreur : ${snapshot.error}');
      } else if (snapshot.hasData) {
        List<Recipe> favoriteRecipes = snapshot.data!;

        return ListView.builder(
          itemCount: favoriteRecipes.length,
          itemBuilder: (context, index) {
            Recipe recipe = favoriteRecipes[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                padding:const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Icon(Icons.favorite, color: Colors.black38),
                    const SizedBox(width: 10,),
                    Expanded(
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(recipe.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${recipe.descRec} - \nCategorie: ${recipe.categorie}',
                          ),
                          
                        ],
                      ),
                    ),
                    
                  ],

                ),
              ),
            );
          },
        );
      } else {
        return const Text('Aucune donnée trouvée.');
      }
    },
      ),
      
      );
  }
}
