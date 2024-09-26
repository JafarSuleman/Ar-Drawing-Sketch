import 'package:doodle_fun_play/components/constants.dart';
import 'package:doodle_fun_play/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;

  void loadAd() {
    nativeAd = NativeAd(
        adUnitId: "ca-app-pub-1032592643227979/7546018103" ,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.medium,
            mainBackgroundColor: const Color(0xff189EE9).withOpacity(0.5),
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.white,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }

  @override
  void initState() {
    super.initState();
    //loadAd();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const
      Color(0xffEAF8FE),
      appBar: AppBar(
        //   toolbarHeight: 70,
        title: const Text(
          "Ar Drawing Sketch",
          style: TextStyle(fontFamily: 'orbitron'),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: const Image(
          image: AssetImage('assets/appbar_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      // drawer: const BuildDrawer(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xff189EE9).withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xffA0DEF9).withOpacity(0.5),
                          const Color(0xff189EE9),
                        ])),
                child:  Center(
                  child: Text(
                    'Draw Your Favourite Sketch',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: (screenWidth/100) * 4 ,
                        fontFamily: 'orbitron'),
                  ),
                )),
            _nativeAdIsLoaded == true
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.7,
                    //   color: Color(0xff189EE9),
                    child: Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: AdWidget(ad: nativeAd!),
                      ),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.7,
                    // color: Colors.pink.withOpacity(0.6),
                  ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xffA0DEF9).withOpacity(0.5),
                            const Color(0xff189EE9),
                          ])),
                  child:  Center(
                    child: Text(
                      'Lets Start Drawing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: (screenWidth/100) * 4 ,
                          fontFamily: 'orbitron'),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
