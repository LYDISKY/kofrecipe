// ignore_for_file: non_constant_identifier_names
import 'dart:io';
//import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kof_recipe/pages/login_page.dart';

import 'home_page.dart';

class SingnupPage extends StatefulWidget {
  const SingnupPage({super.key});

  @override
  State<SingnupPage> createState() => _SingnupPageState();
}

class _SingnupPageState extends State<SingnupPage> {
  final _formKey = GlobalKey<FormState>();
  late bool _isPasswordVisible = false;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File ? _image;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0), 
          ),
        ),
        title: const Text('Creer un compte',textAlign: TextAlign.center, style: TextStyle(fontSize: 24, color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  CircleAvatar( 
                    backgroundColor: const Color.fromRGBO(198, 155, 89, 0.7),
                    radius: 100,
                    backgroundImage:_image !=null? FileImage(_image!): null,
                    // child: _image==null? const Icon(Icons.person, color: Colors.white,size: 140,):null
                    ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Importer une image de profil',
                      style:TextStyle(fontSize: 20,color: Colors.black)),
                      const SizedBox(width: 10 ,),
                      GestureDetector(
                        child: const Icon(Icons.image,color: Colors.black,),
                        onTap: () {
                          _pickImageFromGallery();
                        },
                        )
                    ],
                  ),
                  const SizedBox(height: 30,),
                  _inputField('Nom Complet', fullNameController, Icons.person_outlined),
                  const SizedBox(height: 20,),
                  _inputField('E-mail', emailController, Icons.email_outlined),
                  const SizedBox(height: 20,),
                  // _inputField('Mot de passe', passwordController, Icons.key_outlined, isPasswrd: true),
                  TextField(            
                  style: const TextStyle(
                    color: Colors.black,
                  ),

                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Mot de passe',
                    hintStyle: const TextStyle(
                    color: Colors.black
                  ),
                  enabledBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color:  Color.fromRGBO(198, 155, 89, 1.0),width: 2)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                     borderSide: const BorderSide(color: Color.fromRGBO(198, 155, 89, 1.0),width: 2)
                  ),

                  prefixIcon: const  Icon(Icons.key,color: Colors.black,),
                  suffixIcon: GestureDetector(
                    onTap: (){
                    setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                       
                    },
                    child: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.black,
        ),
                  )
                  ),
                  obscureText: !_isPasswordVisible,
                  
  
                  ),
               
                  const SizedBox(height: 30,),
                  
                  _signUpBtn(),
                 
                  const SizedBox(height: 20,),
                  _extraText(),


                ],
              ),
            )),
          ),

      )
    );
  }

  Widget _Icon(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle),
        child: const Icon(Icons.person, color: Colors.white,size: 140,),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,IconData prefixicon, {isPasswrd=false}){
    var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(18),
    borderSide: const BorderSide(color:Color.fromRGBO(198, 155, 89, 1.0), width: 2)
  );
    return TextField(
    style: const TextStyle(
      color: Colors.black,
    ),
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
      color: Colors.black
    ),
    enabledBorder: border,
    focusedBorder: border,
    prefixIcon: Icon(prefixicon,color: Colors.black,)
    ),
    obscureText: isPasswrd,
  );
  }

  Widget _signUpBtn(){
    return ElevatedButton(
      
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      backgroundColor:const Color.fromRGBO(198, 155, 89, 1.0),
    ),
      onPressed: () {
        if (isPasswordStrong(passwordController.text)&& isEmailFormat(emailController.text)) {
           _registerUser();
        FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ).then((value) {
        Navigator.pushAndRemoveUntil(context, 
        MaterialPageRoute(builder: (context)=>const HomePage()), 
        (route) => false);
      }).catchError((error){
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text('Erreur de création de compte'),
              actions: <Widget>[
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: const Text('Fermer'))
              ],
            );
          });
      });
        setState(() {
          emailController.clear();
          fullNameController.clear();
          passwordController.clear();
      });
} else {
  // Mot de passe ne satisfait pas les critères de sécurité, affichez un message d'erreur
  ScaffoldMessenger.of(context).showSnackBar(
   const  SnackBar(
      content: Text("L\'email ou mot de passe ne satisfait pas les critères de sécurité. Le mot de passe doit contenir au moins un carctère spécial, un caratere majuscule,au moins 8 caractères"),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    ),
  );
}

      //   _registerUser();
      //   FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: emailController.text,
      //   password: passwordController.text,
      // ).then((value) {
      //   Navigator.pushAndRemoveUntil(context, 
      //   MaterialPageRoute(builder: (context)=>const HomePage()), 
      //   (route) => false);
      // }).catchError((error){
      //   showDialog(
      //     context: context, 
      //     builder: (BuildContext context){
      //       return AlertDialog(
      //         title: const Text('Erreur de création de compte'),
      //         actions: <Widget>[
      //           TextButton(onPressed: (){
      //             Navigator.of(context).pop();
      //           }, child: const Text('Fermer'))
      //         ],
      //       );
      //     });
      // });
      //   setState(() {
      //     emailController.clear();
      //     fullNameController.clear();
      //     passwordController.clear();
      // });},
      
      },
      child:  const SizedBox(
      height: 40,
      width: 200,
        
      child: Center(
        child: Text(
          'Valider',
          textAlign: TextAlign.center, 
          style: TextStyle(color: Colors.white, fontSize: 25),
          ),
      ),
        ),);
  }

  Widget _extraText(){
    return TextButton(
      onPressed: (){
         Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context)=> const LoginPage()));
      }, 
      child: const Text(' Déjà un compte ? Se Connecter', style: TextStyle(color: Colors.black, fontSize: 20),));

  }

  void _registerUser() async {
    final String username = fullNameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    
    final url = Uri.parse('http://192.168.0.110:8000/User');

    final request = http.MultipartRequest('POST', url);
    request.fields['username']= username;
    request.fields['password'] = password;
    request.fields['email'] = email;
    request.files.add(http.MultipartFile(
      'profile_image', 
      _image?.readAsBytes().asStream() as Stream<List<int>>,
      _image!.lengthSync(),
      filename: 'profile_image.jpg', 
    ));

    
     final response = await request.send();
     
     if (response.statusCode == 201) {
      print('L\'utilisateur a été enregistré avec succès');
      
    } else {
      print('Erreur');
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

  bool isPasswordStrong(String password) {
  
  if (password.length < 8) {
    return false;
  }

  
  final RegExp uppercaseRegex = RegExp(r'[A-Z]');
  final RegExp lowercaseRegex = RegExp(r'[a-z]');
  final RegExp specialCharacterRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  if (!uppercaseRegex.hasMatch(password) ||
      !lowercaseRegex.hasMatch(password) ||
      !specialCharacterRegex.hasMatch(password)) {
    return false;
  }

  return true;
}

bool isEmailFormat(String value) {
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(value);
}

 }