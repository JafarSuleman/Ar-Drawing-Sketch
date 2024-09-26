import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'constants.dart';

class NativeAdmob extends StatefulWidget{
  const NativeAdmob({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NativeAdmobState();
  }
}

class _NativeAdmobState extends State<NativeAdmob>{

  NativeAd? nativeAd;
  bool _nativeAdIsLoaded = false;

  void loadAd() {
    nativeAd = NativeAd(
        adUnitId:  DevAdIds.nativeAdID,
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
          // Required: Choose a template.
            templateType: TemplateType.small,
            mainBackgroundColor: Colors.pink.withOpacity(0.6),
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
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
   loadAd();
  }
  @override
  Widget build(BuildContext context) {
    return _nativeAdIsLoaded== true? SizedBox(
      height: 130,
      child:  Container(
        height: 130.0,
        alignment: Alignment.center,
        child: AdWidget(ad: nativeAd!),
      ),
    ) : const SizedBox();
  }
}