import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pemilu/states/auth_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputKontenPage extends StatefulWidget {
  @override
  _InputKontenPageState createState() => _InputKontenPageState();
}

class _InputKontenPageState extends State<InputKontenPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? file = 'null';
  String? token;
  var picked;

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
    }
    print('tps token: $token');
  }

  Future<void> sendDataKonten(userId) async {
    try {
      String filePath = picked.files.first.path.toString();
      File file = File(filePath);

      var request = http.MultipartRequest('POST',
          Uri.parse('https://aaa.surabayawebtech.com/api/auth/create-konten'));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(http.MultipartFile(
          'gambar', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
      request.fields['judul'] = titleController.text.toString();
      request.fields['deskripsi'] = descriptionController.text.toString();
      request.fields['userId'] = userId.toString();

      var response = await request.send();
      if (response.statusCode == 200) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => TpsPage(),
        //   ),
        // );
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      // Tambahkan penanganan error sesuai kebutuhan
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
        title: const Text(
          'Input Konten',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Gambar Konten
            file == 'null'
                ? SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          picked = await FilePicker.platform.pickFiles();

                          if (picked != null && picked.files.isNotEmpty) {
                            setState(() {
                              file = picked.files.first.name.toString();
                            });
                            print(
                                'File yang diunggah: ${picked.files.first.name}');
                            // print(picked);
                            // print(file);
                          } else {
                            // print('Pemilihan file dibatalkan.');
                          }
                        } catch (e) {
                          // print('Terjadi kesalahan: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        primary: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('UPLOAD FILE'),
                    ),
                  )
                : Text(
                    'Document: ${file!}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
            const SizedBox(height: 16.0),

            // Input Judul
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Judul',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Input Deskripsi
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Button Submit
            ElevatedButton(
              onPressed: () {
                sendDataKonten(authState.userId);
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
