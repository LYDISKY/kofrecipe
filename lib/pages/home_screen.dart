// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kof_recipe/pages/profile_page.dart';
import 'package:kof_recipe/pages/recipe_detail_page.dart';
import 'package:kof_recipe/pages/welcome_page.dart';
import 'package:kof_recipe/services/recette_model.dart';

import '../services/search_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Recipe>Recettes;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userProfileImage ='';
  bool _isLoading = true;

  

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }
  Future<void> _loadUsername() async {
    final user = await _auth.currentUser!;
    final email = user.email;
    final response = await http.get(
    Uri.parse('http://192.168.0.110:8000/user/$email/'), 
  );

  if (response.statusCode == 200) {
    final userData = json.decode(response.body);
    print(response.body);
  final userProfileImage = userData['profile_image'];

    setState(() {
      _userProfileImage = userProfileImage;
      _isLoading = false;
     
    });
  } else if(response.statusCode == 500){
    print('Erreur username non trouvé');
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
            ),
            ),
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(198, 155, 89, 1.0),
        actions: [
          IconButton(
            onPressed: (){
              showSearch(
                context: context, 
                delegate: RecipeSearchDelegate());
            }, 
            icon: const Icon(Icons.search, color: Colors.white,)),
          GestureDetector(
            child: !_isLoading ? CircleAvatar(
              backgroundImage:  NetworkImage("http://192.168.0.110:8000$_userProfileImage")) : const CircularProgressIndicator(),
              onTap: () {
                 Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context)=> const ProfilePage()));
              },
          ),
        const SizedBox(width: 10,)
        ],
        title: const Center(child: Text('KOFRECIPE', style: TextStyle(color: Colors.white, fontSize: 25),)),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Recipe>>(
            future: fetchFavoriteRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur : ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<Recipe> Recipes = snapshot.data!;
                
              
         return ListView.builder(
          itemCount: Recipes.length,
          itemBuilder:((context, index) {
            Recipe recipe = Recipes[index];
            
            return RecetteCard(recipe.titre, recipe.imageRec, recipe.descRec, Recipes[index]);
            
          }),
          
         );
        }else {
                return const Text('Aucune donnée trouvée.');
              }
         }
        ),
      ),
    );
  }
  

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }

  Widget RecetteCard(String titre, String imagePath, String Description,Recipe recipe) {
  // bool isFavorite = false;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      
      child: InkWell(
        onTap: (){
          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => 
       RecipeDetailPage(recipe: recipe)),
    );
        },
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: NetworkImage(
                  imagePath), 
                  fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4) ,BlendMode.srcATop),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                //  GestureDetector(
                //   onDoubleTap: (){
                //     setState(() {
                //       // isFavorite = true;
                //     });
                //   },
                //   // child:isFavorite? Icon(Icons.favorite,color: Colors.red): const Icon(Icons.favorite_border, color: Colors.white,) ,
                //  ),
                Text(
                  titre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, 
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  Description,
                  style:const TextStyle(
                    fontSize: 15.0,
                    color: Colors.white, 
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

