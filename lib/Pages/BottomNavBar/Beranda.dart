import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Style/styleapp.dart';
import '../DetailKarakter.dart';

class Beranda extends StatefulWidget {
  static String routeName = '/beranda';

  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  late String dataNameReceive = "BIGIO";
  late Future<void> _fetchData;
  late List<Map> teksUI;
  late List<Map<String, dynamic>> characters = [];
  late List<Map<String, dynamic>> originalCharacters;

  @override
  void initState() {
    super.initState();
    loadDataName();
    teksUI = [
      {
        'Header': 'Halo, $dataNameReceive',
        'SubHeader': 'Daftar Karakter Rick and Morty',
        'searchhint': 'Cari berdasarkan nama atau spesies',

        'HeaderWarning2': 'Konfirmasi Keluar',
        'DescriptionWarning2': 'Perubahan yang anda lakukan, tidak akan disimpan!'
      }
    ].cast<Map<String, String>>();
  }

  final TextEditingController karakterController = TextEditingController();

  Future<void> loadDataName() async {
    SharedPreferences usernamedata = await SharedPreferences.getInstance();
    String savedName = usernamedata.getString('username') ?? "BIGIO";
    setState(() {
      dataNameReceive = savedName;
    });

    _fetchData = _fetchCharacterData();
    _fetchCharacterData();
  }

  Future<void> _fetchCharacterData() async {
    final response = await http.get(Uri.parse("https://rickandmortyapi.com/api/character"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      setState(() {
        characters = results.cast<Map<String, dynamic>>();
        originalCharacters = List.from(characters);
      });
    } else {
      throw Exception('Failed to load character data');
    }
  }

  void _filterCharacters(String query) {
    if (query.isEmpty) {
      _resetCharacterData();
      return;
    }

    List<Map<String, dynamic>> filteredList = characters.where((character) {
      final String name = character['name'].toLowerCase();
      final String status = character['status'].toLowerCase();
      final String species = character['species'].toLowerCase();
      final String gender = character['gender'].toLowerCase();
      final String created = character['created'].toLowerCase();
      final String searchQuery = query.toLowerCase();

      return name.contains(searchQuery) ||
          status.contains(searchQuery) ||
          species.contains(searchQuery) ||
          gender.contains(searchQuery) ||
          created.contains(searchQuery);
    }).toList();

    _resetCharacterData();
    setState(() {
      characters = filteredList;
    });
  }

  void _resetCharacterData() {
    setState(() {
      characters = List.from(originalCharacters);
    });
  }

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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                for (final teks in teksUI)
                  Column(
                    children: [
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [Colors.green, Colors.green],
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
                      Container(
                        margin: const EdgeInsets.all(2),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade400)
                        ),
                        child: TextFormField(
                          controller: karakterController,
                          onChanged: (query) {
                            _filterCharacters(query);
                          },
                          cursorColor: Colors.black,
                          style: StyleApp.mediumInputTextStyle.copyWith(),
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            hintText: teks['searchhint'],
                            prefixIcon: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.all(10),
                            border: InputBorder.none,
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Image.asset('assets/Image/rickandmortytext.png')
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                    child: FutureBuilder(
                      future: _fetchData,
                      builder: (context, snapshot){
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                const SizedBox(height: 10),
                                Text(
                                  "Memuat Data",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            child: SingleChildScrollView(
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: characters.length,
                                itemBuilder: (context, index) {
                                  final character = characters[index];
                                  return GestureDetector(
                                      onTap: () {
                                        Get.to(() => DetailKarakter(characterData: character));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          border: Border.all(color: Colors.blueAccent.shade700),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                character['image'],
                                                height: 100,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      character['name'],
                                                      textAlign: TextAlign.center,
                                                      style: StyleApp.mediumTextStyle.copyWith(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      character['species'],
                                                      textAlign: TextAlign.center,
                                                      style: StyleApp.mediumTextStyle.copyWith(
                                                          color: Colors.grey
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      }
                    ),
                ),
              ],
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
