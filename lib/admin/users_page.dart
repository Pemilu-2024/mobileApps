import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<Map<String, String>> users = [];
  List<Map<String, String>> filteredUsersData = [];
  int? selectedUserId;
  String? token;
  TextEditingController searchController = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getTokenFromSharedPreferences();
  }

  Future<void> getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      setState(() {
        token = prefs.getString('token');
      });
      fetchData();
    }
    print('token: $token');
  }

  Future<void> fetchData() async {
    try {
      const String apiUrl = 'http://localhost:8000/api/auth/list-users';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];

        users = List<Map<String, String>>.from(
          data.map((dynamic item) {
            return {
              'nama': item['nama'].toString(),
              'email': item['email'].toString(),
              'status': item['status'].toString(),
              'level': item['level'].toString(),
              'id': item['id'].toString(),
            };
          }),
        );

        setState(() {
          loading = false;
          filteredUsersData = users;
        });
        print('test data: $users');
      } else {
        setState(() {
          loading = false;
        });
        _showErrorDialog(
          'Fetch Data Gagal',
          'Gagal mengambil data, silahkan coba kembali',
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('error: $e');
      _showErrorDialog(
        'Fetch Data Gagal',
        'Gagal mengambil data, silahkan cek koneksi anda',
      );
    }
  }

  Future<void> verifikasiUser(userId) async {
    try {
      String apiUrl = 'http://localhost:8000/api/auth/verify-access/${userId}';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        fetchData();
        setState(() {
          loading = false;
        });
        final responseData = json.decode(response.body);
        print('response verify: $responseData');
      } else {
        setState(() {
          loading = false;
        });
        _showErrorDialog(
          'Fetch Data Gagal',
          'Gagal mengambil data, silahkan coba kembali',
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('error: $e');
      _showErrorDialog(
        'Fetch Data Gagal',
        'Gagal mengambil data, silahkan cek koneksi anda',
      );
    }
  }

  Future<void> deleteUser(userId) async {
    try {
      String apiUrl = 'http://localhost:8000/api/auth/delete-user/${userId}';

      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        final responseData = json.decode(response.body);
        print('response delete: $responseData');
      } else {
        setState(() {
          loading = false;
        });
        _showErrorDialog(
          'Fetch Data Gagal',
          'Gagal mengambil data, silahkan coba kembali',
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('error: $e');
      _showErrorDialog(
        'Fetch Data Gagal',
        'Gagal mengambil data, silahkan cek koneksi anda',
      );
    }
  }

  Future<void> _showErrorDialog(title, message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void filterUsersData(String query) {
    List<Map<String, String>> filteredList = users.where((user) {
      String nama = user['nama']!.toLowerCase();
      String email = user['email']!.toLowerCase();
      String status = user['status']!.toLowerCase();
      String level = user['level']!.toLowerCase();
      String id = user['id']!.toLowerCase();

      return nama.contains(query.toLowerCase()) ||
          email.contains(query.toLowerCase()) ||
          status.contains(query.toLowerCase()) ||
          level.contains(query.toLowerCase()) ||
          id.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUsersData = filteredList;
    });
    print(filteredUsersData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
        title: selectedUserId != null
            ? const Text('Pilih User')
            : const Text('List User'),
        actions: [
          if (selectedUserId != null)
            PopupMenuButton<String>(
              color: const Color.fromRGBO(44, 44, 44, 1),
              onSelected: (String value) {
                // Handle menu item selection
                if (value == 'verifikasi') {
                  setState(() {
                    loading = true;
                  });
                  verifikasiUser(selectedUserId);
                } else if (value == 'hapus') {
                  setState(() {
                    loading = true;
                  });
                  deleteUser(selectedUserId);
                }

                // Reset selectedUserId after action
                setState(() {
                  selectedUserId = null;
                });
              },
              itemBuilder: (BuildContext context) {
                String? status;
                for (var i = 0; i < users.length; i++) {
                  if (users[i]['id'] == selectedUserId.toString()) {
                    status = users[i]['status'];
                  }
                }
                return [
                  status == '2'
                      ? const PopupMenuItem<String>(
                          value: 'hapus',
                          child: Text(
                            'Hapus',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : const PopupMenuItem<String>(
                          value: 'verifikasi',
                          child: Text(
                            'Verifikasi',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                ];
              },
            ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              filteredUsersData = users;
                            });
                          },
                        )
                      : const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                  filled: true,
                  fillColor: const Color.fromRGBO(44, 44, 44, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                controller: searchController,
                onChanged: (value) {
                  filterUsersData(value);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            loading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Loading...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsersData.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsersData[index];
                        return ListTile(
                          onTap: () {
                            setState(() {
                              // selectedUserId = user.id;
                            });
                          },
                          title: Text(
                            user['nama']!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['email']!,
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                          tileColor: selectedUserId == int.parse(user['id']!)
                              ? const Color.fromRGBO(44, 44, 44, 1)
                              : null,
                          onLongPress: () {
                            setState(() {
                              selectedUserId = int.parse(user['id']!);
                            });
                          },
                          trailing: user['status']! == '0'
                              ? const Icon(
                                  Icons.mark_email_unread,
                                  color: Colors.white,
                                )
                              : user['status']! == '1'
                                  ? const Icon(
                                      Icons.hourglass_top,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.verified,
                                      color: Colors.white,
                                    ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
