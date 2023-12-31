import 'package:flutter/material.dart';

class InputSuaraPage extends StatefulWidget {
  @override
  _InputSuaraPageState createState() => _InputSuaraPageState();
}

class _InputSuaraPageState extends State<InputSuaraPage> {
  List<String> dataText = [
    '01 Anis Baswedan & Muhaimin Iskandar',
    '02 Prabowo Subianto & Gibran Rakabuming R',
    '03 Ganjar Pranowo & Mahfud MD',
  ];

  List<TextEditingController> suaraControllers = [];

  @override
  void initState() {
    super.initState();
    suaraControllers =
        List.generate(dataText.length, (index) => TextEditingController());
  }

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
              'Input TPS',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
                        color: const Color.fromRGBO(44, 44, 44, 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        dataText[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Input Jumlah Suara',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Set border color to white
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .white), // Set focused border color to white
                        ),
                      ),
                      controller: suaraControllers[index],
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Lakukan sesuatu ketika tombol ditekan
                // Misalnya: Mengambil nilai dari TextFormField
                for (var controller in suaraControllers) {
                  print(controller.text);
                }
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
}
