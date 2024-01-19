// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController cookingTimeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController preparationController = TextEditingController();
  String selectedCategory = 'PD';
 String nom = '';
  File ? _image;

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
          title: const Text('Ajouter une recette', style: TextStyle(color: Colors.white, fontSize: 25),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              _Input('Titre', titleController, Icons.restaurant),
              const SizedBox(height: 20,),
              _Input('Description', descriptionController, Icons.description),
              const SizedBox(height: 20,),
              _Input('Temps de cuisson', cookingTimeController, Icons.alarm),
              const SizedBox(height: 20,),
              _Input('Préparation', preparationController, Icons.list_alt),
              const SizedBox(height: 20,),
               
            
             DropdownButtonFormField(
              decoration:InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color.fromRGBO(198, 155, 89, 1.0),)
                )  ,
              enabledBorder:OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Color.fromRGBO(198, 155, 89, 1.0),)
                )  ,
              prefixIcon: const Icon(Icons.category, color: Color.fromRGBO(198, 155, 89, 1.0),), // Icône de catégorie
              labelText: 'Catégorie',
              labelStyle: const TextStyle(color: Colors.black, fontSize: 20),
              
            ),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: <String>[
                'PD',
                'DJ',
                'DN',
                
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,),
                );
              }).toList(),
            ),
          
          //     Row(
          // children: [
          //   Expanded(
          //     child: TextFormField(
          // controller: categoryController,
          // decoration: const InputDecoration(
          //   labelText: 'Catégorie',
          //   labelStyle: TextStyle(color: Colors.white),
          //   prefixIcon: Icon(Icons.category,color: Colors.white,),
          // ),
          //     ),
          //   ),
          //   const SizedBox(width: 16), 
            
          // ],
          // ),
          const SizedBox(height: 20,),

          CircleAvatar( 
            radius: 80,
            backgroundImage:_image != null ? FileImage(_image!) : null,
            child:_image == null?
            const Icon(Icons.image, size: 40) 
    : null,),

            const SizedBox(height: 20,),
             _extraText(),
          const SizedBox(height: 20,),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(198, 155, 89, 1.0)),
              onPressed: (){
                sendRecipetoApi();
              },
              child: const SizedBox(
                width: 150,
                height: 30, child: Center(
                  child: Text(
                    'Ajouter', 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20),))
                      ),
                      ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _extraText(){
    return TextButton(
      onPressed: (){
        _pickImageFromGallery();
      }, 
      child: const SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
             Icon(Icons.image,color: Colors.black,),
             SizedBox(width: 10),
            Text(' Ajouter L\'image de la recette', style: TextStyle(color: Colors.black, fontSize: 20),),
            
           
          ],
        ),
      )
      );

  }
  
  @override
  void initState() {
    super.initState();
    _loadUserId();
  }
  
  Future _loadUserId()async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = await _auth.currentUser;
    final email = user!.email;
    final response = await http.get(
    Uri.parse('http://192.168.0.110:8000/user/$email/'),
    );
    if (response.statusCode ==200) {
      final userid = json.decode(response.body)['username'];
      setState(() {
        nom = userid;
      });
    } else if(response.statusCode == 500){
    print('Erreur username non trouvé');
  }
  }

  Future _pickImageFromGallery() async {
   final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
   if (returnedImage == null) {
     return;
   }
   setState(() {
     _image = File(returnedImage.path);
   });
  }

  Future <void> sendRecipetoApi() async {
  final url = Uri.parse('http://192.168.0.110:8000/Recette');
  final request = http.MultipartRequest('POST', url,);
  request.fields['titre'] = titleController.text;
  request.fields['desc_rec'] = descriptionController.text;
  request.fields['temps_cuisson'] = cookingTimeController.text;
  request.fields['categorie'] = selectedCategory;
  request.fields['preparation'] = preparationController.text;
  request.fields['id_user'] = nom;
  request.files.add(http.MultipartFile(
    'image_rec', 
    _image?.readAsBytes().asStream() as Stream<List<int>>,
    _image!.lengthSync(),
    filename: 'image_rec.jpg'));
      print(request.fields);
      print(request.files);
      try {
        final response = await request.send();
        print('Requette envoyé');
        print(response.statusCode);

      if (response.statusCode == 201) {
        print('Recette envoyé avec succès');
      } else {
      print('Erreur');
      
    }
      } catch (e) {
        print(e);
      }
      
}

}



Widget _Input(String hintText,TextEditingController controller,IconData prefixicon,){
    var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: Color.fromRGBO(198, 155, 89, 1.0),)
  );
    return TextFormField(
      style: const TextStyle(
      color: Colors.white,
      
    ),
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
      color: Colors.black
    ),
    enabledBorder: border,
    focusedBorder: border,
   prefixIcon: Icon(prefixicon, color: const Color.fromRGBO(198, 155, 89, 1.0),),
    ),
    );
  }

  



