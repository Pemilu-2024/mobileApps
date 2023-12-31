import 'package:flutter/material.dart';
import 'package:pemilu/admin/Input_konten_page.dart';
import 'package:pemilu/components/easy_access.dart';
import 'package:pemilu/components/konten_card.dart';
import 'package:pemilu/admin/candidat_page.dart';
import 'package:pemilu/admin/kategori_pemilu_page.dart';
import 'package:pemilu/states/auth_state.dart';
import 'package:pemilu/admin/tps/tps_page.dart';
import 'package:pemilu/model/dataKonten.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime dateTime = DateTime.now();
  int tabIndex = 0;
  bool show = false;
  String? token;

  List<Map<String, dynamic>> ultahData = [];
  bool dataResponseUltah = false;
  bool loadingUltah = true;
  int _currentIndex = 0;

  List<Map<String, dynamic>> izinData = [];
  bool loadingIzin = true;
  bool dataResponseIzin = false;
  int _currentIndexIzin = 0;

  List<Map<String, dynamic>> dinasData = [];
  bool loadingDinas = true;
  bool dataResponseDinas = false;
  int _currentIndexDinas = 0;

  List<Map<String, dynamic>> cutiData = [];
  bool loadingCuti = true;
  bool dataResponseCuti = false;
  int _currentIndexCuti = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
        automaticallyImplyLeading: false,
        title: Text(
          'Admin ${token}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian 1:
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/img/dashboard/pragib.jpg',
                height: 200,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // Bagian 2:
            Container(
              child: Column(
                children: [
                  // menu
                  Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(25, 25, 25, 1),
                      ),
                      child: Column(
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
                                      builder: (context) =>
                                          KategoriPemiluPage(),
                                    ),
                                  );
                                },
                                child: EasyAccess(
                                    path: 'assets/img/dashboard/category.png',
                                    color: Colors.black,
                                    text: 'Kategori Pemilu'),
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
                                    color: Colors.black,
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
                                    color: Colors.black,
                                    text: 'Kandidat'),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InputKontenPage(),
                                    ),
                                  );
                                },
                                child: EasyAccess(
                                    path: 'assets/img/dashboard/air.png',
                                    color: Colors.black,
                                    text: 'Konten'),
                              ),
                            ],
                          ),
                        ],
                      )),
                  // content
                  Container(
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: dataKonten.length,
                            itemBuilder: (context, index) {
                              return ContentCard(
                                userId: authState.userId.toString(),
                                id: dataKonten[index].id,
                                imageUrl: dataKonten[index].imageUrl,
                                caption: dataKonten[index].caption,
                                likes: dataKonten[index].likes,
                                dislikes: dataKonten[index].dislikes,
                                comments: dataKonten[index].comments,
                              );
                            },
                          ),
                        )
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
