import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:garamina/auth_state.dart';
import 'package:provider/provider.dart';
import '../admin/dashboard_page.dart';
import '../admin/kontak_page.dart';
import '../admin/chat_page.dart';
import '../admin/riwayat_page.dart';
import '../admin/profil_page.dart';
import '../admin/users_page.dart';

class MenuAdmin extends StatefulWidget {
  @override
  _MenuAdminState createState() => _MenuAdminState();
}

class _MenuAdminState extends State<MenuAdmin> {
  int _selectedIndex = 0;
  int? _notificationCount;

  final List<Widget> _pages = [
    DashboardPage(),
    UsersPage(),
    ChatPage(),
    RiwayatPage(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // final authState = Provider.of<AuthState>(context);
    // setState(() {
    //   _notificationCount = authState.notifCount;
    // });

    // print('ini auth ${authState.notifCount}');
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 50.0,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: _selectedIndex == 0 ? Colors.yellow : Colors.white,
          ),
          Icon(
            Icons.contact_mail,
            size: 30,
            color: _selectedIndex == 1 ? Colors.yellow : Colors.white,
          ),
          Icon(
            Icons.chat,
            size: 30,
            color: _selectedIndex == 2 ? Colors.yellow : Colors.white,
          ),
          Icon(
            Icons.history,
            size: 30,
            color: _selectedIndex == 3 ? Colors.yellow : Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: _selectedIndex == 4 ? Colors.yellow : Colors.white,
          ),
        ],
        color: const Color.fromRGBO(25, 25, 25, 1),
        buttonBackgroundColor: const Color.fromRGBO(25, 25, 25, 1),
        backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
