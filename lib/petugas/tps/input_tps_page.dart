import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pemilu/petugas/tps/tps_page.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputTpsPage extends StatefulWidget {
  final String id;

  InputTpsPage({Key? key, required this.id}) : super(key: key);

  @override
  _InputTpsPageState createState() => _InputTpsPageState();
}

class _InputTpsPageState extends State<InputTpsPage> {
  String selectedProvince = '';
  String selectedCity = '';
  String selectedDistrict = '';
  String selectedVillage = '';
  String namaProvince = '';
  String namaCity = '';
  String namaDistrict = '';
  String namaVillage = '';
  String? token;
  bool loading = false;

  TextEditingController tpsNameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> districts = [];
  List<Map<String, dynamic>> villages = [];

  @override
  void initState() {
    super.initState();
    loadProvinces();
    _getKoordinat();
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

  Future<void> _submitDataTps(String namaTps, String provinsi, String kota,
      String kecamatan, String desa, String koordinat) async {
    try {
      // const String apiUrl = 'http://localhost:8000/api/auth/create-tps';
      const String apiUrl =
      'https://aaa.surabayawebtech.com/api/auth/create-tps';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'nama': namaTps,
          'provinsi': provinsi,
          'kota': kota,
          'kecamatan': kecamatan,
          'desa': desa,
          'koordinat': koordinat,
          'userId': widget.id,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          loading = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TpsPage(),
          ),
        );
      } else {
        _showErrorDialog('Request Gagal', 'Gagal menambahkan TPS');
        setState(() {
          loading = false;
        });
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog(
          'Koneksi Gagal', 'Periksa koneksi internet anda, lalu coba lagi');
      setState(() {
        loading = false;
      });
      print('Error: $e');
      // Tambahkan penanganan error sesuai kebutuhan
    }
  }

  Future<void> _getKoordinat() async {
    try {
      final location = Location();

      if (await location.hasPermission() != PermissionStatus.granted) {
        final PermissionStatus permissionStatus =
            await location.requestPermission();

        if (permissionStatus != PermissionStatus.granted) {
          print("Izin lokasi tidak diberikan");
          return;
        }
      }

      final LocationData locationData = await location.getLocation();

      latitudeController.text = locationData.latitude.toString();
      longitudeController.text = locationData.longitude.toString();

      print("Lokasi: ${locationData.latitude}, ${locationData.longitude}");
    } catch (e) {
      print("Error saat mengambil lokasi: $e");
    }
  }

  Future<void> loadProvinces() async {
    var response = await http.get(Uri.parse(
        'https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json'));

    if (response.statusCode == 200) {
      setState(() {
        provinces = List<Map<String, dynamic>>.from(json.decode(response.body));
        selectedProvince = provinces[0]['id'];
      });
      loadCitiesByProvince(int.parse(selectedProvince));
    }
  }

  Future<void> loadCitiesByProvince(int provinceId) async {
    var response = await http.get(Uri.parse(
        'https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json'));

    if (response.statusCode == 200) {
      setState(() {
        cities = List<Map<String, dynamic>>.from(json.decode(response.body));
        selectedCity = cities[0]['id'];
      });
      loadDistrictsByCity(int.parse(selectedCity));
    }
  }

  Future<void> loadDistrictsByCity(int cityId) async {
    var response = await http.get(Uri.parse(
        'https://www.emsifa.com/api-wilayah-indonesia/api/districts/$cityId.json'));

    if (response.statusCode == 200) {
      setState(() {
        districts = List<Map<String, dynamic>>.from(json.decode(response.body));
        selectedDistrict = districts[0]['id'];
      });
      loadVillagesByDistrict(int.parse(selectedDistrict));
    }
  }

  Future<void> loadVillagesByDistrict(int districtId) async {
    var response = await http.get(Uri.parse(
        'https://www.emsifa.com/api-wilayah-indonesia/api/villages/$districtId.json'));

    if (response.statusCode == 200) {
      setState(() {
        villages = List<Map<String, dynamic>>.from(json.decode(response.body));
        selectedVillage = villages[0]['id'];
      });
    }
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
    print(provinces);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Input TPS',
          style: TextStyle(fontSize: 20),
        ),
      ),
      backgroundColor: Colors.white,
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Nama TPS',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Set border color to white
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Set focused border color to white
                      ),
                    ),
                    controller: tpsNameController,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedProvince,
                    items: provinces.map((Map<String, dynamic> province) {
                      final String id = province['id'].toString();
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(province['name'] as String,
                            style: const TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedProvince = newValue!;
                        for (var item in provinces) {
                          if (item['id'] == newValue) {
                            namaProvince = item['name'];
                          }
                        }
                      });
                      loadCitiesByProvince(int.parse(selectedProvince));
                    },
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Provinsi',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue), // Set border color to blue
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Set focused border color to blue
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // kota
                  DropdownButtonFormField<String>(
                    value: selectedCity,
                    items: cities.map((Map<String, dynamic> city) {
                      final String id = city['id'].toString();
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(city['name'] as String,
                            style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCity = newValue!;
                        for (var item in cities) {
                          if (item['id'] == newValue) {
                            namaCity = item['name'];
                          }
                        }
                      });
                      loadDistrictsByCity(int.parse(selectedCity));
                    },
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Kota',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue), // Set border color to blue
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Set focused border color to blue
                      ),
                    ),
                  ),

                  // provinsi
                  DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    items: districts.map((Map<String, dynamic> district) {
                      final String id = district['id'].toString();
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(district['name'] as String,
                            style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDistrict = newValue!;
                        for (var item in districts) {
                          if (item['id'] == newValue) {
                            namaDistrict = item['name'];
                          }
                        }
                      });
                      loadVillagesByDistrict(int.parse(selectedDistrict));
                    },
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Kecamatan',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue), // Set border color to blue
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Set focused border color to blue
                      ),
                    ),
                  ),

                  // desa
                  DropdownButtonFormField<String>(
                    value: selectedVillage,
                    items: villages.map((Map<String, dynamic> village) {
                      final String id = village['id'].toString();
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(village['name'] as String,
                            style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedVillage = newValue!;
                        for (var item in villages) {
                          if (item['id'] == newValue) {
                            namaVillage = item['name'];
                          }
                        }
                      });
                      // loadVillagesByDistrict(int.parse(selectedDistrict));
                    },
                    dropdownColor: Colors.white,
                    decoration: const InputDecoration(
                      labelText: 'Desa',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue), // Set border color to blue
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Set focused border color to blue
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Latitude',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Colors.blue), // Set border color to blue
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .blue), // Set focused border color to blue
                            ),
                          ),
                          controller: latitudeController,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Longitude',
                            labelStyle: TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Colors.blue), // Set border color to blue
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .blue), // Set focused border color to blue
                            ),
                          ),
                          controller: longitudeController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      _submitDataTps(
                          tpsNameController.text.toString(),
                          namaProvince,
                          namaCity,
                          namaDistrict,
                          namaVillage,
                          '${latitudeController.text.toString()},${longitudeController.text.toString()}');
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

  Widget buildDropdownButton(
    String label,
    List<String> items,
    String selectedItem,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: Colors.blue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white), // Set border color to white
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white), // Set focused border color to white
        ),
      ),
    );
  }
}
