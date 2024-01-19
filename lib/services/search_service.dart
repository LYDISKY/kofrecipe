// Classe de délégué de recherche pour la barre de recherche
import 'package:flutter/material.dart';

class RecipeSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white,), // Icône pour effacer le texte de recherche
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back), // Icône de retour
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Logique de recherche des recettes en utilisant la valeur de "query"
    return Center(
      child: Text('Résultats de recherche pour : $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions de recherche (optionnel)
    return const Center(
      child: Text('Suggestions de recherche',style: TextStyle(color: Colors.white), ),
    );
  }
}