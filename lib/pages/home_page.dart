
import 'package:flutter/material.dart';
import 'package:kof_recipe/pages/add_recipePage.dart';
import 'package:kof_recipe/pages/favorite_page.dart';
import 'package:kof_recipe/pages/list_page.dart';
import 'home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const FavoritePage(),
      const ListPage(),

    ];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(198, 155, 89, 1.0),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black38,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),

         /* BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Liste personnalisée',
          ),*/
         
         
        ]
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context)=>const AddPage()),);
          },
          
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(50.0),
          ),
          backgroundColor: Colors.white,
          child: const Icon(Icons.add, color: Color.fromRGBO(198, 155, 89, 1.0),size: 30,),
          
          ),
      
    );
  }

}
