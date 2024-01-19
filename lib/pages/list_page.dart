import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF191970), Color(0xFF8A2BE2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.blue[900],
            title: const Text('LISTE'),
            shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30.0), 
            ),
          ),
          ),
          body: const SingleChildScrollView(
            child: Center(
              child: Text('Vos Recettes personnelles s\'affichent ici '),
            ),
          ),
          
          ),
    );
  }
}
