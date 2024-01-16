import 'package:flutter/material.dart';
import '../Pages/BottomNavBar/Favorit.dart';
import '../Pages/BottomNavBar/Information.dart';
import '../Pages/BottomNavBar/Beranda.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  static String routeName = '/customBottomNavigationBar';
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<String> items = ['Home', 'Application', 'Statistic', 'News', 'Account'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildBottomNavigationBarItem(Icons.home, 'Beranda'),
          _buildBottomNavigationBarItem(Icons.library_books, 'Favorit'),
          _buildBottomNavigationBarItem(Icons.account_circle, 'Informasi'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: _selectedIndex == items.indexOf(label) ? 40.0 : 30.0,
        child: Icon(
          icon,
          size: _selectedIndex == items.indexOf(label) ? 30.0 : 24.0,
        ),
      ),
      label: label,
    );
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return Beranda();
      case 1:
        return Favorit();
      case 2:
        return Information();
      default:
        return _buildPage('Halaman Kosong');
    }
  }

  Widget _buildPage(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CustomBottomNavigationBar(),
  ));
}