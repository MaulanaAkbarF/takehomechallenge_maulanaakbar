import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Components/BottomNavigationBar.dart';
import '../Style/styleapp.dart';
import 'package:get/get.dart';
import 'Setting.dart';

class Enter extends StatefulWidget {
  static String routeName = '/login';
  const Enter({super.key});

  @override
  State<Enter> createState() => _EnterState();
}

class _EnterState extends State<Enter> {
  final List<Map> teksUI = [
    {
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
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [Colors.white, Colors.white],
                ),
              ),
              child: Image.asset(
                'assets/Image/rickandmorty.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        loginTap();
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [Colors.blue.shade700, Colors.lightBlueAccent],
                            ).createShader(bounds);
                          },
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            text: TextSpan(
                              text: "MASUK",
                              style: StyleApp.giganticTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50,),
                    GestureDetector(
                      onTap: () {
                        settingTap();
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Text("Pengaturan",
                          style: StyleApp.hugeTextStyle.copyWith(
                              letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginTap() {
    Get.to(() => const CustomBottomNavigationBar(), transition: Transition.leftToRightWithFade);
  }

  void settingTap() {
    Get.to(() => const Setting(), transition: Transition.leftToRightWithFade);
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