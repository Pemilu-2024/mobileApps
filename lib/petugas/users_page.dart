import 'package:flutter/material.dart';

class User {
  final int id;
  final String name;
  final String email;
  bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.isVerified = false,
  });
}

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [
    User(id: 1, name: 'Joni Efendi', email: 'joni@example.com'),
    User(
        id: 2,
        name: 'Hartina Suci Rustini',
        email: 'tina@example.com',
        isVerified: true),
    User(id: 3, name: 'Bagus Untoro', email: 'bagus@example.com'),
    // Add more users as needed
  ];

  int? selectedUserId;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<User> filteredUsers = users.where((user) {
      return user.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ||
          user.email
              .toLowerCase()
              .contains(searchController.text.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
        title: selectedUserId != null
            ? Text('Selected User')
            : TextField(
                controller: searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by name or email',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
        actions: [
          if (selectedUserId != null)
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Show your detail menu here
                showDetailMenu();
              },
            ),
        ],
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return GestureDetector(
            onLongPress: () {
              setState(() {
                selectedUserId = user.id;
              });
            },
            onTap: () {
              setState(() {
                selectedUserId = null;
              });
            },
            child: Container(
              color: selectedUserId == user.id ? Colors.grey[300] : null,
              child: ListTile(
                title: Text(
                  user.name,
                  style: TextStyle(
                      color: selectedUserId == user.id
                          ? Colors.black
                          : Colors.white),
                ),
                subtitle: Text(
                  user.email,
                  style: TextStyle(
                      color: selectedUserId == user.id
                          ? Colors.black
                          : Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showDetailMenu() {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          offset,
          Offset(offset.dx + button.size.width, offset.dy + button.size.height),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: 'verifikasi',
          child: Text('Verifikasi'),
        ),
        PopupMenuItem<String>(
          value: 'hapus',
          child: Text('Hapus'),
        ),
      ],
    ).then((value) {
      // Handle menu item selection
      if (value == 'verifikasi') {
        // Logika verifikasi pengguna
        setState(() {
          users.firstWhere((u) => u.id == selectedUserId).isVerified =
              !users.firstWhere((u) => u.id == selectedUserId).isVerified;
        });
      } else if (value == 'hapus') {
        // Logika hapus pengguna
        setState(() {
          users.removeWhere((u) => u.id == selectedUserId);
        });
      }

      // Reset selectedUserId after action
      setState(() {
        selectedUserId = null;
      });
    });
  }
}
