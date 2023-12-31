import 'package:flutter/material.dart';
import 'package:pemilu/akun_page.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
          title: Text('Profil'),
        ),
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bagian pertama
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/150'),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Nama Pengguna',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Bagian kedua
                Card(
                  elevation: 3,
                  color: const Color.fromRGBO(25, 25, 25, 1),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildProfileItem(
                            'Email', 'user@example.com', Icons.email),
                        SizedBox(height: 10),
                        buildProfileItem(
                            'Nomor Telepon', '08123456789', Icons.phone),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Bagian ketiga
                Card(
                  elevation: 3,
                  color: const Color.fromRGBO(25, 25, 25, 1),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AkunPage(),
                              ),
                            );
                          },
                          child: buildProfileItemWithIcon(
                              'Informasi Akun', Icons.info_outline),
                        ),
                        SizedBox(height: 10),
                        buildProfileItemWithIcon(
                            'Ubah Password', Icons.lock_outline),
                        SizedBox(height: 10),
                        buildProfileItemWithIcon('FAQ', Icons.help_outline),
                        SizedBox(height: 10),
                        buildProfileItemWithIcon(
                            'Telepon Pending', Icons.phone_missed_outlined),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Bagian keempat
                Card(
                  elevation: 3,
                  color: const Color.fromRGBO(25, 25, 25, 1),
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildProfileItem(String title, String subtitle, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Widget buildProfileItemWithIcon(String title, IconData icon) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
      ),
    );
  }
}
