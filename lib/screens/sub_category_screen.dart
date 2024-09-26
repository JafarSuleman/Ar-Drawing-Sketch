import 'package:doodle_fun_play/components/ad_gridview.dart';
import 'package:doodle_fun_play/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../components/categories_drawer.dart';

class ImagesView extends StatefulWidget {
  const ImagesView({
    super.key,
    this.imageIndex,
    this.image,
    this.label,
  });

  final int? imageIndex;
  final String? image;
  final String? label;

  @override
  State<ImagesView> createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  BannerAd? _bannerAd;
  bool isAdLoaded = false;

  Future<void> loadAd() async {
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
    super.initState();
    loadAd();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      backgroundColor: const Color(0xffEAF8FE),
      appBar: AppBar(
        title: const Text(
          "Ar Drawing Sketch",
          style: TextStyle(
            fontFamily: 'orbitron',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: const Image(
          image: AssetImage('assets/appbar_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      drawer: const CategoriesDrawer(),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.popUntil(context, (route) => route.isFirst);
          return false;
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: Image.asset(
                          'assets/back.png',
                          color: Colors.black,
                          scale: 4.5,
                        )),
                    FittedBox(
                      child: Text(
                        widget.label.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'orbitron'),
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Image.asset(
                          'assets/back.png',
                          color: Colors.transparent,
                          scale: 4.5,
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RawScrollbar(
                thumbColor: const Color(0xff189EE9).withOpacity(0.2),
                thickness: 6,
                child: AnimationLimiter(
                    child: AdGridList(
                  image: widget.image!,
                  imageIndex: widget.imageIndex!,
                )),
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
