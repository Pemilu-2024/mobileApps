import 'package:flutter/material.dart';
import 'package:pemilu/admin/tps/input_suara_page.dart';

class CandidatePage extends StatelessWidget {
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
              'Kandidat',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          buildCandidateCard(
            'Anies Baswedam',
            'Muhaimin Iskandar',
            'assets/img/kandidat/amin.png',
          ),
          SizedBox(height: 16.0),
          buildCandidateCard(
            'Prabowo Subianti',
            'Gibran Rakabuming R',
            'assets/img/kandidat/pragib.png',
          ),
          SizedBox(height: 16.0),
          buildCandidateCard(
            'Ganjar Pranowo',
            'Mahfud MD',
            'assets/img/kandidat/gama.png',
          ),
          SizedBox(height: 16.0),
          buildVoteStatusCard(350, 25, 325),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputSuaraPage(),
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
            child: const Text('Input Jumlah Suara'),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget buildCandidateCard(String capres, String cawapres, String imagePath) {
    return Card(
      elevation: 4.0,
      color: const Color.fromRGBO(44, 44, 44, 1),
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
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Suara',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildVoteStatusCard(int validVotes, int invalidVotes, int totalVotes) {
    return Card(
      elevation: 4.0,
      color: const Color.fromRGBO(44, 44, 44, 1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildVoteStatusRow('Suara Masuk', totalVotes),
            const SizedBox(
              height: 10,
            ),
            const Divider(color: Colors.white),
            buildVoteStatusRow('Suara Sah', validVotes),
            const SizedBox(
              height: 10,
            ),
            const Divider(color: Colors.white),
            buildVoteStatusRow('Suara Rusak', invalidVotes),
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
