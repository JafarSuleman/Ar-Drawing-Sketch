import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../screens/sub_category_screen.dart';
import 'ad_gridview.dart';
import 'constants.dart';

class NavigationButton extends StatefulWidget {
  const NavigationButton({
    super.key,
    required this.context,
    required this.label,
    required this.image,
    required this.index,
    required this.imagePath,
  });

  final BuildContext context;
  final String label;
  final String image;
  final int index;
  final String imagePath;

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;
  int _adCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdIds.interAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
            _isAdReady = true;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _isAdReady = false;
          });
          Future.delayed(Duration(seconds: 5), _loadInterstitialAd);
        },
      ),
    );
  }

  Future<void> _showInterstitialAd() async {
    if (_interstitialAd != null && _isAdReady) {
      await _interstitialAd!.show();
      setState(() {
        _isAdReady = false;
        _interstitialAd = null;
      });
    } else {
      print('Ad is not ready yet'); // Logging if ad is not ready
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width / 100;

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () async {
          _adCount++;
          if (_adCount >= 2 && _interstitialAd != null) {
            _adCount = 0;
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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

            await Future.delayed(Duration(seconds: 1)); // Wait for the delay
            Navigator.of(context).pop(); // Close the dialog
            await _showInterstitialAd(); // Show the interstitial ad
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImagesView(
                image: widget.imagePath,
                imageIndex: widget.index,
                label: widget.label,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                spreadRadius: 1,
                blurRadius: 1,
                color: const Color(0xff189EE9).withOpacity(0.3),
              )
            ],
          ),
          child: Column(
            children: [
              Expanded(
                flex: 9,
                child: Image.asset('assets/${widget.image}-min.png'),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade400.withOpacity(0.5),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xffA0DEF9),
                        Color(0xff189EE9),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'orbitron',
                        fontSize: screenWidth * 3,
                        letterSpacing: 2,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
