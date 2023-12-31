import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pemilu/petugas/menu.dart';
import 'package:pemilu/petugas/tps/tps_page.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class InputFeedbackPage extends StatefulWidget {
  final String id;

  InputFeedbackPage({Key? key, required this.id}) : super(key: key);

  @override
  _InputFeedbackPageState createState() => _InputFeedbackPageState();
}

class _InputFeedbackPageState extends State<InputFeedbackPage> {
  String? token;
  bool loading = false;

  TextEditingController aspirasiController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  double kepuasan = 0;
  TextEditingController namaController = TextEditingController();
  String selectedAspirasi = 'Kesehatan';

  List<String> aspirasiList = [
    'Kesehatan',
    'Pendidikan',
    'Infrastruktur',
    'Birokrasi',
    'Hukum',
    'Kepolisian',
    'Pertahanan dan Keamanan',
    'Ketenagakerjaan',
    'Kependudukan',
    'Ekonomi',
    'Sosial',
    'Budaya',
    'HAM',
    'Agama',
    'Sumber Daya Alam',
    'Teknologi',
  ];

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
      // fetchDataFromApi();
    }
    print('tps token: $token');
  }

  Future<void> _submitData() async {
    try {
      // const String apiUrl = 'http://localhost:8000/api/auth/create-feedback';
      const String apiUrl =
          'https://aaa.surabayawebtech.com/api/auth/create-feedback';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'rating': kepuasan.toString(),
          'nama': namaController.text.toString(),
          'alamat': alamatController.text.toString(),
          'aspirasi': aspirasiController.text.toString(),
          'userId': widget.id.toString(),
        },
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('berhasil: $responseData');
        setState(() {
          loading = true;
        });
        await _showDialog('Request Berhasil', 'Feedback anda berhasil dikirim');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPetugas(),
          ),
        );
      } else {
        _showDialog('Request Gagal', 'Gagal mengirimkan feedback');
        setState(() {
          loading = false;
        });
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      _showDialog(
          'Koneksi Gagal', 'Periksa koneksi internet anda, lalu coba lagi');
      setState(() {
        loading = false;
      });
      print('Error: $e');
      // Tambahkan penanganan error sesuai kebutuhan
    }
  }

  Future<void> _showDialog(title, message) async {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Form Aspirasi',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: Colors.white,
      body: loading
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // nama
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    controller: namaController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // alamat
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    controller: alamatController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  // jenis aspirasi
                  DropdownButtonFormField<String>(
                    value: selectedAspirasi,
                    items: aspirasiList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAspirasi = newValue!;
                      });
                    },
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Aspirasi',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue), // Set border color to blue
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Set focused border color to blue
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Aspirasi yang dipilih: $selectedAspirasi'),

                  // Container(
                  //   color: Colors.blue,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 10),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             const Text(
                  //               'Rating',
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.white),
                  //             ),
                  //             const SizedBox(
                  //               height: 10,
                  //             ),
                  //             RatingBar.builder(
                  //               initialRating: kepuasan,
                  //               minRating: 1,
                  //               direction: Axis.horizontal,
                  //               allowHalfRating: false,
                  //               itemCount: 5,
                  //               itemSize: 50,
                  //               itemBuilder: (context, _) => const Icon(
                  //                 Icons.star,
                  //                 color: Colors.amber,
                  //               ),
                  //               onRatingUpdate: (rating) {
                  //                 setState(() {
                  //                   kepuasan = rating;
                  //                 });
                  //               },
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),

                  // aspirasi
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: aspirasiController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Aspirasi',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _submitData();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      primary: const Color.fromRGBO(77, 109, 96, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
    );
  }
}
