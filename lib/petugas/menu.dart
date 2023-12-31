import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pemilu/petugas/konten_page.dart';
// import 'package:garamina/auth_state.dart';
import 'package:provider/provider.dart';
import '../petugas/dashboard_page.dart';
import '../petugas/kontak_page.dart';
import '../petugas/chat_page.dart';
import '../petugas/riwayat_page.dart';
import '../petugas/profil_page.dart';
import '../petugas/users_page.dart';

class MenuPetugas extends StatefulWidget {
  @override
  _MenuPetugasState createState() => _MenuPetugasState();
}

class _MenuPetugasState extends State<MenuPetugas> {
  int _selectedIndex = 0;
  int? _notificationCount;

  final List<Widget> _pages = [
    DashboardPage(),
    KontenPage(),
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
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.contact_mail,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.chat,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.history,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ],
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
