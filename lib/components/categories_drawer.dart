import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../screens/camera_screen.dart';
import '../screens/sub_category_screen.dart';
import 'constants.dart';

class CategoriesDrawer extends StatefulWidget {
  const CategoriesDrawer({super.key});

  @override
  State<CategoriesDrawer> createState() => _CategoriesDrawerState();
}

class _CategoriesDrawerState extends State<CategoriesDrawer> {
  File? _image;
  ScrollController? _scrollController;

  double height(double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double width(double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  InterstitialAd? interstitialAd;
  bool isAdReady = false;

  int adCount = 0;


  Future<void> loadInterstitialAd() async {
    try {
      InterstitialAd.load(
        adUnitId: AdIds.interAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            setState(() {
              interstitialAd = ad;
              isAdReady = true;
            });
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                ad.dispose();
             //   loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (InterstitialAd ad,
                  AdError error) {
                ad.dispose();
              //  loadInterstitialAd();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            isAdReady = false;
          },
        ),
      );
    }catch(e){}
  }

  Future<void> _showInterstitialAd() async {
    if (interstitialAd == null) {
      return;
    }
    await interstitialAd!.show();
    isAdReady=false;
  }


  @override
  void initState() {
    super.initState();
    loadInterstitialAd();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      backgroundColor: const Color(0xffFF69B4),
      width: width(0.49),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xff189EE9),
                  Color(0xffA0DEF9),
                ])
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            const SizedBox(height: 70,),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
              child: Text(
                'Select Categories',
                style: TextStyle(
                  fontFamily: 'orbitron',
                    fontSize: (screenWidth / 100) * 3.5, color: Colors.black,fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: RawScrollbar(
                thumbVisibility: true,
                interactive: true,
                thumbColor: Colors.white30,
                controller: _scrollController,
                radius: const Radius.circular(5),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildDrawerBtn(context, 'Alphabets', 'alphabet/alphabet', 26),
                      buildDrawerBtn(context, 'Numbers',   'digit/digit',       10),
                      buildDrawerBtn(context, 'Sports',    'sports/sports',     12),
                      buildDrawerBtn(context, 'Anime',     'anime/anime',       18),
                      buildDrawerBtn(context, 'Trees',     'tree/tree',         16),
                      buildDrawerBtn(context, 'Animals',   'animal/animal',     16),
                      buildDrawerBtn(context, 'Fun',       'fun/fun',           18),
                      buildDrawerBtn(context, 'Nature',    'hill/hills',        21),
                      buildDrawerBtn(context, 'Birds',     'flying/flyings',    19),
                      buildDrawerBtn(context, 'Vehicles',  'car/car',           16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      _pickImage(ImageSource.gallery,context);
                    },
                    child: Container(
                      //height: height(0.095),
                     // width: width(0.4),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                       // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.photo,color: Colors.black,size: 30,),
                          const SizedBox(width: 5,),
                          Text(
                            'Gallery',
                            style: TextStyle(
                              fontFamily: 'orbitron',
                                fontSize: (screenWidth / 100) * 3.5,
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () async {
                      try {
                        Share.share(
                            'https://play.google.com/store/apps/details?id=ardrawing.sketch.paint',
                            subject:
                                'Check out this amazing drawing and painting app!');
                        setState(() {});
                      } catch (e) {
                      }
                    },
                    child:  Container(
                      //height: height(0.095),
                      // width: width(0.4),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.share,color: Colors.black,size: 25,),
                          const SizedBox(width: 5,),
                          Text(
                            'Share',
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
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, BuildContext ctx) async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
        // if (!context.mounted) {
        if (ctx.mounted) {
          Navigator.of(ctx).push(MaterialPageRoute(
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
      } else if(status.isPermanentlyDenied){
        openAppSettings();
      }
    }
  }

  InkWell buildDrawerBtn(BuildContext context, label, imagePath, index) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () {
          adCount++;
          // if(adCount > 2 ){
          //   adCount = 0;
          // }
          if (adCount == 5 && interstitialAd != null) {
            adCount = 1;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.all(20),
                    child: Center(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            Text("Ad is Loading..."),
                            CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ],
                        )),
                  ),
                );
              },
            );

            Future.delayed(Duration(seconds: 1), () async {
              Navigator.of(context).pop(); // Close the dialog
              await _showInterstitialAd();
            });
          }
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ImagesView(
                        imageIndex: index,
                        image: imagePath,
                        label: label,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Column(
            children: [
              const SizedBox(width: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    " $label",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: (screenWidth / 100) * 3.2,
                        color: Colors.black,
                        fontFamily: 'orbitron',
                        fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: (screenWidth / 100) * 4,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ));
  }
}
