import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pemilu/admin/tps/input_tps_page.dart';
import 'package:pemilu/admin/tps/pemilu_page.dart';
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

  Future<void> fetchDataFromApi() async {
    try {
      print('test api token $token');
      const String apiUrl = 'http://localhost:8000/api/auth/list-tps';
      // const String token =
      //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3Q6ODAwMFwvYXBpXC9hdXRoXC9sb2dpbiIsImlhdCI6MTcwMjcyOTQ3MiwiZXhwIjoxNzAyNzMzMDcyLCJuYmYiOjE3MDI3Mjk0NzIsImp0aSI6ImlWRktRZUFYdTRMRVVtdVoiLCJzdWIiOjEsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjciLCJpZCI6MSwibmFtZSI6bnVsbCwiZW1haWwiOiJiYWd1c3VudG9ybzE4QGdtYWlsLmNvbSJ9.5oAO-anzipkjKLTNYti9QWDgPhTstjuEswpIUYyrIOo';

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

        tpsData = List<Map<String, String>>.from(
          data.map((dynamic item) {
            return {
              'namaTps': item['nama'].toString(),
              'kabupaten': item['kota'].toString(),
              'kecamatan': item['kecamatan'].toString(),
              'desa': item['desa'].toString(),
            };
          }),
        );

        setState(() {
          filteredTpsData = tpsData;
        });
        print('test data: $tpsData');
      } else {
        // Handle error response
        print('Failed to load data from the API');
      }
    } catch (e) {
      // Handle exception
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
    BuildContext context,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: const Color.fromRGBO(44, 44, 44, 1),
      elevation: 4.0,
      child: ListTile(
        title: Text(
          namaTps,
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
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PemiluPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
        title: const Text('TPS'),
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
                              filteredTpsData = tpsData;
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
                  filterTpsData(value);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTpsData.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildTpsCard(
                    filteredTpsData[index]['namaTps']!,
                    filteredTpsData[index]['kabupaten']!,
                    filteredTpsData[index]['kecamatan']!,
                    filteredTpsData[index]['desa']!,
                    context,
                  );
                },
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InputTpsPage(),
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
            ),
          ],
        ),
      ),
    );
  }
}
