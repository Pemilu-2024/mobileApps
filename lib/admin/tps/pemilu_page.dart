import 'package:flutter/material.dart';
import 'package:pemilu/admin/candidat_page.dart';

void main() {
  runApp(MaterialApp(
    home: PemiluPage(),
  ));
}

class PemiluPage extends StatelessWidget {
  final List<Map<String, dynamic>> cardsData = [
    {
      'icon': Icons.how_to_vote,
      'text': 'PRESIDEN',
    },
    {
      'icon': Icons.how_to_vote,
      'text': 'GUBERNUR',
    },
    {
      'icon': Icons.how_to_vote,
      'text': 'BUPATI/WALIKOTA',
    },
    // Add other card data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
        title: Row(
          children: [
            Image.asset(
              'assets/img/logo.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Pemilu',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white),
                const SizedBox(width: 8),
                const Text(
                  'TPS 01',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: cardsData.length,
              itemBuilder: (BuildContext context, int index) {
                return buildCard(cardsData[index], context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Map<String, dynamic> cardData, BuildContext context) {
    return Card(
      elevation: 4.0,
      color: const Color.fromRGBO(25, 25, 25, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            cardData['icon'],
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            cardData['text'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CandidatePage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: const Color.fromRGBO(77, 109, 96, 1),
            ),
            child: const Text('Detail'),
          ),
        ],
      ),
    );
  }
}
