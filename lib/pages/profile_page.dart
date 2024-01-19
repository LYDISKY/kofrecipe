import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'welcome_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<String> recipes = ["Recette 1", "Recette 2", "Recette 3"];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _userProfileImage ='';
  String _username = '';
  String _email = '';
  bool _isLoading = false;
  File ? _image;
  
  

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }
  Future<void> _loadUsername() async {
   
    setState(() {
      _isLoading = true;
    });
    final user = await _auth.currentUser!;
    
    final email = user.email;
    
    final response = await http.get(
    Uri.parse('http://192.168.0.110:8000/user/$email/'), 
  );

  if (response.statusCode == 200) {
    final userData = json.decode(response.body);
    final username = userData['username'];
    
    print(response.body);
  final userProfileImage = userData['profile_image'];

    setState(() {
      _username = username;
      _isLoading = false;
      _userProfileImage = userProfileImage;
      _email = user.email!;
    });
  } else if(response.statusCode == 500){
    print('Erreur username non trouvé');
  }
  }



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
              title: const Text('Profil'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  const SizedBox(height: 10,),
                 !_isLoading? CircleAvatar(radius:100,backgroundImage:NetworkImage('http://192.168.0.110:8000$_userProfileImage') ,):const CircularProgressIndicator(),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     const Text('Nom : ',
                      style:TextStyle(
                        fontSize: 24,
                    color: Colors.white
                      ),
                      ),
                      const SizedBox(width: 5,),
                      _isLoading? const CircularProgressIndicator(): Text(_username,
                      style:const TextStyle(
                        fontSize: 24,
                    color: Colors.white
                      ), )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     const Text('Email: ',
                      style:TextStyle(
                        fontSize: 24,
                    color: Colors.white
                      ),
                      ),
                      const SizedBox(width: 5,),
                      _isLoading? const CircularProgressIndicator(): Text(_email,
                      style:const TextStyle(
                        fontSize: 24,
                    color: Colors.white
                      ), )
                    ],
                  ),

                  const SizedBox(height: 10,),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        _pickImageFromGallery();
                      },
                      
                      child: const  Text("Modifier la photo de profil",
                       style: TextStyle(color: Colors.white, fontSize: 20),),
                  
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Divider(thickness: 2,),
                  const SizedBox(height: 20,),
                 const Row(
                      children: [
                        Icon(Icons.list, color: Colors.white,size: 25,), 
                        SizedBox(width: 8), 
                        Text('Voir la liste de vos recettes', style:TextStyle(color: Colors.white, fontSize:20 ),), 
                        ],
                        ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      signOut();
                    },
                    child: const Row(
                    
                      children: [
                        Icon(Icons.exit_to_app, color: Colors.white,size: 25,), 
                        SizedBox(width: 8), 
                        Text('Déconnexion', style:TextStyle(color: Colors.white, fontSize:20 ),), 
                        ],
                        ),
                  ),
                ],
              ),
            ),
          )
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

   Future _pickImageFromGallery() async {
   final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
   if (returnedImage == null) {
     return;
   }
   setState(() {
     _image = File(returnedImage.path);
   });
  }
}
  



