import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pemilu/components/easy_access.dart';
import 'package:pemilu/components/konten_card.dart';
import 'package:pemilu/petugas/Input_konten_page.dart';
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

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime dateTime = DateTime.now();
  int tabIndex = 0;
  bool show = false;
  List<dynamic> dataKonten = [];
  String? token;
  bool loading = true;
  bool nullResponse = false;

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
        final length = responseData['data'].length;
        setState(() {
          loading = false;
          dataKonten = responseData['data'];
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
        print('Failed to load data from the API');
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

  Future<void> getDataInteraksis() async {
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
        setState(() {
          loading = false;
          dataKonten = responseData['data'];
        });

        print('test konten: ${responseData['data']}');
        print('test data konten: $dataKonten');
      } else {
        setState(() {
          loading = false;
        });
        // Handle error response
        print('Failed to load data from the API');
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Dashboard (Daily Activity)',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // card
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [Colors.blue, Colors.yellow],
                  stops: [0.9, 0.0],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(children: [
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Selamat ${dateTime.hour >= 01 && dateTime.hour <= 09 ? 'Pagi' : dateTime.hour > 09 && dateTime.hour < 15 ? 'Siang' : dateTime.hour >= 15 && dateTime.hour <= 19 ? 'Sore' : 'Malam'}',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          authState.namaUser ?? '',
                          style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        const Text(
                          'Relawan PATEN',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Pemuda Teman Gibran!',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            // menu
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VisiMisiPage(),
                          ),
                        );
                      },
                      child: EasyAccess(
                          path: 'assets/img/dashboard/laporBabinsa.png',
                          color: Colors.blue,
                          text: 'VISI MISI'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TpsPage(),
                          ),
                        );
                      },
                      child: EasyAccess(
                          path: 'assets/img/dashboard/tps.png',
                          color: Colors.blue,
                          text: 'TPS'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CandidatePage(),
                          ),
                        );
                      },
                      child: EasyAccess(
                          path: 'assets/img/dashboard/kandidat.png',
                          color: Colors.blue,
                          text: 'Suara'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InputFeedbackPage(
                              id: authState.userId.toString(),
                            ),
                          ),
                        );
                      },
                      child: EasyAccess(
                          path: 'assets/img/dashboard/feedback.png',
                          color: Colors.blue,
                          text: 'Aspirasi'),
                    ),
                  ],
                ),
              ],
            ),
            // Bagian 1:
            CarouselSection(),
            const SizedBox(
              height: 8,
            ),
            // Bagian 2:
            Container(
              child: Column(
                children: [
                  // menu
                  // Container(
                  //     padding: const EdgeInsets.all(16.0),
                  //     decoration: const BoxDecoration(
                  //       color: Color.fromRGBO(25, 25, 25, 1),
                  //     ),
                  //     child: ),
                  // content
                  Container(
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loading
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Belum ada konten',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: dataKonten.length,
                                      itemBuilder: (context, index) {
                                        return ContentCard(
                                          userId: authState.userId.toString(),
                                          id: dataKonten[index]['id']
                                              .toString(),
                                          imageUrl: dataKonten[index]['gambar'],
                                          caption: dataKonten[index]['judul'],
                                          // likes: dataKonten[index]
                                          //     ['jumlahLike'],
                                          // dislikes: dataKonten[index]
                                          //     ['jumlahDislike'],
                                          // comments: dataKonten[index]
                                          //     ['jumlahKomen'],
                                          likes: int.parse(
                                              dataKonten[index]['jumlahLike']),
                                          dislikes: int.parse(dataKonten[index]
                                              ['jumlahDislike']),
                                          comments: int.parse(
                                              dataKonten[index]['jumlahKomen']),
                                        );
                                      },
                                    ),
                                  ),
                        // const SizedBox(
                        //   height: 200,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
