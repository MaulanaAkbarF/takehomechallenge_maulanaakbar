import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/BottomNavigationBar.dart';
import '../Style/styleapp.dart';
import 'package:get/get.dart';

class Setting extends StatefulWidget {
  static String routeName = '/login';
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<Map> teksUI = [
    {
      'Header': 'PENGATURAN',
      'SubHeader': 'Ubah preferensi anda dalam menggunakan aplikasi',
      'Email': 'Ubah Nama Panggilan Anda',
      'ButtonLogin': 'Simpan',

      'HeaderWarning2': 'Keluar dari Aplikasi?',
      'DescriptionWarning2': 'Tekan "Keluar" untuk menutup aplikasi'
    }
  ].cast<Map<String, String>>();

  final TextEditingController _usernameController = TextEditingController();

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
            child: Column(
              children: [
                for (final teks in teksUI)
                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                  text: teks['Header'],
                                  style: StyleApp.extraLargeTextStyle.copyWith(
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: [Colors.lightGreen, Colors.green],
                                        ).createShader(const Rect.fromLTWH(0.0, 0.0, 80.0, 100.0)),
                                      fontWeight: FontWeight.w900
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8,),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(teks['SubHeader'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: StyleApp.mediumTextStyle.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey
                                ),
                              ),
                            ),
                            const SizedBox(height: 16,),
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/Image/rickandmortysetting.png',
                              ),
                            ),
                            const SizedBox(height: 40,),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(teks['Email'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: StyleApp.mediumTextStyle.copyWith(
                                    fontWeight: FontWeight.bold
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
                                controller: _usernameController,
                                cursorColor: Colors.black,
                                style: StyleApp.mediumInputTextStyle.copyWith(),
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                  hintText: teks['searchhint'],
                                  prefixIcon: const Icon(Icons.person),
                                  contentPadding: const EdgeInsets.all(10),
                                  border: InputBorder.none,
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 40,
                                    minHeight: 40,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Material(
                                  color: Colors.greenAccent.shade400,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  borderRadius: BorderRadius.circular(8),
                                  child: InkWell(
                                    splashColor: Colors.green.shade800,
                                    highlightColor: Colors.green.shade600,
                                    onTap: () async {
                                      if (_validateInputs()) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                      }
                                    },
                                    child: SizedBox(
                                      height: 50,
                                      child: _isLoading
                                          ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 8),
                                          Text(
                                            'Tersimpan',
                                            style: StyleApp.largeInputTextStyle.copyWith(
                                                fontStyle: FontStyle.italic
                                            ),
                                          ),
                                        ],
                                      )
                                          : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            teks['ButtonLogin'],
                                            style: StyleApp.largeInputTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    String username = _usernameController.text.trim();
    if (username.isEmpty) {
      return false;
    }

    _saveUsernameToSharedPreferences(username);
    return true;
  }

  void _saveUsernameToSharedPreferences(String username) async {
    SharedPreferences usernamedata = await SharedPreferences.getInstance();
    usernamedata.setString('username', username);

    print('Username disimpan: $username');
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
                        Get.back();
                      },
                      child: const Text('Kembali'),
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
}