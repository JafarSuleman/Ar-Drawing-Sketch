import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upgrader/upgrader.dart';

import '../components/constants.dart';
import '../components/homescreen_drawer.dart';
import '../components/navigation_btn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double height(double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double width(double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  BannerAd? _bannerAd;
  bool isAdLoaded = false;

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdIds.bannerAdId,
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    loadAd();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      backgroundColor: const Color(0xffEAF8FE),
      drawerEnableOpenDragGesture: true,
      drawer: const HomeScreenDrawer(),
      appBar: AppBar(
        title: const Text(
          "Ar Drawing Sketch",
          style: TextStyle(fontFamily: 'orbitron',fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: const Image(
          image: AssetImage('assets/appbar_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      body: UpgradeAlert(
        upgrader: Upgrader(debugLogging: false,),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xff189EE9).withOpacity(0.5)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xffA0DEF9).withOpacity(0.5),
                            const Color(0xff189EE9),
                          ])),
                  child:  Center(
                    child: Text(
                      'Categories',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'orbitron'),
                    ),
                  )),
            ),
            Expanded(
              child: RawScrollbar(
                thumbColor: Colors.white38,
                trackColor: Colors.white,
                thumbVisibility: true,
                thickness: 7,
                child: AnimationLimiter(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.92,
                    child: GridView(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                      children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 1000),
                          childAnimationBuilder: (widget) => SlideAnimation(
                                verticalOffset:
                                    MediaQuery.of(context).size.width / 3,
                                child: FadeInAnimation(child: widget),
                              ),
                          children: [
                            NavigationButton(context: context, label: 'Alphabets', image: 'listPhoto/alphabet', index: 26, imagePath: 'alphabet/alphabet'),
                            NavigationButton(context: context, label: 'Numbers', image: 'digit/digit1', index: 10, imagePath: "digit/digit"),
                            NavigationButton(context: context, label: 'Sports', image: 'sports/sports5', index: 12, imagePath: 'sports/sports'),
                            NavigationButton(context: context, label: 'Anime', image: 'anime/anime1', index: 18, imagePath: 'anime/anime'),
                            NavigationButton(context: context, label: 'Trees', image: 'listPhoto/nature', index: 16, imagePath: "tree/tree"),
                            NavigationButton(context: context, label: 'Animals', image: 'listPhoto/animal', index: 16, imagePath: "animal/animal"),
                            NavigationButton(context: context, label: 'Fun', image: 'listPhoto/fun', index: 18, imagePath: 'fun/fun'),
                            NavigationButton(context: context, label: 'Nature', image: 'hill/hills10', index: 21, imagePath: 'hill/hills'),
                            NavigationButton(context: context, label: 'Birds ', image: 'flying/flyings7', index: 19, imagePath: 'flying/flyings'),
                            NavigationButton(context: context, label: 'Vehicles', image: 'listPhoto/vehicle', index: 16, imagePath: "car/car"),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
            if(isAdLoaded)
              SizedBox(
                height: _bannerAd?.size.height.toDouble(),
                width: _bannerAd?.size.width.toDouble(),
                child: isAdLoaded
                    ? AdWidget(ad: _bannerAd!,)
                    : const SizedBox(),
              ),
          ],
        ),
      ),
    );
  }

}
