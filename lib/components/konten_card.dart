import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pemilu/petugas/dashboard_page.dart';
import 'package:pemilu/components/komen_petugas.dart';
import 'package:pemilu/petugas/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentCard extends StatefulWidget {
  final String userId;
  final String id;
  final String imageUrl;
  final String caption;
  final int likes;
  final int dislikes;
  final int comments;

  const ContentCard({
    required this.userId,
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.dislikes,
    required this.comments,
  });

  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  late String token;
  late bool loading;
  bool isLikeContent = false;

  @override
  void initState() {
    super.initState();
    loading = false;
    getTokenFromSharedPreferences();
  }

  Future<void> getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') != null) {
      setState(() {
        token = prefs.getString('token')!;
      });
    }
    isLike();
  }

  Future<void> sendLike() async {
    try {
      String apiUrl =
          // 'http://localhost:8000/api/auth/reaksi-konten/${widget.id}';
          'https://aaa.surabayawebtech.com/api/auth/reaksi-konten/${widget.id}';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'userId': widget.userId, 'reaksi': '1'}),
      );

      if (response.statusCode == 200) {
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
        _showErrorDialog(
            'Gagal', 'Gagal tidak menyukai konten, silahkan coba kembali');
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('Error Koneksi',
          'Gagal tidak menyukai konten, periksa koneksi internet anda');
    }
  }

  Future<void> isLike() async {
    try {
      final response = await http.post(
        // Uri.parse('http://localhost:8000/api/auth/login'),
        Uri.parse('https://aaa.surabayawebtech.com/api/auth/islike'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'userId': widget.userId.toString(),
          'kontenId': widget.id.toString(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status']) {
          setState(() {
            isLikeContent = true;
          });
        }
      } else {}
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendDislike() async {
    try {
      String apiUrl =
          // 'http://localhost:8000/api/auth/reaksi-konten/${widget.id}';
          'https://aaa.surabayawebtech.com/api/auth/reaksi-konten/${widget.id}';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'userId': widget.userId, 'reaksi': '0'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        // Tambahkan logika jika perlu memuat ulang data atau menampilkan pesan sukses
        print('Dislike Berhasil');
      } else {
        setState(() {
          loading = false;
        });
        _showErrorDialog(
            'Gagal', 'Gagal tidak menyukai konten, silahkan coba kembali');
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('Error Koneksi',
          'Gagal tidak menyukai konten, periksa koneksi internet anda');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      margin: const EdgeInsets.all(16.0),
      elevation: 5.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto
          Image.network(
            'https://aaa.surabayawebtech.com/storage/konten/${widget.imageUrl}',
            width: double.infinity,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          // Caption
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.caption,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Jumlah Like dan Komen
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      child: Icon(
                        Icons.favorite,
                        color: isLikeContent ? Colors.red : Colors.white,
                      ),
                      onTap: () {
                        if (!loading) {
                          setState(() {
                            loading = true;
                          });
                          sendLike();
                        }
                      },
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Likes: ${widget.likes}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      child: const Icon(
                        Icons.comment,
                        color: Colors.white,
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          builder: (BuildContext context) {
                            return KomenPetugas(kontenId: widget.id);
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      'Comments: ${widget.comments}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
