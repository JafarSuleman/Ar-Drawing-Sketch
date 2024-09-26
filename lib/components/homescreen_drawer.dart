import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/camera_screen.dart';

class HomeScreenDrawer extends StatefulWidget {
  const HomeScreenDrawer({super.key});

  @override
  State<HomeScreenDrawer> createState() => _HomeScreenDrawerState();
}

class _HomeScreenDrawerState extends State<HomeScreenDrawer> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double percentage) {
      return MediaQuery.of(context).size.width * percentage;
    }

    return Drawer(
      width: width(0.55),
      backgroundColor: const Color(0xffEAF8FE),
      child: Container(
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          const Color(0xff189EE9).withOpacity(0.7),
          const Color(0xffA0DEF9),
        ])),
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
              child: Text(
                'Enjoy Drawing\nAnd Sketching',
                style: TextStyle(
                    fontFamily: 'orbitron',
                    fontSize: (screenWidth / 100) * 4,
                    color: Colors.black,
                    fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                try {
                  final picker = ImagePicker();
                  final pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _image = File(pickedImage.path);
                    });
                    if (context.mounted) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CameraScreen(
                                imageData: _image,
                              )));
                    }
                    //  }
                  }
                } catch (e) {
                  var status = await Permission.photos.status;
                  if (status.isDenied) {
                    Permission.photos.request();
                  } else if (status.isPermanentlyDenied) {
                    openAppSettings();
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.photo,
                      color: Colors.black,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(
                          fontFamily: 'orbitron',
                          fontSize: (screenWidth / 100) * 3.7,
                          color: Colors.black,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                final InAppReview inAppReview = InAppReview.instance;
                if (await inAppReview.isAvailable()) {
                  Future.delayed(const Duration(seconds: 2), () {
                    inAppReview.requestReview();
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.star_rate_outlined,
                      color: Colors.black,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Rate us',
                      style: TextStyle(
                          fontFamily: 'orbitron',
                          fontSize: (screenWidth / 100) * 3.7,
                          color: Colors.black,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                try {
                  Share.share(
                      'https://play.google.com/store/apps/details?id=ardrawing.sketch.paint',
                      subject:
                          'Check out this amazing drawing and painting app!');
                  //    setState(() {});
                } catch (e) {}
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.share_sharp,
                      color: Colors.black,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Share App',
                      style: TextStyle(
                          fontFamily: 'orbitron',
                          fontSize: (screenWidth / 100) * 3.7,
                          color: Colors.black,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () async {
                final Uri url = Uri.parse(
                    'https://privacypolicy09876.blogspot.com/2024/04/privacy-policy.html');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.privacy_tip,
                      color: Colors.black,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                          fontFamily: 'orbitron',
                          fontSize: (screenWidth / 100) * 3.7,
                          color: Colors.black,
                          fontWeight: FontWeight.w900),
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
}
