import 'package:ad_gridview/ad_gridview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../screens/camera_screen.dart';
import 'constants.dart';

class AdGridList extends StatefulWidget {
  final String image;

  // final BannerAd bannerAd;
  final int imageIndex;

  const AdGridList({
    super.key,
    required this.image,
    required this.imageIndex,
    // required this.bannerAd,
  });

  @override
  State<AdGridList> createState() => _AdGridListState();
}

class _AdGridListState extends State<AdGridList> {
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
              },
              onAdFailedToShowFullScreenContent:
                  (InterstitialAd ad, AdError error) {
                ad.dispose();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            isAdReady = false;
          },
        ),
      );
    } catch (e) {}
  }

  Future<void> _showInterstitialAd() async {
    // if (interstitialAd == null) {
    //   return;
    // }
    await interstitialAd!.show();
    isAdReady = false;
  }

  @override
  void initState() {
    loadInterstitialAd();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.95,
      child: AdGridView(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        itemCount: widget.imageIndex,
        adIndex: 3,
        adGridViewType: AdGridViewType.repeated,
        adWidget: const SizedBox(),
        itemWidget: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: AnimationConfiguration.staggeredGrid(
                position: index,
                columnCount: 1,
                duration: const Duration(milliseconds: 800),
                child: SlideAnimation(
                    verticalOffset: MediaQuery.of(context).size.width / 3,
                    child: FadeInAnimation(
                        curve: Curves.linear,
                        child: InkWell(
                          onTap: () {
                            adCount++;
                            // if(adCount == 5 && isAdReady == true){
                            //   _showInterstitialAd();
                            //     adCount = 0;
                            // }
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => CameraScreen(
                            //               imagePath:
                            //                   'assets/${widget.image + (index + 1).toString()}-min.png',
                            //             )));
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CameraScreen(
                                              imagePath:
                                                  'assets/${widget.image + (index + 1).toString()}-min.png',
                                            )));
                              });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CameraScreen(
                                            imagePath:
                                                'assets/${widget.image + (index + 1).toString()}-min.png',
                                          )));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  color: Colors.black12.withOpacity(0.1),
                                )
                              ],
                            ),
                            child: Image.asset(
                                'assets/${widget.image + (index + 1).toString()}-min.png'),
                          ),
                        )))),
          );
        },
      ),
    );
  }
// void _handleButtonPress() {
//   if (_interstitialAd != null) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             padding: EdgeInsets.all(20),
//             child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                       ),
//                     ),
//
//                   ],
//                 )),
//           ),
//         );
//       },
//     );
//
//     Future.delayed(Duration(milliseconds: 800), () {
//       Navigator.of(context).pop(); // Close the dialog
//       _showInterstitialAd();
//     });
//   } else {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => CameraScreen(
//               imagePath:
//               'assets/${widget.image + (index + 1).toString()}-min.png',
//             )));
//   }
// }
}
