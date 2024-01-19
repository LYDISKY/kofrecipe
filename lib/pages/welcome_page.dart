import 'package:flutter/material.dart';
import 'package:kof_recipe/pages/login_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Image.asset('assets/Logo-cuisine-RI.png',height: 300, width: 300,),
            
             const Text(
                'Bienvenue sur KOFRECIPE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Créez, partagez, dégustez !', style: TextStyle(
                fontSize: 20,
                
              ),),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(198, 155, 89, 1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), 
           ),
                ),
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context)=> const LoginPage()),
                  );
              }, 
              child: const Text('Commencer',style: TextStyle(fontSize: 20),))
            ],
          ),
        ),
      ),
    );
  }
}

