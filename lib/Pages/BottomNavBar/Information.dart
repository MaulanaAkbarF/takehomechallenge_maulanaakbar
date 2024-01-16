import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Style/styleapp.dart';

class Information extends StatefulWidget {
  static String routeName = '/login';
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final List<Map> teksUI = [
    {
      'Header': 'Informasi Aplikasi',
      'tTitle': 'Judul: ',
      'tCreated': 'Dibuat tanggal: ',
      'Title': 'Rick and Morty by Maulana',
      'Created': '14 Januari 2024',

      'tdesign': 'Desain Aplikasi: ',
      'tdbms': 'Desain Manajemen Database: ',
      'tfrontend': 'Pengembangan Front-End: ',
      'tbackend': 'Pengembangan Back-End: ',
      'tdebug': 'Penjamin Kualitas dan Kontrol: ',
      'myname': 'Maulana Akbar Firdausya',

      'HeaderWarning2': 'Keluar dari Aplikasi?',
      'DescriptionWarning2': 'Tekan "Keluar" untuk menutup aplikasi'
    }
  ].cast<Map<String, String>>();

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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: SingleChildScrollView(
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
                                colors: [Colors.green, Colors.yellow],
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: IntrinsicWidth(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['tTitle'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['Title'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['tCreated'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['Created'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40,),
                                Row(
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['tdesign'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['myname'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['tdbms'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['myname'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['tfrontend'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['myname'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['tbackend'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['myname'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['tdebug'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(teks['myname'],
                                        style: StyleApp.mediumTextStyle.copyWith(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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