import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../DataAccess/Dataaccess.dart';
import '../../Style/styleapp.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Favorit extends StatefulWidget {
  static String routeName = '/login';
  const Favorit({super.key});

  @override
  State<Favorit> createState() => _FavoritState();
}

class _FavoritState extends State<Favorit> {
  late List<Map> teksUI;
  late DatabaseHelper dbHelper;
  late List<Map<String, dynamic>> favourites;
  late List<Map<String, dynamic>> characters = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _loadFavourites();
    teksUI = [
      {
        'Header': 'Informasi Aplikasi',
        'id': 'ID Gambar: ',
        'name': 'Nama Karakter: ',
        'image': 'URL gambar: ',

        'HeaderWarning2': 'Keluar dari Aplikasi?',
        'DescriptionWarning2': 'Tekan "Keluar" untuk menutup aplikasi'
      }
    ].cast<Map<String, String>>();
  }

  Future<void> _loadFavourites() async {
    List<Map<String, dynamic>> results = await dbHelper.getAllFavourites();
    setState(() {
      favourites = results;
      teksUI = favourites.map((fav) {
        return {
          'Header': 'Data Favorit',
          'id': 'ID Gambar: ${fav['id']}',
          'name': 'Nama Karakter: ${fav['name']}',
          'image': 'URL gambar: ${fav['image']}',
          'HeaderWarning2': 'Keluar dari Aplikasi?',
          'DescriptionWarning2': 'Tekan "Keluar" untuk menutup aplikasi'
        };
      }).toList();
    });
  }


  Future<void> getCharacterData() async {
    final response = await http.get(Uri.parse("https://rickandmortyapi.com/api/character/$favourites"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      setState(() {
        characters = results.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load character data');
    }
  }

  // Kode untuk desain UI-nya
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          await _onBackPressed(context);
          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final teks in teksUI)
                    Column(
                      children: [
                        const SizedBox(height: 20,),
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                colors: [Colors.red, Colors.deepPurple],
                              ).createShader(bounds);
                            },
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              text: TextSpan(
                                text: teks['Header'],
                                style: StyleApp.extraLargeTextStyle.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(teks['id'],
                                style: StyleApp.mediumTextStyle.copyWith(
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(teks['name'],
                                style: StyleApp.mediumTextStyle.copyWith(
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(teks['image'],
                                style: StyleApp.mediumTextStyle.copyWith(
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onBackPressed(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        for (final teks in teksUI) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(16.0),
            children: [
              Text(teks['HeaderWarning2'],
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: StyleApp.mediumTextStyle.copyWith(
                    fontWeight: FontWeight.bold
                ),
              ),
              const Icon(Icons.warning, color: Colors.red),
              const SizedBox(height: 10,),
              Text(teks['DescriptionWarning2'],
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: StyleApp.smallTextStyle.copyWith(
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _performExitAction();
                      },
                      child: const Text('Keluar'),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  void _performExitAction() {
    SystemNavigator.pop();
  }
}