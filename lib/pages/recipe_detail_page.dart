import 'package:flutter/material.dart';

import '../services/recette_model.dart';


class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {


 

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF191970), Color(0xFF8A2BE2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
              backgroundColor: Colors.blue[900],
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30.0),
                ),
              ),
              title: const Text('Detail de la Recette'),
        ),
      
        // body: SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       Container(
        //         height: 300,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(20)
        //         ),
        //         child: ClipOval(
        //           child: Image.asset('assets/welcome1.jpg'),
        //         ),
        //       ),
        //       const Padding(
        //         padding:  EdgeInsets.all(16.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               children:[
                  
        //               Text('Titre de la recette : ',
        //                style: TextStyle(
        //                 color: Colors.white, 
        //                 fontSize: 25, 
        //                 fontWeight: FontWeight.bold),
        //                 ),
        //               SizedBox(width: 5,),
        //               Text('Titre',
        //                style: TextStyle(
        //                 color: Colors.white, 
        //                 fontSize: 25, 
        //                 fontWeight: FontWeight.bold),
        //                 ),
        //             ]
        //             )
        //           ],
        //         ),
                
        //         )
        //     ],
        //   ),
        // ),
        ),
    );
  }
  
}

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF191970), Color(0xFF8A2BE2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
           elevation: 0.0,
              backgroundColor: Colors.blue[900],
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30.0),
                ),
              ),
              title: const Text('Detail de la Recette'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              //Affichage de l'image de la recette
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),

                  ),
                  image: DecorationImage(image: NetworkImage(recipe.imageRec),fit: BoxFit.cover)
                ),
              
              ),
              Padding(
                padding: const EdgeInsetsDirectional.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Affichage des infos de la recette
                    Text('Titre : ${recipe.titre}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    ),

                    const SizedBox(height: 10,),

                    Text('Description : ${recipe.descRec}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),),

                    const SizedBox(height: 10,),

                    Text('Temps de cuisson : ${recipe.tempsCuisson}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),),

                    const SizedBox(height: 10,),

                    Text('Preparation : ${recipe.descRec}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),),

                    

                  ],
                ),
                )
            ],
          ),
        ),
      ),
    );
  }
   String formatCookingTime(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return '$hours h $minutes min';
  }

}



