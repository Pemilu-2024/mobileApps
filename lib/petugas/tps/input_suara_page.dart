import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pemilu/petugas/candidat_page.dart';
import 'package:pemilu/petugas/dashboard_page.dart';
import 'package:pemilu/petugas/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputSuaraPage extends StatefulWidget {
  final String id;

  InputSuaraPage({Key? key, required this.id}) : super(key: key);

  @override
  _InputSuaraPageState createState() => _InputSuaraPageState();
}

class _InputSuaraPageState extends State<InputSuaraPage> {
  List<String> dataText = [
    '01 Anis Baswedan & Muhaimin Iskandar',
    '02 Prabowo Subianto & Gibran Rakabuming R',
    '03 Ganjar Pranowo & Mahfud MD',
    'Suara Tidak Sah',
  ];

  List<TextEditingController> suaraControllers = [];
  String? token;
  File? imageFile = null;
  bool loading = false;
  bool valid = false;

  @override
  void initState() {
    super.initState();
    suaraControllers =
        List.generate(dataText.length, (index) => TextEditingController());
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

  Future<void> sendSuaraKandidat() async {
    try {
      final List<Map<String, dynamic>> suaraData = List.generate(
        dataText.length,
        (index) => {
          "jumlahSuara": int.parse(suaraControllers[index].text),
          "tpsId": int.parse(widget.id),
          "kandidatId": (index + 1),
        },
      );

      if (imageFile != null) {
        final bytes = await imageFile!.readAsBytes();
        final String base64Image = base64Encode(Uint8List.fromList(bytes));
        suaraData.add({
          "bukti_suara": base64Image,
        });
      }

      final response = await http.post(
        Uri.parse('https://aaa.surabayawebtech.com/api/auth/input-suara'),
        body: jsonEncode({"data": suaraData}),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('suara data $suaraData');
      print('response ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('test response suara: $responseData');
        setState(() {
          loading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPetugas(),
          ),
        );
      } else {
        setState(() {
          loading = false;
        });
        // Handle error response
        _showErrorDialog('Request Gagal',
            'Gagal mengirimkan data suara, silakan coba kembali');
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      print('error: $e');
      // Handle and show error message
      _showErrorDialog(
          'Koneksi Gagal', 'Periksa koneksi Anda, lalu coba kembali');
    } finally {
      setState(() {
        loading = false;
      });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Input Suara',
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataText.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: index == 0 || index == 2
                                  ? const Color.fromRGBO(44, 44, 44, 1)
                                  : index == 1
                                      ? Colors.blue
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              dataText[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              labelText: 'Input Jumlah Suara',
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            controller: suaraControllers[index],
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  imageFile != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (imageFile != null)
                              Image.file(
                                imageFile!,
                                height: 200,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                          ],
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _getImageFromCamera();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              primary: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.camera),
                            label: const Text(
                              'Ambil gambar',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      sendSuaraKandidat();
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

  void _getImageFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        valid = true;
      });
    }
  }
}
