import 'package:flutter/material.dart';
import '../interactionSearch.dart';
import '../interaction_list.dart';
import '../ComposantsPerso/HistoryPage.dart';
import '../ComposantsPerso/ProfilePage.dart';
/*import '../ComposantsPerso/OCRScanner.dart';
import '../ComposantsPerso/PDFScanner.dart';*/
//import '../ComposantsPerso/PdfLoaderComponent.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 4;

  static final List<Widget> _widgetOptions = <Widget>[
    const ProfilePage(),
    const HistoryPage(),
    //PdfLoaderComponent(),
    //PDFScanner(),
    const InteractionSearch(),
    const InteractionSearch(),
    const InteractionSearch()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            label: 'Intéractions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Recommandations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.white, // Ajoutez cette ligne
        onTap: _onItemTapped,
      ),
    );
  }
}
