import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Style/styleapp.dart';

class DetailKarakter extends StatefulWidget {
  static String routeName = '/detailkarakter';

  final Map<String, dynamic>  characterData;
  const DetailKarakter({Key? key, required this.characterData}) : super(key: key);

  @override
  State<DetailKarakter> createState() => _DetailKarakterState();
}

class _DetailKarakterState extends State<DetailKarakter> {
  late Map<String, dynamic> characterDataReceived;
  late List<Map<String, dynamic>> characters = [];
  late List<Map> teksUI;

  @override
  void initState() {
    super.initState();
    characterDataReceived = widget.characterData;
    teksUI = [
      {
        'Header': '$characterDataReceived',
      }
    ].cast<Map<String, String>>();

    getCharacterData();
  }

  Future<void> getCharacterData() async {
    final response = await http.get(Uri.parse("https://rickandmortyapi.com/api/character/$characterDataReceived"));

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

  void _showFullScreenImage() {
    List<PhotoViewGalleryPageOptions> images = [
      PhotoViewGalleryPageOptions(
        imageProvider: NetworkImage(characterDataReceived['image']),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
      ),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewGallery.builder(
          itemCount: images.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: images[index].imageProvider,
              minScale: images[index].minScale,
              maxScale: images[index].maxScale,
            );
          },
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          scrollPhysics: BouncingScrollPhysics(),
          pageController: PageController(),
          onPageChanged: (index) {
            // Callback ketika halaman berubah
          },
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget buildLink(String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Align(
            alignment: FractionalOffset.topLeft,
            child: Row(
              children: [
                Text('$label ',
                  style: StyleApp.mediumTextStyle.copyWith(
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    url,
                    style: StyleApp.mediumTextStyle.copyWith(
                      color: Colors.blue,
                      // decoration: TextDecoration.underline,
                      fontWeight: label == "Origin" ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: _showFullScreenImage,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          characterDataReceived['image'],
                          width: double.infinity,
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back),
                          const SizedBox(width: 5,),
                          GestureDetector(
                            onTap: (){
                              Get.back();
                            },
                            child: Text("Kembali",
                                style: StyleApp.mediumTextStyle.copyWith(
                                  fontWeight: FontWeight.bold
                                )
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // for (final teks in teksUI)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: IntrinsicWidth(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "ID: ",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${characterDataReceived['id']}",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Nama: ",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${characterDataReceived['name']}",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Status: ",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${characterDataReceived['status']}",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Tipe: ",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${characterDataReceived['type']}",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Jenis Kelamin: ",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${characterDataReceived['gender']}",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Dibuat pada: ",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${characterDataReceived['created']}",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16,),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    width: 200,
                                    height: 1,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16,),
                                buildLink("URL Asal", characterDataReceived['origin']['url']),
                                buildLink("URL Lokasi", characterDataReceived['location']['url']),
                                buildLink("URL Karakter", characterDataReceived['url']),
                                const SizedBox(height: 10,),
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Tampil di episode: ",
                                          style: StyleApp.mediumTextStyle.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                for (var episodeUrl in characterDataReceived['episode'])
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.blue.shade400)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                                        child: buildLink("", episodeUrl),
                                      )
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}