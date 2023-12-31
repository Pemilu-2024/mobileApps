import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pemilu/petugas/tps/input_suara_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CandidatePage extends StatefulWidget {
  @override
  _CandidatePageState createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  List<Map<String, dynamic>> suaraData = [];
  String? token;
  int total = 0;
  int suaraRusak = 0;
  int suaraMasuk = 0;
  bool loading = true;
  int length = 0;

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
    print('tps token: $token');
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        // Uri.parse('http://localhost:8000/api/auth/list-suara'),
        Uri.parse('https://aaa.surabayawebtech.com/api/auth/list-suara'),
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        suaraData = List<Map<String, dynamic>>.from(responseData['data']);

        setState(() {
          length = suaraData.length;
        });
        print('length: $length');

        if (length == 4) {
          setState(() {
            suaraRusak = int.parse(suaraData[3]['totalSuara']);
          });
        }
        // Setelah mendapatkan data, memperbarui tampilan
        setState(() {
          loading = false;
          for (int i = 0; i < length - 1; i++) {
            total += int.parse(suaraData[i]['totalSuara']);
          }

          suaraMasuk = total + suaraRusak;
        });
        print('test suara: $suaraData');
      } else {
        // Handle error response
      }
    } catch (e) {
      print('error: $e');
      // Handle and show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Perolehan Suara',
          style: TextStyle(fontSize: 20),
        ),
      ),
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
          : ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                buildCandidateCard('Anies Baswedam', 'Muhaimin Iskandar',
                    'assets/img/kandidat/amin.png', 0),
                SizedBox(height: 16.0),
                buildCandidateCard('Prabowo Subianti', 'Gibran Rakabuming R',
                    'assets/img/kandidat/pragib.png', 1),
                SizedBox(height: 16.0),
                buildCandidateCard('Ganjar Pranowo', 'Mahfud MD',
                    'assets/img/kandidat/gama.png', 2),
                SizedBox(height: 16.0),
                buildVoteStatusCard(),
                const SizedBox(height: 20),
              ],
            ),
      backgroundColor: Colors.white,
    );
  }

  Widget buildCandidateCard(
      String capres, String cawapres, String imagePath, int index) {
    return Card(
      elevation: 4.0,
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calon Presiden',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      capres,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const Text(
                      'Calon Wakil Presiden',
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      cawapres,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // Menempatkan widget di ujung kiri dan kanan
              children: [
                Text(
                  'Total Suara',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  length <= 1 ? '0' : suaraData[index]['totalSuara'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVoteStatusCard() {
    return Card(
      elevation: 4.0,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildVoteStatusRow('Suara Masuk', suaraMasuk),
            const SizedBox(
              height: 10,
            ),
            const Divider(color: Colors.white),
            buildVoteStatusRow('Suara Sah', total),
            const SizedBox(
              height: 10,
            ),
            const Divider(color: Colors.white),
            buildVoteStatusRow('Suara Rusak', suaraRusak),
          ],
        ),
      ),
    );
  }

  Widget buildVoteStatusRow(String title, int votes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          votes.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
