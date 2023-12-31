import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pemilu/tahapan_pemilu_page.dart';

class KategoriPemiluPage extends StatelessWidget {
  // final List<String> dropdownValues = [
  //   'Wilayah A',
  //   'Wilayah B',
  //   'Wilayah C'
  // ];
  // final List<String> candidateNames = [
  //   'Prabowo',
  //   'Anies',
  //   'Ganjar'
  // ];

  Widget _buildGenderCard(
      IconData icon, String kelamin, String jumlah, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  kelamin,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  jumlah,
                  style: TextStyle(color: Colors.white),
                ),
                const Text(
                  'Orang',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori Pemilu'),
        backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card 1
            Card(
              elevation: 4.0,
              color: const Color.fromRGBO(44, 44, 44, 1),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Daftar Pemilih Tetap',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            'assets/img/kategoriPemilu/kategori.png', // Path gambar
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: Colors.red, // Background merah
                                padding: const EdgeInsets.all(5),
                                child: const Text(
                                  'Jumlah',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ), // Spasi antara judul dan jumlah
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '26.000',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'orang',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '120.000',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'TPS',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              '38',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Kabupaten/Kota',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '666',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Kecamatan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '8,494',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Kelurahan/Desa',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildGenderCard(
                                Icons.male, 'Laki-laki', '10,000', Colors.blue),
                            _buildGenderCard(Icons.female, 'Perempuan',
                                '10,000', Colors.pink),
                          ],
                        ),
                        SizedBox(height: 10), // Spasi antara baris

                        Container(
                          width: double
                              .infinity, // Lebar kontainer mengikuti layar
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.accessibility, color: Colors.white),
                              SizedBox(width: 20),
                              Text(
                                'Disabilitas 200 orang',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card 2 (Diagram Lingkaran)
            Card(
              color: const Color.fromRGBO(44, 44, 44, 1),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Usia Pemilih',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                          sections: List<PieChartSectionData>.generate(
                            5,
                            (index) {
                              final value = index * 500.0; //data usia pemilih
                              Color color;
                              switch (index) {
                                case 0:
                                  color = Colors.blue;
                                  break;
                                case 1:
                                  color = Colors.red;
                                  break;
                                case 2:
                                  color = Colors.green;
                                  break;
                                case 3:
                                  color = Colors.yellow;
                                  break;
                                case 4:
                                  color = Colors.orange;
                                  break;
                                default:
                                  color = Colors.blue;
                                  break;
                              }
                              return PieChartSectionData(
                                value: value,
                                color: color,
                                title: '${value.toInt()}',
                                radius: 80,
                              );
                            },
                          ),
                          sectionsSpace: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Card 3 (Diagram Batang Elektabilitas Capres)
            const Card(
              color: const Color.fromRGBO(44, 44, 44, 1),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Elektabilitas Capres',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    // Tambahkan implementasi diagram batang elektabilitas capres
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Card 4 (Diagram Batang Partisipasi Masyarakat)
            const Card(
              color: const Color.fromRGBO(44, 44, 44, 1),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Partisipasi Masyarakat',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    // Tambahkan implementasi diagram batang partisipasi masyarakat
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Card 5
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TahapanPemiluPage(),
                  ),
                );
              },
              child: Card(
                color: const Color.fromRGBO(44, 44, 44, 1),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/img/kategoriPemilu/tahapan.png', // Path gambar
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tahapan Pemilu',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                primary: const Color.fromRGBO(77, 109, 96, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Rincian Data Pemilu'),
            ),
          ],
        ),
      ),
    );
  }
}
