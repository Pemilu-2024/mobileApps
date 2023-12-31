import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:typed_data';

class VisiMisiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Visi Misi Prabowo-Gibran',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCard('Visi',
                      'Bersama Indonesia Maju\nMenuju Indonesia Emas 2045\n\n\n1. Bersama Prabowo dan Gibran mengajak Putra Putri Terbaik Bangsa dari semua latar belakang yang memiliki kesamaan tekad untuk bekerja sama\n\n2. Indonesia Maju: Membangun bangsa dengan dasar fondasi kuat yang dibangun oleh kepemimpinan Presiden Joko Widodo\n\n3. Menuju Indonesia Emas: Dengan tujuan yang jelas, yaitu Indonesia Emas, negara yang setara dengan negara maju di tahun 2045 atau lebih cepat'),
                  SizedBox(height: 16),
                  _buildCard('Misi', _buildMisiText(context)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _downloadPdf(context),
                    child: Text('Download PDF'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildCard(String title, String content) {
    return Card(
      color: Colors.blue,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  String _buildMisiText(BuildContext context) {
    return '''1. Memperkokoh ideologi Pancasila, demokrasi, dan hak asasi manusia (HAM).
\n2. Memantapkan sistem pertahanan keamanan negara dan mendorong kemandirian bangsa melalui swasembada pangan, energi, air, ekonomi kreatif, ekonomi hijau, dan ekonomi biru.
\n3. Meningkatkan lapangan kerja yang berkualitas, mendorong kewirausahaan, mengembangkan industri kreatif, dan melanjutkan pengembangan infrastruktur.
\n4. Memperkuat pembangunan sumber daya manusia (SDM), sains, teknologi, pendidikan, kesehatan, prestasi olahraga, kesetaraan gender, serta penguatan peran perempuan, pemuda, dan penyandang disabilitas.
\n5. Melanjutkan hilirisasi dan industrialisasi untuk meningkatkan nilai tambah di dalam negeri.
\n6. Membangun dari desa dan dari bawah untuk pemerataan ekonomi dan pemberantasan kemiskinan.
\n7. Memperkuat reformasi politik, hukum, dan birokrasi, serta memperkuat pencegahan dan pemberantasan korupsi dan narkoba.
\n8. Memperkuat penyelarasan kehidupan yang harmonis dengan lingkungan, alam, dan budaya, serta peningkatan toleransi antarumat beragama untuk mencapai masyarakat yang adil dan makmur.''';
  }

  Future<void> _downloadPdf(BuildContext context) async {
    const String pdfAssetPath = 'assets/img/visi_misi.pdf';

    try {
      final ByteData data = await rootBundle.load(pdfAssetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final File tempFile = File('$tempPath/visi_misi.pdf');

      await tempFile.writeAsBytes(bytes);

      if (await tempFile.exists()) {
        _launchPdf(context, tempFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Temporary file does not exist'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  void _launchPdf(BuildContext context, String path) async {
    if (await canLaunch(path)) {
      await launch(path, forceSafariVC: false, forceWebView: false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch PDF'),
        ),
      );
    }
  }
}
