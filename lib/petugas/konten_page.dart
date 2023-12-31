import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pemilu/petugas/Input_konten_page.dart';
import 'package:pemilu/components/easy_access.dart';
import 'package:pemilu/components/konten_card.dart';
import 'package:pemilu/petugas/candidat_page.dart';
import 'package:pemilu/petugas/input_feedback_page.dart';
import 'package:pemilu/petugas/kategori_pemilu_page.dart';
import 'package:pemilu/petugas/visi_misi_page.dart';
import 'package:pemilu/states/auth_state.dart';
import 'package:pemilu/petugas/tps/input_suara_page.dart';
import 'package:pemilu/petugas/tps/input_tps_page.dart';
import 'package:pemilu/petugas/tps/pemilu_page.dart';
import 'package:pemilu/petugas/tps/tps_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../components/carousel.dart';

class KontenPage extends StatefulWidget {
  @override
  _KontenPageState createState() => _KontenPageState();
}

class _KontenPageState extends State<KontenPage> {
  DateTime dateTime = DateTime.now();
  int tabIndex = 0;
  bool show = false;
  List<dynamic> dataKonten = [];
  List<dynamic> dataResponse = [];
  String? token;
  bool loading = true;
  bool nullResponse = false;
  TextEditingController searchController = TextEditingController();

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
      getDataKontens();
    }
    print('tps token: $token');
  }

  Future<void> getDataKontens() async {
    try {
      // const String apiUrl = 'http://localhost:8000/api/auth/list-konten';
      const String apiUrl =
          'https://aaa.surabayawebtech.com/api/auth/list-konten';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('data konten $responseData');
        final length = responseData['data'].length;
        setState(() {
          loading = false;
          dataKonten = responseData['data'];
          dataResponse = responseData['data'];
          if (length != 0) {
            nullResponse = false;
          } else {
            nullResponse = true;
          }
        });

        print('test konten: ${responseData['data']}');
        print('test data konten: $dataKonten');
      } else {
        setState(() {
          loading = false;
        });
        // Handle error response
        print('data konten gagal diambil');
        _showErrorDialog('Request Gagal',
            'Tidak dapat menampilkan data konten, silahkan dicoba kembali');
      }
    } catch (e) {
      // Handle exception
      print('Error Api: $e');
      setState(() {
        loading = false;
      });
      _showErrorDialog(
          'Masalah Koneksi', 'Periksa koneksi anda, lalu coba kembali');
    }
  }

  Future<void> getDataInteraksis() async {}

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

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Search konten',
                  labelStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  // Memfilter data berdasarkan judul
                  List<dynamic> filteredData = dataKonten.where((item) {
                    return item['judul']
                        .toLowerCase()
                        .contains(value.toLowerCase());
                  }).toList();

                  setState(() {
                    // Mengupdate dataKonten dengan data yang telah difilter atau mengembalikan data asli jika teks pencarian kosong
                    dataKonten = value.isEmpty ? dataResponse : filteredData;
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputKontenPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: loading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Loading...',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              )
            : nullResponse
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum ada konten',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataKonten.length,
                    itemBuilder: (context, index) {
                      return ContentCard(
                        userId: authState.userId.toString(),
                        id: dataKonten[index]['id'].toString(),
                        imageUrl: dataKonten[index]['gambar'],
                        caption: dataKonten[index]['judul'],
                        likes: int.parse(dataKonten[index]['jumlahLike']),
                        dislikes: int.parse(dataKonten[index]['jumlahDislike']),
                        comments: int.parse(dataKonten[index]['jumlahKomen']),
                      );
                    },
                  ),
      ),
    );
  }
}
