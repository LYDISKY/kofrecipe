// ignore_for_file: non_constant_identifier_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kof_recipe/pages/sinup_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              _icon(),
              const Text('Connecter-vous à votre compte',
              style: TextStyle(
                fontSize: 20,
              ),),
              const SizedBox(height: 50,),
              _Input('Email',userNameController,Icons.email_outlined),
              const SizedBox(height: 20,),
              _Input('Mot de psse',passwordController,Icons.key_outlined,isPasswrd: true),
              const SizedBox(height: 50),
              LoginBtn(),
              const SizedBox(height: 20,),
              _extraText(),
            
            ],
          ),
          ),
      ),
    );
  }
    Widget _icon(){
      return Image.asset('assets/Logo-cuisine-RI.png',height: 300,width: 250,);
     
    }

  Widget _Input(String hintText,TextEditingController controller,IconData prefixicon, {isPasswrd=false}){
    var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: Color.fromRGBO(198, 155, 89, 1.0),width: 2)
  );
    return TextField(
      style: const TextStyle(  
    ),
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
      fontSize: 15
    ),
    enabledBorder: border,
    focusedBorder: border,
   prefixIcon: Icon(prefixicon,color:Colors.black),
    ),
    obscureText: isPasswrd,
    );
  }

  Widget LoginBtn(){
  
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
           ),
        backgroundColor:const Color.fromRGBO(198, 155, 89, 1.0),),
      onPressed: () async{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userNameController.text, 
        password: passwordController.text)
       .then((value) {
        Navigator.pushAndRemoveUntil(context, 
        MaterialPageRoute(builder: (context)=>const HomePage()), 
        (route) => false);
      }).catchError((error){
        showDialog(
          context: context, 
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text('Erreur de connexion veuillez réessayer'),
              actions: <Widget>[
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: const Text('Fermer'))
              ],
            );
          });
      });
       /* Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context)=> const HomePage()));*/ 
      debugPrint("Email: ${userNameController.text}" );
      debugPrint("Password: ${passwordController.text}" );
      setState(() {
        userNameController.clear();
        passwordController.clear();
      });
      }, 
      child: const SizedBox(
        height: 40,
        width: 200,
        child: Center(
          child: Text('Se connecter',
          style: TextStyle(fontSize: 25,),),
          
        ),
      ));
  }

  Widget _extraText(){
    return TextButton(
      onPressed: (){
         Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context)=> const SingnupPage()));
      }, 
      child: const Text('Creer un Compte', style: TextStyle(color: Colors.black, fontSize: 20),));

  }

  
}