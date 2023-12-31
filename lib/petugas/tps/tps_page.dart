import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pemilu/petugas/tps/input_suara_page.dart';
import 'package:pemilu/petugas/candidat_page.dart';
import 'package:pemilu/petugas/tps/input_tps_page.dart';
import 'package:pemilu/petugas/tps/pemilu_page.dart';
import 'package:pemilu/states/auth_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TpsPage extends StatefulWidget {
  @override
  _TpsPageState createState() => _TpsPageState();
}

class _TpsPageState extends State<TpsPage> {
  List<Map<String, String>> tpsData = [];
  List<Map<String, String>> filteredTpsData = [];
  TextEditingController searchController = TextEditingController();
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
      fetchDataFromApi();
    }
    print('tps token: $token');
  }

  Future<void> fetchDataFromApi() async {
    try {
      // const String apiUrl = 'http://localhost:8000/api/auth/list-tps';
      const String apiUrl = 'https://aaa.surabayawebtech.com/api/auth/list-tps';

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
        final length = responseData['data'].length;

        tpsData = List<Map<String, String>>.from(
          data.map((dynamic item) {
            return {
              'id': item['id'].toString(),
              'namaTps': item['nama'].toString(),
              'kabupaten': item['kota'].toString(),
              'kecamatan': item['kecamatan'].toString(),
              'desa': item['desa'].toString(),
              'status': item['status'].toString(),
            };
          }),
        );

        setState(() {
          loading = false;
          filteredTpsData = tpsData;
          if (length != 0) {
            nullResponse = false;
          } else {
            nullResponse = true;
          }
        });
        print('test tps data: $tpsData');
      } else {
        // Handle error response
        _showErrorDialog('Request Gagal', 'Gagal menampilkan data TPS');
        setState(() {
          loading = false;
        });
        print('Failed to load data from the API');
      }
    } catch (e) {
      // Handle exception
      _showErrorDialog(
          'Koneksi Gagal', 'Ada masalah dengan koneksi internet anda');
      setState(() {
        loading = false;
      });
      print('Error Api: $e');
    }
  }

  void filterTpsData(String query) {
    List<Map<String, String>> filteredList = tpsData.where((tps) {
      String namaTps = tps['namaTps']!.toLowerCase();
      String kabupaten = tps['kabupaten']!.toLowerCase();
      String kecamatan = tps['kecamatan']!.toLowerCase();
      String desa = tps['desa']!.toLowerCase();

      return namaTps.contains(query.toLowerCase()) ||
          kabupaten.contains(query.toLowerCase()) ||
          kecamatan.contains(query.toLowerCase()) ||
          desa.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredTpsData = filteredList;
    });
  }

  Widget buildTpsCard(
    String namaTps,
    String kabupaten,
    String kecamatan,
    String desa,
    String id,
    String status,
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.blue,
      elevation: 4.0,
      child: ListTile(
        title: Text(
          'TPS: $namaTps',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kabupaten: $kabupaten',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              'Kecamatan: $kecamatan',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              'Desa: $desa',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            status == '0' ? Icons.arrow_forward : Icons.verified_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            status == '0'
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputSuaraPage(
                        id: id,
                      ),
                    ),
                  )
                : null;
          },
        ),
      ),
    );
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
        title: const Text('TPS'),
      ),
      backgroundColor: Colors.white,
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
                              filteredTpsData = tpsData;
                            });
                          },
                        )
                      : const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                  filled: true,
                  fillColor: Colors.blue,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
                controller: searchController,
                onChanged: (value) {
                  filterTpsData(value);
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
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  )
                : nullResponse
                    ? Expanded(
                        child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Belum ada data TPS',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredTpsData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildTpsCard(
                              filteredTpsData[index]['namaTps']!,
                              filteredTpsData[index]['kabupaten']!,
                              filteredTpsData[index]['kecamatan']!,
                              filteredTpsData[index]['desa']!,
                              filteredTpsData[index]['id']!,
                              filteredTpsData[index]['status']!,
                              context,
                            );
                          },
                        ),
                      ),
            Align(
              alignment: Alignment.bottomCenter,
              child: loading
                  ? null
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InputTpsPage(
                                id: authState.userId.toString(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          primary: const Color.fromRGBO(77, 109, 96, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Tambah TPS'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
